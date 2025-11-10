KORE-Map 1.1
This repository provides the processing scripts and analysis codes used in KORE-Map 1.1

Script Overview
# RNA_processing_code.sh
Main RNA-seq processing pipeline - trimming (Trim galore), alignment (STAR), quantification (RSEM)

# mappingrate_code.py
Parses STAR Log.final.out files to summarize mapping statistics (input reads, uniquely mapped reads, mapping rate)

# UMAP_clustering_code.R
Performs UMAP-based visualization for batch-effect assessment using expression matrix input.

# CMap_based_comparison.R
Performs CMap-based comparative transcriptomic analysis between RNA-seq data and public Connectivity Map (CMap) profiles.

# Additional data 
20230719_Repurposing_Hub_export.txt
RNAseq2023_4cell_Wortmannin_Vehicle_RSEM_results.Rdata (RESM expression matrices and sample information)
msigdbr_hs.Rdata (MSigDB gene sets) is also not included due to large file size.
It can be regenerated locally using the msigdbr (v7.5.1) package

# Software Versions
FastQC      v0.11.9
Trim Galore v0.6.6
STAR        v2.7.3a
RSEM        v1.3.3
reference   GRCH38 (Ensembl Release 84)
annotation  Homo_sapiens.GRCH.38.84.gtf
msigdbr     v7.5.1
