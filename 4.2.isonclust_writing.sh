#!/bin/bash
#PBS -l select=10:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -o /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isonclust_write.out
#PBS -e /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isonclust_write.err
#PBS -m abe
#PBS -M jackiemaingih@gmail.com
#cd $PBS_O_WORKDIR

#module load chpc/BIOMODULES
#module add chpc/python/anaconda/3-2020.11
#eval "$(conda shell.bash hook)"
#source activate /apps/chpc/bio/anaconda3-2020.02/envs/isonclust
#conda activate isonclust

cd /home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/insonclust_output1
mkdir -p isoncorrect1/input/


for i in /home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/*.unaligned.porechopped.fq;
do

base=$(basename $i .unaligned.porechopped.fq)
echo "Working with file $base"

cd /home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/insonclust_output1/isoncorrect1/input/
mkdir $base

i=/home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/${base}.unaligned.porechopped.fq
out=/home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/insonclust_output/${base}
fclust=/home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/insonclust_output/${base}/final_clusters.tsv
folders=/home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/insonclust_output1/isoncorrect1/input/${base}

#isONclust --ont --fastq $i --outfolder $out
#mkdir $folders

isONclust write_fastq --clusters $fclust --fastq $i --outfolder $folders --N 1

        for dir in /home/manager/Desktop/Analysis/cosyra/sortme/sortmerna_output/insonclust_output1/isoncorrect1/input/*
        do
echo "Working with folder $dir"
        cd $dir
        cat *.fastq > ${base}.fastq
        done

done
