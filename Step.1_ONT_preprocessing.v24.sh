#!/usr/bin/bash

#PBS -l select=1:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q smp
#PBS -l walltime=96:00:00
#PBS -m abe
#PBS -M remysuffy@gmail.com

module load chpc/BIOMODULES
module add anaconda/3-2020.02
module load sortmerna/4.3.4


cd /home/rgwokyalya/lustre/RNAseq

mkdir -p ./output_reads/2.sortmerna_outputs/ ./output_reads/3.insonclust_output/ ;
mkdir -p ./output_reads/4.isoncorrect_input/ ./output_reads/5.isoncorrect_output/ ./output_reads/1.filtered/;
mkdir -p ./output_reads/6.clean_reads/

root_dir=/home/rgwokyalya/lustre/RNAseq/fastq_pass ## Directory to Data

#for subdir in $(find "$root_dir"); do
for subdir in $root_dir/barcode*; do
  for file in $subdir/*.fastq.gz; do
    # Perform analysis on "$file" here
	base=$(basename $subdir)
	echo "++++++++++++++++++++++++"
	echo "Working with" $base
	echo "++++++++++++++++++++++++"

	mkdir -p ./output_reads/1.filtered/$base
	
	echo "**************************"
	echo "Here are the files:" $file
	echo "**************************"
  done


##########################
##	Directories	##
##########################
# Working Directory 
work2=/homehome/rgwokyalya/lustre/RNAseq
dir=$work2/fastq_pass/$base              ## Check compatibility
out1=$work2/output_reads/1.filtered/$base/${base}.porechopped.fastq.gz
out2=$work2/output_reads/2.sortmerna_outputs/${base}.aligned.porechopped
out3=$work2/output_reads/2.sortmerna_outputs/${base}.unaligned.porechopped
sort=$work2/output_reads/2.sortmerna_outputs
out4=$work2/output_reads/3.insonclust_output/${base}
out5=$work2/output_reads/3.insonclust_output/${base}/final_clusters.tsv
out6=$work2/output_reads/4.isoncorrect_input/${base}/
out7=$work2/output_reads/5.isoncorrect_output/${base}
out8=$work2/output_reads/6.clean_reads
##########################
##	DATABASES	##
##########################

# Acquire databases by visiting https://bioinfo.lifl.fr/RNA/sortmerna/
# Download the binary format of the sortmerna and use tar -xvf to unzip.
# the go into the folder called rRNAdatabases.

db1=~/home/rgwokyalya/lustre/rRNA_databases/rfam-5.8s-database-id98.fasta
db2=~/home/rgwokyalya/lustre/rRNA_databases/rfam-5s-database-id98.fasta
db3=~/home/rgwokyalya/lustre/rRNA_databases/silva-arc-16s-id95.fasta
db4=~/home/rgwokyalya/lustre/rRNA_databases/silva-arc-23s-id98.fasta
db5=~/home/rgwokyalya/lustre/rRNA_databases/silva-bac-16s-id90.fasta
db6=~/home/rgwokyalya/lustre/rRNA_databases/silva-bac-23s-id98.fasta
db7=~/home/rgwokyalya/lustre/rRNA_databases/silva-euk-18s-id95.fasta
db8=~/home/rgwokyalya/lustre/rRNA_databases/silva-euk-28s-id98.fasta

##################################
##	Execution Codes		##
##################################

## Removing Adapter

#source activate /apps/chpc/bio/anaconda3-2020.02/envs/porechop
porechop -i $dir --format fastq.gz -o $out1
conda deactivate

## Aligning to Rfam DBs
sortmerna -ref $db1 -ref $db2 -ref $db3 -ref $db4 -ref $db5 -ref $db6 -ref $db7 -ref $db8 --reads $out1 --aligned $out2 --fastx --other $out3 -workdir $work2;
rm $work2/kvdb/*

## Creates TSV files: Contains all the clustered gene families
### gunzip file present in sortmerna output for the isONclust to work
gunzip $sort/*.gz

#source activate /apps/chpc/bio/anaconda3-2020.02/envs/isonclust
isONclust --ont --fastq $out3.fq --outfolder $out4

## 
isONclust write_fastq --clusters $out5 --fastq $out3.fq --outfolder $out6 --N 1
conda deactivate

cd $work2/output_reads/isoncorrect_input/${base}
cat *.fastq > ${base}.fastq
mv ${base}.fastq ../

#source activate /apps/chpc/bio/anaconda3-2020.02/envs/isoncorrect
run_isoncorrect  --fastq_folder $out6  --outfolder $out7 --exact_instance_limit 50 --max_seqs 1000 --k 9 --w 10 --xmin 14 --xmax 80 --T 0.1
conda deactivate

#Concantinating all  corrected Files for each barcode

OUTFILES=$out7/*/corrected_reads.fastq

for f in $OUTFILES
do
 echo $f
  cat $f >> $out8/${base}.all_corrected_reads.fq

done

done
