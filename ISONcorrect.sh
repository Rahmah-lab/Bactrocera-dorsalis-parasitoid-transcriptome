#!/bin/bash
#PBS -l select=1:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI1470
#PBS -q smp
#PBS -l walltime=96:00:00
#PBS -o /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isoncorrect.out
#PBS -e /mnt/lustre/users/jwahura/RNAseq/data/ovary_RNAseq/isoncorrect.err
#PBS -m abe
#PBS -M remysuffy@gmail.com
#cd $PBS_O_WORKDIR

#module load chpc/BIOMODULES
#module add chpc/python/anaconda/3-2020.11
#eval "$(conda shell.bash hook)"
#source activate /apps/chpc/bio/anaconda3-2020.02/envs/isoncorrect
#conda activate isoncorrect

cd ~/RNAseq/fastq

base=barcode01
echo "Working with file $base"

mkdir -p ~/insonclust_output/isoncorrect/output/$base

input=~/insonclust_output/isoncorrect/input/${base}

output=~/insonclust_output/isoncorrect/output/${base}

run_isoncorrect --fastq_folder $input --outfolder $output --exact_instance_limit 50 --max_seqs 1000 --k 9 --w 10 --xmin 14 --xmax 80 --T 0.1