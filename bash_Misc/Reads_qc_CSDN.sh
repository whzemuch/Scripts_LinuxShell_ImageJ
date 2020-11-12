#!/usr/bin/env bash

# --------------------- 
# ���ߣ�sunchengquan 
# ��Դ��CSDN 
# ԭ�ģ�https://blog.csdn.net/sunchengquan/article/details/85470784 
# ��Ȩ����������Ϊ����ԭ�����£�ת���븽�ϲ������ӣ�
# -------------------------

set -e

settings(){
        samples=/mnt/f/NGS_Projects/salivary/samples          # change according to the specific project
        if test -w $samples;then
                mkdir -p {$samples/qc,$samples/cleandata/qc}   
        else
                echo "û��д��Ȩ��"
        fi

}

# 2/16/19  the mkfifo command let you creat FIFO(a.k.a named pipes)
thread(){
        tmp_fifofile="/tmp/$$.fifo" #�ű����еĵ�ǰ����ID����Ϊ�ļ��� 
    mkfifo "$tmp_fifofile" 
    exec 6<>"$tmp_fifofile"  #��fd6ָ��fifo����
    rm $tmp_fifofile
    thread_num=$1 # �˴������߳���
    for((i=0;i<$thread_num;i++));do 
        echo 
    done >&6 # ��ʵ�Ͼ�����fd6�з�����$thread���س���
    $2 6 $3
    exec 6>&- # �ر�df6 
}


qc(){
        source activate RNA
        printf "[%s %s %s %s %s %s]::������������\n" $(echo `date`)
        start=$(date +%s.%N)
        list=$(find $2 -name *q\.gz)
        file_num=`ls -l $2/qc|wc -l`
        if [ $file_num -lt 2 ];then
                for i in $list;do
                        read -u$1
                        {
                        name=`awk -v each=$i 'BEGIN{split(each,arr,"/");l=length(arr);print arr[l]}' `
                        fastqc  $i -o $2/qc  &>> $2/qc/qc.log
                        printf "[%s %s %s %s %s %s]::%s�����������\n" $(echo `date`) $name
                        echo >&$1 
                        } &
                done && wait

                multiqc -d $2/qc -o $2/qc 
                dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l) 
                printf "[%s %s %s %s %s %s]::��������������ʱ%.2f����\n" $(echo `date`) $dur
        fi
        source deactivate RNA
}

trim_qc(){
        printf "[%s %s %s %s %s %s]::������������\n" $(echo `date`)
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
                        printf "[%s %s %s %s %s %s]::%s�����������\n" $(echo `date`) $name
                        echo >&$1
                        } &
                done && wait 
                dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
                printf "[%s %s %s %s %s %s]::�����������ƺ�ʱ%.2f����\n" $(echo `date`) $dur
        fi
        source deactivate RNA
}


settings
thread 6 qc $samples
thread 3 trim_qc 
thread 6 qc $samples/cleandata


