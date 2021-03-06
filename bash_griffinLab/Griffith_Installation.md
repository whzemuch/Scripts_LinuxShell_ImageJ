## soure: https://github.com/griffithlab/rnaseq_tutorial/wiki/Installation

## Set up tool installation location
> cd $RNA_HOME
> mkdir student_tools
> cd student_tools

## SAMtools
> cd $RNA_HOME/student_tools/
> wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
> bunzip2 samtools-1.9.tar.bz2
> tar -xvf samtools-1.9.tar
> cd samtools-1.9
> make
> ./samtools

## bam-readcount
> cd $RNA_HOME/student_tools/
> export SAMTOOLS_ROOT=$RNA_HOME/student_tools/samtools-1.9
> git clone https://github.com/genome/bam-readcount.git
> cd bam-readcount
> cmake -Wno-dev $RNA_HOME/student_tools/bam-readcount
> make
> ./bin/bam-readcount

## HISAT2
> cd $RNA_HOME/student_tools/
> wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip
> unzip hisat2-2.1.0-Linux_x86_64.zip
> cd hisat2-2.1.0
> ./hisat2

## StringTie
> cd $RNA_HOME/student_tools/
> wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4d.Linux_x86_64.tar.gz
> tar -xzvf stringtie-1.3.4d.Linux_x86_64.tar.gz
> cd stringtie-1.3.4d.Linux_x86_64
> ./stringtie


## gffcompare
> cd $RNA_HOME/student_tools/
> wget http://ccb.jhu.edu/software/stringtie/dl/gffcompare-0.10.6.Linux_x86_64.tar.gz
> tar -xzvf gffcompare-0.10.6.Linux_x86_64.tar.gz
> cd gffcompare-0.10.6.Linux_x86_64
> ./gffcompare


## htseq-count
> cd $RNA_HOME/student_tools/
> wget https://github.com/simon-anders/htseq/archive/release_0.11.0.tar.gz
> tar -zxvf release_0.11.0.tar.gz
> cd htseq-release_0.11.0/
> python setup.py install --user
> chmod +x scripts/htseq-count
> ./scripts/htseq-count


## TopHat
> cd $RNA_HOME/student_tools/
> wget https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz
> tar -zxvf tophat-2.1.1.Linux_x86_64.tar.gz
> cd tophat-2.1.1.Linux_x86_64/
> ./gtf_to_fasta


## kallisto
> cd $RNA_HOME/student_tools/
> wget https://github.com/pachterlab/kallisto/releases/download/v0.44.0/kallisto_linux-v0.44.0.tar.gz
> tar -zxvf kallisto_linux-v0.44.0.tar.gz
> cd kallisto_linux-v0.44.0/
> ./kallisto


## FastQC
> cd $RNA_HOME/student_tools/
> wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip --no-check-certificate
> unzip fastqc_v0.11.8.zip
> cd FastQC/
> chmod 755 fastqc
> ./fastqc --help


## MultiQC
> pip3 install multiqc
> multiqc --help


## Picard
> cd $RNA_HOME/student_tools/
> wget https://github.com/broadinstitute/picard/releases/download/2.18.15/picard.jar -O picard.jar
> java -jar $RNA_HOME/student_tools/picard.jar


## Flexbar
> cd $RNA_HOME/student_tools/
> wget https://github.com/seqan/flexbar/releases/download/v3.4.0/flexbar-3.4.0-linux.tar.gz
> tar -xzvf flexbar-3.4.0-linux.tar.gz
> cd flexbar-3.4.0-linux/
> export LD_LIBRARY_PATH=$RNA_HOME/student_tools/flexbar-3.4.0-linux:$LD_LIBRARY_PATH
> ./flexbar


## Regtools
> cd $RNA_HOME/student_tools/
> git clone https://github.com/griffithlab/regtools
> cd regtools/
> mkdir build
> cd build/
> cmake ..
> make
> ./regtools


## RSeQC
```
> pip install RSeQC
> read_GC.py
```

## R
This install takes a while so check if you have R installed already by typing which R. It is already installed on the Cloud, but for completeness, here is how it was done. Please skip all R installation!
``` 
sudo apt-get install r-base-dev
export R_LIBS=
cd $RNA_HOME/student_tools/
wget https://stat.ethz.ch/R/daily/R-patched.tar.gz
tar -xzvf R-patched.tar.gz
cd R-patched
./configure --prefix=$RNA_HOME/student_tools/R-patched/ --with-x=no
make
make install
./bin/Rscript
```
