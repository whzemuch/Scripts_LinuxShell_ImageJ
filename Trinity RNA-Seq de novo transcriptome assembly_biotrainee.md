## Trinotate/Trinity/TransDecoder/sqlite/NCBI BLAST+/HMMER/PFAM 
## signalP v4 /tmhmm v2 /RNAMMER
 
cd ~/biosoft
mkdir hmmer &&  cd hmmer
wget http://eddylab.org/software/hmmer/2.3/hmmer-2.3.tar.gz 
tar zxvf hmmer-2.3.tar.gz
cd hmmer-2.3
./configure --prefix=/home/jmzeng/my-bin
#./configure --prefix=/home/jianmingzeng/biosoft/myBin
make
make install
#for file in hmmalign hmmbuild hmmcalibrate hmmconvert hmmemit hmmfetch hmmindex hmmpfam hmmsearch ; do\
#      cp src/$file /home/jmzeng/my-bin/bin/;\
#   done
#for file in hmmer hmmalign hmmbuild hmmcalibrate hmmconvert hmmemit hmmfetch hmmindex hmmpfam hmmsearch; do\
#      cp documentation/man/$file.man /home/jmzeng/my-bin/man/man1/$file.1;\
#   done
cp /home/jmzeng/my-bin/bin/hmmsearch /home/jmzeng/my-bin/bin/hmmsearch2
  
cd ~/biosoft
mkdir CBS &&  cd CBS
#   signalP v4 (free academic download) http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?signalp
#   tmhmm v2 (free academic download) http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?tmhmm
#   RNAMMER (free academic download) http://www.cbs.dtu.dk/cgi-bin/sw_request?rnammer
mkdir signalp-4.1
mkdir rnammer-1.2
## be sure to untar it in a new directory
## it's a perl script, we need to modify it according to readme http://trinotate.github.io/#SoftwareRequired
## vi ~/biosoft/CBS/signalp-4.1/signalp
tar zxvf signalp-4.1e.Linux.tar.gz 
tar zxvf rnammer-1.2.src.tar.Z 
tar zxvf tmhmm-2.0c.Linux.tar.gz 
## it's a perl script, we need to modify it according to readme http://trinotate.github.io/#SoftwareRequired
## vi ~/biosoft/CBS/tmhmm-2.0c/bin/tmhmm 
## vi ~/biosoft/CBS/tmhmm-2.0c/bin/tmhmmformat.pl
which perl  ## /usr/bin/perl
 
  
  
  
  
  
cd ~/biosoft
mkdir blastPlus &&  cd blastPlus
#   ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.5.0+-x64-linux.tar.gz
blastBinFolder=~/biosoft/blastPlus/ncbi-blast-2.5.0+/bin
$blastBinFolder/makeblastdb -help
 
 
#   http://www.cbs.dtu.dk/services/doc/signalp-4.1.readme
 
 
cd ~/biosoft
mkdir TransDecoder &&  cd TransDecoder
#   https://transdecoder.github.io/
# https://github.com/TransDecoder/TransDecoder/releases
wget https://github.com/TransDecoder/TransDecoder/archive/v3.0.0.tar.gz  -O TransDecoder.v3.0.0.tar.gz 
tar zxvf TransDecoder.v3.0.0.tar.gz 
cd TransDecoder-3.0.0 
make
~/biosoft/TransDecoder/TransDecoder-3.0.0/TransDecoder.LongOrfs -h
~/biosoft/TransDecoder/TransDecoder-3.0.0/TransDecoder.Predict -h
 
  
## sqlite3  --help
cd ~/biosoft
mkdir Trinotate &&  cd Trinotate
#   http://trinotate.github.io/
#   https://github.com/Trinotate/Trinotate/releases
wget https://github.com/Trinotate/Trinotate/archive/v3.0.1.tar.gz  -O Trinotate.v3.0.1.tar.gz 
tar zxvf Trinotate.v3.0.1.tar.gz
~/biosoft/Trinotate/Trinotate-3.0.1/Trinotate -h
wget https://data.broadinstitute.org/Trinity/Trinotate_v3_RESOURCES/Pfam-A.hmm.gz
wget https://data.broadinstitute.org/Trinity/Trinotate_v3_RESOURCES/uniprot_sprot.pep.gz
wget https://data.broadinstitute.org/Trinity/Trinotate_v3_RESOURCES/Trinotate_v3.sqlite.gz  -O Trinotate.sqlite.gz
gunzip Trinotate.sqlite.gz
gunzip uniprot_sprot.pep.gz
makeblastdb -in uniprot_sprot.pep -dbtype prot
gunzip Pfam-A.hmm.gz
hmmpress Pfam-A.hmm