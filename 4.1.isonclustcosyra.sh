#!/bin/bash
#PBS -l select=10:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -o /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isonclust.out
#PBS -e /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isonclust.err
#PBS -m abe
#PBS -M jackiemaingih@gmail.com
#cd $PBS_O_WORKDIR

#module load chpc/BIOMODULES
#module add chpc/python/anaconda/3-2020.11
#eval "$(conda shell.bash hook)"
#source activate /apps/chpc/bio/anaconda3-2020.02/envs/isonclust
#conda activate isonclust

cd ~/Desktop/Analysis/cosyra/sortme/sortmerna_output

mkdir -p insonclust_output

for i in ~/Desktop/Analysis/cosyra/sortme/sortmerna_output/*.unaligned.porechopped.fq
do

base=$(basename $i .unaligned.porechopped.fq)
    echo "Working with file $base"

i=~/Desktop/Analysis/cosyra/sortme/sortmerna_output/${base}.unaligned.porechopped.fq
out=~/Desktop/Analysis/cosyra/sortme/sortmerna_outputs/insonclust_output/${base}

isONclust --ont --fastq $i --outfolder $out
done

