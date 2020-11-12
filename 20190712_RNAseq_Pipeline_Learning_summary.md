- RNAseq pipeline summary
   Nature. 2018 Jan 25;553(7689):506-510. doi: 10.1038/nature25435. Epub 2018 Jan 17.

- The target is the sra lists as below.

  SRR4820707
  SRR4820708
  SRR4820709
  SRR4820710
  SRR4820727
  SRR4820728
  SRR4820729
  SRR4820730

- I tried to use aspera.sh to download those files and got the error message"no such file", then I tried to use aspc command to download the single file, found that some files can be downloaded, some files do not exit(like 729, 730, 708), then I checked the ftp address to confirmed that, next I went to pubmed to search sra database to get the RunTable, the result showed that those sras are in the another database(sra-sos).

- Then I remembered that I have read a post on biostars.org to down load sra files from ENA(https://www.ebi.ac.uk/ena), I searched the Vim-shortcuts.md to get the address of this post([Fast download of FASTQ files from the European Nucleotide Archive(ENA)@BioStars by ATpint Germany](https://www.biostars.org/p/325010/)), In this post, the poster downloaded the study accession(sra id), experiment title and FASTQ file(FTP) as accession.txt,then use a complicated awk command to convert to another file named download.txt, in this file each line contains a aspera command to download one sra file from ENA. However, it is a little bit tedious. Then I remembered that I found a nice tool to complete this work, I searched "SRR Explore" in Vim-shortcuts.md, getpocket.com, and found nothing. Then I used google to search it and found that the correct name is "sra explorer".

- [SRA Explorer](https://ewels.github.io/sra-explorer/) is a very nice tool. It will help you find SRA and FastQ download URLs in a couple of clicks. You can choose to download sra files or FASTQ files from ENA, also it generate command lines for urls, bash script downloading, aspera command downloading(only support FASTQ files 7/12/19)

 - I use `script session_20190712.log` command to record the process how I download those fastq files. I need to add --timing=time.txt option so that I can use
 `scriptreplay --timing=time.txt session.log `to replay the whole process. just Run `bash sra_explorer_fastq_aspera_download .sh`command to download those files,
 the speed is about 100mb/s. The aspera command inside sh file for each sra looks like as below:

----------------------------------------------------------------------------
  ascp -QT -l 300m -P33001 -i $HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR482/009/SRR4820709/SRR4820709_1.fastq.
  gz . && mv SRR4820709_1.fastq.gz SRR4820709_GSM2371288_34-iPS_5F_shEZH1_D4_day_28_rep_2_Homo_sapiens_RNA-Seq_1.fastq.gz
  ascp -QT -l 300m -P33001 -i $HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR482/009/SRR4820709/SRR4820709_2.fastq.
  gz . && mv SRR4820709_2.fastq.gz SRR4820709_GSM2371288_34-iPS_5F_shEZH1_D4_day_28_rep_2_Homo_sapiens_RNA-Seq_2.fastq.gz
----------------------------------------------------------------------------

- Next, I run the fastqc.sh to check the quality of fastq files and viewed the report after I ran multiQC command. The reports showed that everything is ok.

- Download the human genome index file for hisat2 from ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38.tar.gz.

- Set up the config file(see hisata2_bash help) and human genome index for mapping
  idx=/mnt/f/bioinfo_data/refs/grch38_ht2/genome

- Run hisat2_bash.sh command for mapping

#/bin/bash
#=================Help========================================
# fisrt args is config file contain: fq1, fq2 and name for bam file
# Second args is the index file for mapping
# find . -name "*_1.fastqc.gz"| sort > 1
# find . -name "*_2.fastqc.gz"| sort >2
# cat 1 | sed -e 's@./@@' -e 's@_1.fastq.gz@.sam@' > 3
# paste 1 2 3 > config
# file 3 looks like this:
# ./SRR4820707_GSM2371287_34-iPS_5F_shEZH1_D4_day_28_rep_1_Homo_sapiens_RNA-Seq_1.fastq.gz	./SRR4820707_GSM2371287_34-iPS_5F_shEZH1_D4_day_28_rep_1_Homo_sapiens_RNA-Seq_2.fastq.gz	SRR4820707_GSM2371287_34-iPS_5F_shEZH1_D4_day_28_rep_1_Homo_sapiens_RNA-Seq.sam


#==============================================================

set -euo pipefail
config=$1
idx=$2

count=0
cat $config | while read -a arr;do
   fq1=${arr[0]}
   fq2=${arr[1]}
   name=${arr[2]}
   hisat2 -p4 -x $idx -1 $fq1 -2 $fq2 -S $name &>hisat2.log
   count=$((count+1))
   if [[ $((count % 3)) -eq 0 ]];then
       wait
       count=0
   fi


done

- Done with hisat2_bash.sh, the script only do mapping one by one, which will take 10 min for each paired fastq file, the generated sam file size ia about 7-8Gb.

- Run the following pipe to convert sam files to a sorted and indexed bam file.

   *.sam | parallel --eta  " samtools view -b {} | samtools sort - > {.}.bam; samtools index {.}.bam"

- will appear temp bam files like *001.bam - *008.bam, and also  *.bam(initial size is 0),  each file ~180-200mb, once all the temp bam files finished, *.bam size will increase to about 1.1-1.3Gb, then all the temp bam file will be deleted. This process for each sam file will take about 600-800s.


- once a sam file (7-9Gb) converted to bam file, do the following command to check if the mapping works, if yes, then delete the sam file:.
    samtools flagstat -@4 SRR4820729_GSM2371298_34-iPS_5F_shLUC_C11_day_28_rep_2_Homo_sapiens_RNA-Seq.bam
- The *.bam.bai file is the index file for the corresponding bam file, the size is about 2.3mb.

- The whole process from mapping to the final bam files is about 3 hours.



