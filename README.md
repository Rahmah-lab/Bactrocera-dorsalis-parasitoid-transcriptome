# FRUITFLY
Fruit fly immune responses

# ONT Transcriptome Analysis of Bactrocera dorsalis (non-model organism)

Fruit fly immune responses
This project was conducted by Gwokyalya Rehemah under the supervison of Dr Samira Mohamed, Jeremy Herren, Christopher W. Weldon, and Shepard Ndlela.
The work done was supported by funding from ACIA/IDRC project number .....
This Project was about exploring the immune responses of two major fruit flies of Eastern Africa, Bactrocera dorsalis (Hendel) and Ceratitis cosyra (Walker) when exposed to the hymenopteran parasitoids Diachasmimorpha longicaudata (Ashmaed) and Pystallia cosyrae.
The fruit flies were raised under lab conditions untill they reached the second instar which was used for imunological bioassays.
Bioassays were conducted using the parasitised larval groups with the unparasitised 2nd instar fruit fly larvae as controls.

# Steps in ONT Transcriptome Analysis Workflow
1. Data Preprocessing: Filtration of low-quality data, removal of adapter sequences.
2. Filtering rRNA from metatranscriptomic data.
3. Clustering the reads into clusters, where each cluster represents all reads that came from a single gene.
4. Error-correcting the reads.
5. Concantinating the corrected files for each barcode.
6. Mapping of filtered data onto the reference genome.
7. Feature count: Determining abundance of expressed genes in each sample.
8. Differential gene expression analysis.

Here is the tool selection website [here](https://long-read-tools.org/tools.html?sort=Name&cat=&tec=)
## 1. Data Preprocessing

### 1.1. Quality Check
This was done on the generated long cDNA reads using PycoQC; Here is the link for the step

### 1.2. Removal of Adapters
This was done using poerchop

### 1.3 Filtering RNA reads
This was done using sortmeRNA

### 1.4 Read clustering
This was done using ISONclust

### 1.5 Error correction
This was executed by ISONcorrect

### 1.6 Concatinating reads

#### Script
Here is the [script for the step](https://github.com/Rahmah-lab/Bactrocera-dorsalis-parasitoid-transcriptome/blob/master/ONT_preprocessing.sh)

This script performs the following steps:
- Change the working directory to ~/RNAseq
- Create directories for the output files (Filtered, Sortmerna, isonclust_output, isoncorrect, and clean_reads).
- Loop through the Oxford Nanopore transcriptomic data files in ~/RNAseq/data/barcode*/*.fastq.gz and perform the following steps for each file:
- Sort the different RNA types using data bases from (https://bioinfo.lifl.fr/RNA/sortmerna/) to retain mRNA only.
- Cluster reads into gene families.
- Correct for errors in the reads within gene families.
- Concatinate the reads of each barcode into one file.

The script uses the basename function to extract the base name of each input file, which is then used to create unique output directories and filenames for each step of the analysis. The variables are used to store the paths to the input and output files, which makes it easier to manage the different stages of the pipeline. 

The set -e option is used to exit immediately if any of the commands return a non-zero status, which helps to detect errors and prevent processing of corrupted data.

### 1.7 Mapping reads to reference genome
This was doen using minimap; Here is the script for the step

### 1.8 Feature count
This was done using HTseq; Here is the link to this step

### 1.9 Differential gene expression analysis
This was done using edgeR; Here is the link to the script
