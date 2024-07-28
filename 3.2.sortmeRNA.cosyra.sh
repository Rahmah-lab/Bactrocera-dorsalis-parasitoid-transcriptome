
#!/bin/bash
#PBS -l select=10:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -o /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/sortme/sortmerna.out
#PBS -e /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/sortme/sortmerna.err
#PBS -m abe
#PBS -M jackiemaingih@gmail.com


## Loading Modules 

#module load chpc/BIOMODULES
#module add anaconda/3-2020.02
#module load sortmerna/4.3.4


#cd ~/lustre/RNAseq/data/ovary_RNAseq/sortme/

#mkdir -p /sortmerna_outputs/aligned_barcode

#barcode01.porechopped.fastq

for i in /home/manager/Desktop/Analysis/porechop_output/porechopped/*.porechopped.fastq.gz

do 

base=$(basename $i .porechopped.fastq.gz)
    echo "Working with file $base"

##Inputs

i=/home/manager/Desktop/Analysis/porechop_output/porechopped/${base}.porechopped.fastq.gz

db1=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/rfam-5.8s-database-id98.fasta
#db1i=/home/manager/Desktop/Analysis/sortmerna/data/index/rfam-5.8s-d

db2=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/rfam-5s-database-id98.fasta
#db2i=/home/manager/Desktop/Analysis/sortmerna/data/index/rfam-5s-db

db3=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/silva-arc-16s-id95.fasta
#db3i=/home/manager/Desktop/Analysis/sortmerna/data/index/silva-arc-16s-db

db4=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/silva-arc-23s-id98.fasta
#db4i=/home/manager/Desktop/Analysis/sortmerna/data/index/silva-arc-23s-db

db5=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/silva-bac-16s-id90.fasta
#db5i=/home/manager/Desktop/Analysis/sortmerna/data/index/silva-bac-16s-db

db6=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/silva-bac-23s-id98.fasta
#db6i=/home/manager/Desktop/Analysis/sortmerna/data/index/silva-bac-23s-db

db7=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/silva-euk-18s-id95.fasta
#db7i=/home/manager/Desktop/Analysis/sortmerna/data/index/silva-euk-18s-db

db8=/home/manager/Desktop/Analysis/sortmerna/data/rRNA_databases/silva-euk-28s-id98.fasta
#db8i=/home/manager/Desktop/Analysis/sortmerna/data/index/silva-euk-28s


## Outputs
out1=/home/manager/Desktop/Analysis/sortme/sortmerna_outputs/${base}.aligned.porechopped
out2=/home/manager/Desktop/Analysis/sortme/sortmerna_outputs/${base}.unaligned.porechopped
work=/home/manager/Desktop/Analysis/cosyra

#sortmerna --ref $db1,$db1i:$db2,$db2i:$db3,$db3i:$db4,$db4i:$db5,$db5i:$db6,$db6i:$db7,$db7i:$db8,$db8i --reads $i --aligned $out1 --fastx --other $out2

sortmerna -ref $db1 -ref $db2 -ref $db3 -ref $db4 -ref $db5 -ref $db6 -ref $db7 -ref $db8 --reads $i --aligned $out1 --fastx --other $out2 -workdir $work

rm /home/manager/Desktop/Analysis/cosyra/kvdb/*

done
