#!/bin/bash
#PBS -l select=10:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -o /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/pchop.out
#PBS -e /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/pchop.err
#PBS -m abe
#PBS -M jackiemaingih@gmail.com
cd $PBS_O_WORKDIR

module load chpc/BIOMODULES
module add chpc/python/anaconda/3-2020.11 
eval "$(conda shell.bash hook)"
source activate /apps/chpc/bio/anaconda3-2020.02/envs/porechop
conda activate porechop


for n in {01..12};do mkdir output_reads/barcode$n;
(for i in fastq_pass/barcode$n/*.fastq.gz;do base=$(basename $i -s="fastq_pass/barcode*/*.fastq.gz");
porechop -i $i --format fastq.gz -o output_reads/barcode$n/$base.porechopped.fastq.gz;done); 
cat output_reads/barcode$n/*.fastq.gz >> output_reads/barcode$n/barcode$n.porechopped.fastq.gz;done
for n in {01..12}; do cp output_reads/barcode$n/barcode$n.porechopped.fastq.gz .;done


