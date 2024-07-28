#Troubleshooting sam_parse error - truncated file
#This code renames all headers in isoncorrected fastq output files that are too long to be parsed into SAM during minimap using the "sed" command.
# It then maps the trimmed files to the B. dorsalis ref genome, converts the aligned reads to bam files, indexes them and counts the mapped features using Nanocount
module load chpc/BIOMODULES
module load samtools/1.9
module load minimap

source activate /apps/chpc/bio/anaconda3-2020.02/envs/nanocount/
conda activate nanocount

cd /home/rgwokyalya/lustre/RNAseq/output_reads/6.clean_reads

for i in *.all_corrected_reads.fq; do base=$(basename $i .all_corrected_reads.fq);
sed -r 's/_barcode_alias=.*//g' $i > ${base}.trimmed.fq;minimap2 -a -x map-ont ../GCF_023373825.1_ASM2337382v1_genomic.fna ${base}.trimmed.fq| samtools sort -o ${base}.aln.bam;
samtools view -h -F 4 ${base}.aln.bam -o ${base}.mapped.bam; samtools sort ${base}.mapped.bam -o ${base}.sorted.mapped.bam;
samtools index ${base}.sorted.mapped.bam;NanoCount -i ${base}.sorted.mapped.bam -o ${base}.nanocount.tsv -b ${base}.nanocount.bam -t 0.8 --verbose --extra_tx_info;done



