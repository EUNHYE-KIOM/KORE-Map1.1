# =======================================
#  UMAP BatchGroup Visualization Script
R version 4.5.1
# =======================================

# ---------------------------------------
# 1. Install and load required packages
# ---------------------------------------
packages <- c("ggplot2", "umap", "tidyr", "RColorBrewer", "dplyr", "stringr", "viridis")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) {
  install.packages(packages[!installed], dependencies = TRUE)
}
lapply(packages, library, character.only = TRUE)

# ---------------------------------------
# 2. Specify the expression matrix file
# ---------------------------------------
expr_file <- "expression_matrix.txt"   # Path to your expression matrix file



# ---------------------------------------
# 3. Load and preprocess the data
# ---------------------------------------

expr <- read.table(expr_file, header = TRUE, row.names = 1, sep = "\t", check.names = FALSE)

# Transpose the matrix (genes → columns, samples → rows)
expr_t <- t(expr)

# Remove genes with zero variance
gene_vars <- apply(expr_t, 2, var, na.rm = TRUE)
zero_var_genes <- names(gene_vars)[gene_vars == 0]

if (length(zero_var_genes) > 0) {
  expr_t_filt <- expr_t[, !(colnames(expr_t) %in% zero_var_genes)]
  message(length(zero_var_genes), " genes with zero variance were removed.")
} else {
  expr_t_filt <- expr_t
  message("No zero-variance genes found.")
}

# Scale the expression matrix (Z-score normalization)
expr_scaled <- scale(expr_t_filt)

# ---------------------------------------
# 4. Perform UMAP
# ---------------------------------------
set.seed(123)
umap_res <- umap(expr_scaled)

# ---------------------------------------
# 5. Create metadata and parse sample names
# ---------------------------------------
umap_df <- data.frame(
  UMAP1 = umap_res$layout[, 1],
  UMAP2 = umap_res$layout[, 2],
  Sample = rownames(expr_scaled)
)

# Split the sample name into metadata columns (e.g., A549_Vehicle_A1)
umap_df <- umap_df %>%
  separate(Sample, into = c("CellLine", "Condition", "Replicate"), sep = "_", remove = FALSE) %>%
  mutate(
    Batch = str_extract(Replicate, "^[A-Za-z]+"),        # Extract batch letter (A1 → A)
    BatchGroup = paste(CellLine, Batch, sep = "_")       # Combine CellLine and Batch (A549_A)
  )

# ---------------------------------------
# 6. Plot UMAP colored by BatchGroup
# ---------------------------------------

p <- ggplot(umap_df, aes(x = UMAP1, y = UMAP2, color = BatchGroup)) +
  geom_point(size = 3, alpha = 0.9) +
  scale_color_viridis_d(option = "turbo") +  # Supports many distinct colors
  theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    legend.title = element_blank()
  )

# ---------------------------------------
# 7. Save the figure as a high-resolution TIFF
# ---------------------------------------
out_file <- "UMAP_BatchGroup_by_CellLine_Test.tiff"
ggsave(
  filename = out_file,
  plot = p,
  device = "tiff",
  path = ".",
  width = 6, height = 5, units = "in",
  dpi = 600,
  compression = "lzw"
)
