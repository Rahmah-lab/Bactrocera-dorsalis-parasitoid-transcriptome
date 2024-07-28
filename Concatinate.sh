#!bin/bash
#PBS -l select =1:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -p CBBI1470
#PBS -q smp
#PBS -l walltime=96:00:00
#PBS -o /home/manager/Desktop/Analysis/concatenating.out
#PBS -e /home/manager/Desktop/Analysis/concatenatin.err
#PBS -m abe
#PBS -M remysuffy@gmail.com
#cd $PBS_O_WORKDIR


cd ~/isoncorrect/output

for outfolder in *.correction; do base=$(basename $outfolder .correction);
touch $outfolder/all_corrected_reads.fq

OUTFILES=$outfolder/*/corrected_reads.fastq

for f in $OUTFILES
do
  echo $f
  cat $f >> $outfolder/$base.all_corrected_reads.fq
done


echo
echo "finished with pipeline and wrote corrected reads to: " $outfolder/$base.all_corrected_reads.fq
echo ;


done
