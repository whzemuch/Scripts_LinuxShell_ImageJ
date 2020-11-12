#!/usr/bin/env bash

# ---------------------------------------------------------------------------------------------------------------- 
# ���ߣ�sunchengquan 
# ��Դ��CSDN 
# ԭ�ģ�https://blog.csdn.net/sunchengquan/article/details/85470784 
# ��Ȩ����������Ϊ����ԭ�����£�ת���븽�ϲ������ӣ�

# Below are from https://blog.csdn.net/sunchengquan/article/details/85470784#_379 writen by sunchenquan, which cited a nature protocol paper
# Transcript-level expression analysis of RNA-seq experiments with HISAT, StringTie and Ballgown Protocol  Nature Protocols volume 11, pages 1650�C1667 (2016)
# This script define function first and then use them later, which make it very easy to understand and follow.
# ----------------------------------------------------------------------------------------------------------------

# Exit this script on any error. (from HANDBOOKS )
set -euo pipefail 

# set up the path for samples, output, refernece genome index

settings(){
        samples=/data/Data_base/test_tmp/RNA_seq_practice/chrX_data/samples
        index=/data/Data_base/test_tmp/RNA_seq_practice/chrX_data/genome/index
        output=/data/Data_base/test_tmp/RNA_seq_practice/chrX_data/hisat+stringtie

        if test -w $(dirname $output) &&  test -w $(dirname index);then
                mkdir -p {$index/hisat2,$output/1_hisat,$output/2_stringtie,$output/3_ballgown,$output/4_DE}
        fi

        hisat=$output/1_hisat
        stringtie=$output/2_stringtie
        ballgown=$output/3_ballgown
        genome=/data/Data_base/test_tmp/RNA_seq_practice/chrX_data/genome/chrX.fa
        gene=/data/Data_base/test_tmp/RNA_seq_practice/chrX_data/genes/chrX.gtf
}


thread(){
    tmp_fifofile="/tmp/$$.fifo" 
    mkfifo "$tmp_fifofile" 
    exec 6<>"$tmp_fifofile"  
    rm $tmp_fifofile
    thread_num=$1

    for((i=0;i<$thread_num;i++));do 
        echo 
    done >&6 
    $2 6 
    exec 6>&- 
}



# index(){
#         printf "[%s %s %s %s %s %s]::��������hisat2-build\n" $(echo `date`)
#         start=$(date +%s.%N)
#         file_num=`ls -l $index/hisat2|wc -l`
# 
#         source activate RNA
#         base_name=$(basename $genome)
#                 name=`awk -v each=$base_name 'BEGIN{split(each,arr,".");print arr[1]}' ` 
#         if [ $file_num -lt 2 ];then
#                                 hisat2_extract_exons.py $gene >$index/hisat2/$name'.exon'
#                                 hisat2_extract_splice_sites.py $gene >$index/hisat2/$name'.ss'
#                                 hisat2-build --ss $index/hisat2/$name'.ss' --exon $index/hisat2/$name'.exon' $genome $index/hisat2/$name 1>$index/hisat2/index.log 2>&1
#                                 dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
#                 printf "[%s %s %s %s %s %s]::����������ʱ%.2f����\n" $(echo `date`) $dur
#         fi
#         source deactivate RNA
#         
# }


mapping(){
        printf "[%s %s %s %s %s %s]::��ο�������ȶ�hisat2\n" $(echo `date`)
    start=$(date +%s.%N)
    dir=$output/1_hisat
    find $samples/cleandata -name *1?f*q.gz|sort > $dir/1
    find $samples/cleandata -name *2?f*q.gz|sort > $dir/2
    paste -d ":" $dir/1 $dir/2  > $dir/config && rm $dir/1 $dir/2
    file_num=`ls -l $dir|wc -l`
    index_prefix=`awk -v each=$(basename $genome) 'BEGIN{split(each,arr,".");print arr[1]}' `

    source activate RNA
    if [ $file_num -lt 3 ];then
        for id in $(cat $dir/config);do
            fq1=$(echo $id|cut -d":" -f1)
            fq2=$(echo $id |cut -d":" -f2)
            name=`awk -v each=$(basename $fq1) 'BEGIN{split(each,arr,"_");print arr[1]}' ` 
            read -u$1
            {
                        hisat2 -p 8 --dta -x $index/hisat2/${index_prefix} -1 $fq1 -2 $fq2 -S $dir/${name}.sam &> $dir/${name}.hisat.log
                        samtools sort -@ 8 -o $dir/${name}.bam $dir/${name}.sam &> /dev/null && rm $dir/${name}.sam 
            printf "[%s %s %s %s %s %s]::%s�ȶ����\n" $(echo `date`) $name
            echo >&$1
            } &
        done && wait
        dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
                printf "[%s %s %s %s %s %s]::�ȶԺ�ʱ%.2f����\n" $(echo `date`) $dur
    fi
    source deactivate RNA

}

# assemble(){
#         printf "[%s %s %s %s %s %s]::ת¼����װstringtie\n" $(echo `date`)
#         start=$(date +%s.%N)
#         dir=$output/2_stringtie
#         file_num=`ls -l $dir|wc -l`
#         source activate RNA
#         if [ $file_num -lt 3 ];then
#                 for id in $output/1_hisat/*.bam;do
#                         base_name=$(basename $id)
#                         i=${base_name%.bam*}
#                         read -u$1
#                         {
#                         stringtie -p 8 -G $gene -o $dir/${i}.gtf -l $i $output/1_hisat/${i}.bam &>> $dir/assemble.log
#                         printf "[%s %s %s %s %s %s]::%sת¼����װ���\n" $(echo `date`) $i
#                         echo >&$1
#                         } &
#                 done && wait
#                 dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
#                 printf "[%s %s %s %s %s %s]::ת¼����װ��ʱ%.2f����\n" $(echo `date`) $dur
#         fi
#         source deactivate RNA
# }


merge(){
        printf "[%s %s %s %s %s %s]::ת¼���ϲ�stringtie --merge\n" $(echo `date`)
        start=$(date +%s.%N)
        dir=$output/2_stringtie
        find $dir -name *?gtf|grep -v '.*merge.gtf'|sort > $dir/mergelist.txt
        source activate RNA
        if [ ! -f $dir/stringtie_merge.gtf ];then
                stringtie --merge -p 8 -G $gene -o $dir/stringtie_merge.gtf $dir/mergelist.txt
                dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
                printf "[%s %s %s %s %s %s]::ת¼���ϲ���ʱ%.2f����\n" $(echo `date`) $dur
        fi      
        source deactivate RNA
}

# count(){
#         printf "[%s %s %s %s %s %s]::ת¼�������򣩵Ķ�����stringtie\n" $(echo `date`)  
#         start=$(date +%s.%N)
#         dir=$output/3_ballgown
#         file_num=`ls -l $dir|wc -l`
#         source activate RNA
#         if [ $file_num -lt 3 ];then
#                 for id in $(cat $output/2_stringtie/mergelist.txt);do
#                         base_name=$(basename $id)       
#                         name=${base_name%.gtf}
#                         read -u$1
#                         {
#                         stringtie -B -p 8 -G $output/2_stringtie/stringtie_merge.gtf -o $dir/$name/$base_name $output/1_hisat/${name}.bam &>> $dir/count.log
#                         printf "[%s %s %s %s %s %s]::%sת¼���������\n" $(echo `date`) $name
#                         echo >&$1
#                         } &
#                 done && wait
#                 dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
#                 printf "[%s %s %s %s %s %s]::ת¼���ϲ���ʱ%.2f����\n" $(echo `date`) $dur
#         fi
#         source deactivate RNA
# }


settings
# index
thread 4 mapping
# thread 6 assemble
# merge
thread 6 count

