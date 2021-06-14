# load all packages required for the analysis

packages <- c("knitr","magrittr","DESeq2","ggplot2","pheatmap","dplyr","RColorBrewer","AnnotationDbi","biomaRt","org.Hs.eg.db","clusterProfiler")
invisible(lapply(packages, library, character.only = TRUE))

# set working directory

setwd("/Users/priyalakra/Desktop/RNAseq/Counts")

# load count matrix data and do some visualization 
readcounts <- read.table("fCounts.txt", header = TRUE)
dim(readcounts)
head(readcounts)

# remove columns that don't contain read counts
readcounts.new <- readcounts[ , -c(1)] # -c removes the columns specificed inside the paranthesis here 
dim(readcounts.new)
head(readcounts.new)

# change row names to geneids. 
row.names(readcounts.new) <- readcounts$Geneid

# save original names to orig_names and change col names that correspond to sample names to something simple; It makes further visualization, subsetting, etc easier.

orig_names <- names(readcounts.new) 
new_names <- gsub(".*(_|.)(E|W)([0-9]+).*", "\\2\\3", orig_names) # change gsub parameters here depending on your sample names; One liner: names(readcounts.new) <- gsub(".*(_|.)(S|N)([0-9]+).*", "\\2\\3", names(readcounts.new))
names(readcounts.new) <- new_names


# create a metadata file
sample_info <- data.frame(condition=c("E","E","W","W"), row.names = names(readcounts.new))

# create a DESeq.ds object
DESeq.ds <- DESeqDataSetFromMatrix(countData = readcounts.new , colData = sample_info, design = ~ condition)
colData(DESeq.ds) %>% head # equivalent to head(colData(DESeq.ds)); here %>% works as (unix) pipe 
assay(DESeq.ds, "counts") %>% head
rowData(DESeq.ds) %>% head


# remove genes with 0 counts
DESeq.ds.new = DESeq.ds[ rowSums(counts(DESeq.ds)) > 0, ]
dim(DESeq.ds.new)

# checking; the below two codes should give same output as in the above step we removed genes with 0 counts!
a <- colSums(counts(DESeq.ds.new))
b <- colSums(readcounts.new)
a == b

# normalization by estimating size factors 
DESeq.ds.new <- estimateSizeFactors(DESeq.ds.new)

# run to see size factors
sizeFactors(DESeq.ds.new)
colData(DESeq.ds.new) # hereyou will see a new colum of size factors added!

# counts(normalized = TRUE) allows you to retrieve the _normalized_ read counts
counts.sf_normalized <- counts(DESeq.ds.new, normalized = TRUE)

# after normalization, you can perform log transformation log2, log10, and use vst function of DESeq2
log.norm.counts <- log2(counts.sf_normalized+1)
log.norm.counts.x <- log10(counts.sf_normalized+1)
normcounts <- vst(DESeq.ds.new, blind = TRUE)

# clustering with pca and correlation
normcounts <- vst(DESeq.ds.new, blind = TRUE)
P <- plotPCA(normcounts)
P <- P + theme_bw() + ggtitle("Rlog transformed counts")
print(P)

		##		====== DGE using DESeq2 ========

