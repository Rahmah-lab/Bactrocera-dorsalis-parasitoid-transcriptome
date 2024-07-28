getwd()
setwd("C:/Users/Rehemah/RNAseq_data/Fopius_final/minimapped")
library(rlang)
library(tidyverse)
library(dplyr)
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
library(DESeq2)
BiocManager::install("edgeR")
library(edgeR)
library(ggplot2)
library(ggrepel)
library(Rcpp)
library(statmod)
library(limma)
BiocManager::install("Glimma")
library(Glimma)
library(gplots)
library(RColorBrewer)

#Reading the various tables into R
barcode1 <- read.csv("barcode01.tsv", sep = '\t', header = TRUE)
barcode2 <- read.csv("barcode02.tsv", sep = '\t', header = TRUE)
barcode3 <- read.csv("barcode03.tsv", sep = '\t', header = TRUE)
barcode4 <- read.csv("barcode04.tsv", sep = '\t', header = TRUE)
barcode5 <- read.csv("barcode05.tsv", sep = '\t', header = TRUE)
barcode6 <- read.csv("barcode06.tsv", sep = '\t', header = TRUE)
barcode7 <- read.csv("barcode07.tsv", sep = '\t', header = TRUE)
barcode8 <- read.csv("barcode08.tsv", sep = '\t', header = TRUE)

#merging the different samples into one dataframe
all_transcripts <- Reduce(function(x,y) merge(x,y,by="Genes",all=TRUE) ,list(barcode1, barcode2, barcode3, barcode4, barcode5, barcode6, barcode7, barcode8))
head(all_transcripts)

#delete rows 1 and 3 they contain human-like genes mainly due to contamination
all_transcripts <- all_transcripts[-c(1:6),]
head(all_transcripts)
view(all_transcripts)

#Reading the sample metadata into R
sample_metadata <- read.csv("metadata.csv", sep = ',', header = TRUE)
sample_metadata

#Replacing NAs with 0
all_transcripts[is.na(all_transcripts)] <- 0
#converting the transcript name collumn into row names
read_count <- all_transcripts %>% remove_rownames %>% column_to_rownames(var="Genes")

# Obtain CPMs
myCPM <- cpm(read_count)
# Have a look at the output
head(myCPM)
plotMDS(myCPM)

# Which values in myCPM are greater than 0.5?
thresh <- myCPM > 0.5
# This produces a logical matrix with TRUEs and FALSEs
head(thresh)


# Summary of how many TRUEs there are in each row
table(rowSums(thresh))

# we would like to keep genes that have at least 4 TRUES in each row of thresh
keep <- rowSums(thresh) >= 4
# Subset the rows of countdata to keep the more highly expressed genes
counts.keep <- read_count[keep,]
summary(keep)
dim(counts.keep)


# Let's have a look and see whether our threshold of 0.5 does indeed correspond to a count of about 10-15
# We will look at the first sample
plot(myCPM[,1],read_count[,1])
# Let us limit the x and y-axis so we can actually look to see what is happening at the smaller counts
plot(myCPM[,1],read_count[,1],ylim=c(0,50),xlim=c(0,3))
# Add a vertical line at 0.5 CPM
abline(v=0.5)

#making a DGE list
dgeObj <- DGEList(counts.keep, group = sample_metadata$sample)
#counts <- DGEList(reads_count, group = samples.metadata$sample_type)
# have a look at dgeObj
dgeObj
# See what slots are stored in dgeObj
names(dgeObj)
# Library size information is stored in the samples slot
dgeObj$samples
# Convert counts per million per gene to log counts per million for further downstream analysis.
logcpm.norm.counts <- cpm(counts.keep, log = TRUE, prior.count = 2, normalized.lib.sizes = TRUE)

# Apply sample grouping based on sample_type from which the sample was derived
design <- model.matrix(~0+sample_metadata$sample)
colnames(design) <- levels(as.factor(sample_metadata$sample))

# Estimate dispersions for tags
filtered.counts.dge <- estimateDisp(dgeObj, design, robust = TRUE)

#Plot to see sample clustering
plotMDS(filtered.counts.dge)
# Fit a generalized likelihood model to the DGELIST using sample grouping
fit <- glmFit(filtered.counts.dge,design)

# generate a list of all possible pairwise contrasts
condition_pairs <- t(combn(levels(as.factor(sample_metadata$sample)), 2))
condition_pairs
comparisons <- list()

for (i in 1:nrow(condition_pairs)) {
  comparisons[[i]] <- as.character(condition_pairs[i,])
}

# vector to store deferentially expressed genes
sig_genes <- c()

# iterate over the contrasts, and perform a differential expression test for each pair
for (conds in comparisons) {
  # generate string contrast formula
  contrast_formula <- paste(conds, collapse=' - ')

  contrast_mat <- makeContrasts(contrasts=contrast_formula, levels=design)
  contrast_lrt <- glmLRT(fit, contrast=contrast_mat)
  topGenes <- topTags(contrast_lrt, n=Inf, p.value=0.05, adjust.method = "BH")

  # Grab highly ranked genes
  sig_genes <- union(sig_genes, rownames(topGenes$table))
}
sig_genes

# Filter out genes which were not differentially expressed for any contrast
de.genes <- filtered.counts.dge[rownames(filtered.counts.dge) %in% sig_genes,]
#de.genes <- filtered.counts.dge[rownames(filtered.counts.dge) !=sig_genes,]
dim(de.genes$counts)
DE_data <- de.genes$counts

#comparisons
## control vs fopius
Control_vs_fopius_lrt <- glmLRT(fit, contrast = c(-1,1))

# Genes with most significant differences (using topTags)
## control compared to fopius
topGenes_fopius <- topTags(Control_vs_fopius_lrt, adjust.method = "BH", p.value = 1, n=Inf)
topGenes_fopius
dim(topGenes_fopius)
DE_fopius <- topGenes_fopius$table
write.csv(DE_fopius, "fopius-final_last.csv")
view(DE_fopius)

# Control vs fopius
Control_vs_fopius_de.genes <- decideTestsDGE(Control_vs_fopius_lrt, adjust.method = "BH", p.value = 0.05)

# summary
summary(Control_vs_fopius_de.genes)

#Here’s a closer look at the counts-per-million in individual samples for the topgenes
o<-order(Control_vs_fopius_lrt$table$PValue)
cpm(filtered.counts.dge)[o[1:10],]
#Use the writen out.csv file to generate volcano plots in Graphpad prism
## Proceed with gene set enrichment analysis in David
