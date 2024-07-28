#!/bin/bash
#PBS -l select=10:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -o /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isonclust_write.out
#PBS -e /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isonclust_write.err
#PBS -m abe
#PBS -M remysuffy@gmail.com
#cd $PBS_O_WORKDIR

#module load chpc/BIOMODULES
#module add chpc/python/anaconda/3-2020.11
#eval "$(conda shell.bash hook)"
#source activate /apps/chpc/bio/anaconda3-2020.02/envs/isonclust
#conda activate isonclust

cd ~/insonclust_output
mkdir -p isoncorrect/input/


for i in ~/*.unaligned.porechopped.fq;
do

base=$(basename $i .unaligned.porechopped.fq)
echo "Working with file $base"

cd ~/insonclust_output/isoncorrect/input/
mkdir $base

i=~/sortmerna_output/${base}.unaligned.porechopped.fq
out=~/insonclust_output/${base}
fclust=~/insonclust_output/${base}/final_clusters.tsv
folders=~/insonclust_output/isoncorrect/input/${base}

isONclust write_fastq --clusters $fclust --fastq $i --outfolder $folders --N 1

        for dir in ~/insonclust_output/isoncorrect/input/*
        do
echo "Working with folder $dir"
        cd $dir
        cat *.fastq > ${base}.fastq
        done

done
