library(clusterProfiler)
library(rtracklayer)
library(AnnotationForge)

load_uniprot_data <- function(file_path) {
  uni <- read.delim(file_path)
  cleanuni <- uni[grep("TERMP", uni[, 3]), c(2, 3)]
  
  cleanuni_uniq <- NULL
  for (i in 1:nrow(cleanuni)) {
    for (g in unlist(strsplit(cleanuni[i, 1], "; "))) {
      cleanuni_uniq <- rbind(cleanuni_uniq, c(g, cleanuni[i, 2]))
    }
  }
  colnames(cleanuni_uniq) <- c("term", "gene")
  return(cleanuni_uniq)
}

load_quick_go_data <- function(file_path) {
  quick <- read.delim(file_path)
  clean_quick_uniq <- quick[, c("GO.TERM", "SYMBOL")]
  colnames(clean_quick_uniq) <- c("term", "gene")
  return(clean_quick_uniq)
}

combine_uniprot_and_quick_go_data <- function(clean_uniprot_uniq, clean_quick_go_uniq) {
  final_matrix <- unique(rbind(clean_uniprot_uniq, clean_quick_go_uniq))
  return(final_matrix)
}

load_gff_data <- function(file_path) {
  gff <- import.gff(file_path)
  myDf <- data.frame("CHROMOSOME" = as.vector(seqnames(gff)), "GID" = gff$Name, "GENENAME" = gff$ID)
  return(myDf)
}

filter_gff_data <- function(gff_data, final_matrix) {
  filtered_gff_data <- gff_data[gff_data$GID %in% final_matrix[, "gene"], ]
  return(filtered_gff_data)
}

create_fsym_data <- function(filtered_gff_data) {
  fSym <- filtered_gff_data[, c("GID", "GENENAME", "GENENAME")]
  colnames(fSym) <- c("GID", "SYMBOL", "GENENAME")
  return(fSym)
}

create_fchr_data <- function(filtered_gff_data) {
  fChr <- filtered_gff_data[, c("GID", "CHROMOSOME")]
  return(fChr)
}

create_fgo_data <- function(final_matrix) {
  fGO <- as.data.frame(cbind(final_matrix[, 2], final_matrix[, 1], "Custom"))
  colnames(fGO) <- c("GID", "GOALL", "EVIDENCE")
  return(fGO)
}