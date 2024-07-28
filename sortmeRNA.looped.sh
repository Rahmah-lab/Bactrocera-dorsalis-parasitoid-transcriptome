
#!/bin/bash
#PBS -l select=10:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -o /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/sortme/sortmerna.out
#PBS -e /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/sortme/sortmerna.err
#PBS -m abe
#PBS -M remysuffy@gmail.com


## Loading Modules 
#module load chpc/BIOMODULES
#module add anaconda/3-2020.02
#module load sortmerna/4.3.4


#cd ~/lustre/RNAseq/data/ovary_RNAseq/sortme/

for i in ~/porechop_output/porechopped/*.porechopped.fastq.gz

do 

base=$(basename $i .porechopped.fastq.gz)
    echo "Working with file $base"

##Inputs

i=~/porechop_output/porechopped/${base}.porechopped.fastq.gz

db1=~/rRNA_databases/rfam-5.8s-database-id98.fasta

db2=~/rRNA_databases/rfam-5s-database-id98.fasta

db3=~/rRNA_databases/silva-arc-16s-id95.fasta

db4=~/rRNA_databases/silva-arc-23s-id98.fasta

db5=~/rRNA_databases/silva-bac-16s-id90.fasta

db6=~/rRNA_databases/silva-bac-23s-id98.fasta

db7=~/rRNA_databases/silva-euk-18s-id95.fasta

db8=~/rRNA_databases/silva-euk-28s-id98.fasta

## Outputs
out1=~/sortmerna_outputs/${base}.aligned.porechopped
out2=~/sortmerna_outputs/${base}.unaligned.porechopped
work=~/RNAseq

sortmerna -ref $db1 -ref $db2 -ref $db3 -ref $db4 -ref $db5 -ref $db6 -ref $db7 -ref $db8 --reads $i --aligned $out1 --fastx --other $out2 -workdir $work

rm ~RNAseq/kvdb/*

done
