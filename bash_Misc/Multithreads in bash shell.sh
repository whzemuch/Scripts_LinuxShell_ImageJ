#!/usr/bin/env bash

set -e

settings(){
        samples=/data/Data_base/test_tmp/RNA_seq_practice/chrX_data/samples
        if test -w $samples;then
                mkdir -p {$samples/qc,$samples/cleandata/qc}   
        else
                echo "没有写入权限"
        fi

}


thread(){
        tmp_fifofile="/tmp/$$.fifo" #脚本运行的当前进程ID号作为文件名 
    mkfifo "$tmp_fifofile" 
    exec 6<>"$tmp_fifofile"  #将fd6指向fifo类型
    rm $tmp_fifofile
    thread_num=$1 # 此处定义线程数
    for((i=0;i<$thread_num;i++));do 
        echo 
    done >&6 # 事实上就是在fd6中放置了$thread个回车符
    $2 6 $3
    exec 6>&- # 关闭df6
}


qc(){
        source activate RNA
        printf "[%s %s %s %s %s %s]::数据质量评估\n" $(echo `date`)
        start=$(date +%s.%N)
        list=$(find $2 -name *q\.gz)
        file_num=`ls -l $2/qc|wc -l`
        if [ $file_num -lt 2 ];then
                for i in $list;do
                        read -u$1
                        {
                        name=`awk -v each=$i 'BEGIN{split(each,arr,"/");l=length(arr);print arr[l]}' `
			# name=${i##*/} use shell variable expansion  by HW 5/11/2019
                        fastqc  $i -o $2/qc  &>> $2/qc/qc.log
                        printf "[%s %s %s %s %s %s]::%s质量评估完成\n" $(echo `date`) $name
                        echo >&$1 
                        } &
                done && wait

                multiqc -d $2/qc -o $2/qc 
                dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l) 
                printf "[%s %s %s %s %s %s]::数据质量评估耗时%.2f分钟\n" $(echo `date`) $dur
        fi
        source deactivate RNA
}

trim_qc(){
        printf "[%s %s %s %s %s %s]::数据质量控制\n" $(echo `date`)
        source activate RNA
        start=$(date +%s.%N)
        dir=$samples/cleandata
        find $samples -name *1?f*q?gz|sort >$dir/1
        find $samples -name *2?f*q?gz|sort >$dir/2
        paste -d ":" $dir/1 $dir/2  > $dir/config && rm $dir/1 $dir/2
        file_num=`ls -l $dir|wc -l`
        
        if [ $file_num -lt 3 ];then
                for id in `cat $dir/config`;do
                        read -u$1
                        fq1=$(echo $id|cut -d":" -f1)
                        fq2=$(echo $id |cut -d":" -f2)
                        base_name=$(basename $fq1)
                        name=`awk -v each=$base_name 'BEGIN{split(each,arr,"_");print arr[1]}' ` 
                        {
                        trim_galore -q 25 --phred33 --length 25 --stringency 3 --paired -o $dir $fq1 $fq2 &> $dir/trim.log
                        printf "[%s %s %s %s %s %s]::%s质量控制完成\n" $(echo `date`) $name
                        echo >&$1
                        } &
                done && wait 
                dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
                printf "[%s %s %s %s %s %s]::数据质量控制耗时%.2f分钟\n" $(echo `date`) $dur
        fi
        source deactivate RNA
}


settings
thread 6 qc $samples
thread 3 trim_qc 
thread 6 qc $samples/cleandata
# --------------------- 
# 作者：sunchengquan 
# 来源：CSDN 
# 原文：https://blog.csdn.net/sunchengquan/article/details/85470784 
# 版权声明：本文为博主原创文章，转载请附上博文链接！


Shell script for running in multiple processes
Leave a reply
If you wanna using multiple processes in shell script, you’d better use file descriptor to control it.
For example you want to process the files in current directory




# Author: ChillRain
# Source:https://i.chillrain.com/index.php/shell-script-for-running-in-multiple-processes/



#!/bin/bash
exec 3< <(ls ~)

for i in 1 2
do
(while read; do echo "Process $i received $REPLY."; sleep 1;done) <&3 &
done

wait

Of course, you can write it more commonly, just like



#!/bin/bash
function a_sub
{
sleep 3
}
tmp_fifofile="/tmp/$$.fifo"
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile
rm $tmp_fifofile

thread=15
for((i=0;i<$thread;i++));do
echo
done >&6
for((i=0;i<50;i++));do
read -u 6
{
a_sub && {
echo "a_sub is finished"
} || {
echo "sub error"
}
echo >&6
}&
done

exec 6>&-
wait
