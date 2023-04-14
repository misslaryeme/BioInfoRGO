library(org.Hs.eg.db)
library(org.Mm.eg.db)
library(org.Dm.eg.db)
library(org.Sc.sgd.db)
library(org.Ce.eg.db)
library(AnnotationDbi)
library(dplyr)

get_ontology_information <- function() {
  # Human
  ky <- keys(org.Hs.eg.db, "GO")
  hmdb <- AnnotationDbi::select(org.Hs.eg.db, keys = ky, columns = c("GO", "GENENAME"), keytype = "GO")
  sel <- dplyr::select(hmdb, ONTOLOGY, GO)

  # Mouse
  y <- keys(org.Mm.eg.db, "GO")
  Mmdb <- AnnotationDbi::select(org.Mm.eg.db, keys = y, columns = c("GO", "GENENAME"), keytype = "GO")
  selm <- dplyr::select(Mmdb, ONTOLOGY, GO)

  # Drosophila
  a <- keys(org.Dm.eg.db, "GO")
  Ddb <- AnnotationDbi::select(org.Dm.eg.db, keys = a, columns = c("GO", "GENENAME"), keytype = "GO")
  seld <- dplyr::select(Ddb, ONTOLOGY, GO)

  # Yeast
  b <- keys(org.Sc.sgd.db, "GO")
  Scdb <- AnnotationDbi::select(org.Sc.sgd.db, keys = b, columns = c("GO", "GENENAME"), keytype = "GO")
  sels <- dplyr::select(Scdb, ONTOLOGY, GO)

  # C elegans
  c <- keys(org.Ce.eg.db, "GO")
  cedb <- AnnotationDbi::select(org.Ce.eg.db, keys = c, columns = c("GO", "GENENAME"), keytype = "GO")
  selc <- dplyr::select(cedb, ONTOLOGY, GO)

  return(list(human = sel, mouse = selm, drosophila = seld, yeast = sels, celegans = selc))
}

create_final_go_data <- function(fGO, ontology_information) {
  merged_ontology_data <- merge_ontology_data(ontology_information)
  
  # Get the GO ids that do not have ontology information
  go_ids_without_ontology <- setdiff(fGO$GOALL, merged_ontology_data$GO)
  
  # Add missing ontology information as 'NA'
  missing_ontology_data <- data.frame(ONTOLOGY = rep("NA", length(go_ids_without_ontology)), GO = go_ids_without_ontology)
  final_ontology_data <- rbind(merged_ontology_data, missing_ontology_data)
  
  # Merge the ontology information with fGO data
  Final_GO <- final_ontology_data %>%
    left_join(fGO, by = c("GO" = "GOALL")) %>%
    unique() %>%
    relocate(GID, .before = ONTOLOGY) %>%
    relocate(GO, .before = ONTOLOGY) %>%
    relocate(EVIDENCE, .before = ONTOLOGY) %>%
    rename(GOALL = GO)
  
  return(Final_GO)
}

create_org_package <- function(gene_info, chromosome, go, output_dir, config) {
  makeOrgPackage(
    gene_info = gene_info,
    chromosome = chromosome,
    go = go,
    version = config$version,
    maintainer = config$author,
    author = config$author,
    outputDir = output_dir,
    tax_id = config$tax_id,
    genus = config$genus,
    species = config$species
  )
}
