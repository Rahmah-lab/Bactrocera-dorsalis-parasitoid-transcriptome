# FRUITFLY
Fruit fly immune responses

# ONT Transcriptome Analysis of Bactrocera dorsalis (non-model organism)

Fruit fly immune responses
This project was conducted by Gwokyalya Rehemah under the supervison of Dr(s) Samira Mohamed, Jeremy Herren, Christopher Weldon, and Shepard Ndlela.
This Project was about exploring the immune responses of an invasive and highly menacious invasive horticultural pest in Africa, Bactrocera dorsalis when exposed to the hymenopteran parasitoid wasp Fopius arisanus.
The fruit flies (at the egg stage) were exposed to the wasps and reared under lab conditions until they reached the second instar which was used for imunological bioassays.
Bioassays were conducted using the parasitised larval groups with the unparasitised 2nd instar fruit fly larvae as controls.
RNA sequencing was done using the long read Oxford nanopore cDNA sequencing kit

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
This was done using minimap

### 1.8 Feature count
This was done using HTseq
#### Script
Here is the script for these two steps [script for the step](https://github.com/Rahmah-lab/Fruit-fly-transcriptomics/blob/master/Map_Featurecount.sh)

### 1.9 Differential gene expression analysis
This was done using edgeR, see package source at [script for the step](https://bioconductor.org/packages/release/bioc/html/edgeR.html)
Here is the link to the script [script for the step](https://github.com/Rahmah-lab/Fruit-fly-transcriptomics/blob/master/DGE%20Analysis.R)

### Visualisation
Visualisation of the datasets was done using graphpad prism software [script for the step](https://www.graphpad.com/features).
I followed this tutorial for the volacno plots [script for the step](https://www.youtube.com/watch?v=oAB3jNspij0)

### Functional annotation of the genes was done using 
Functional annotation of the genes was done using the gene functional classification tool DAVID. 
This online tool can be accessed at [script for the step](https://davidbioinformatics.nih.gov/tools.jsp) 
