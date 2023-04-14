# Load the necessary source files and libraries
source("load_data.R")
source("create_package.R")
library(yaml)

# Load the configuration file
config <- yaml.load_file("config.yml")

# Load Uniprot and QuickGO data using the configured paths
uniprot_data <- load_uniprot_data(config$paths$uniprot)
quick_go_data <- load_quick_go_data(config$paths$quickgo)

# Merge Uniprot and QuickGO data
final_matrix <- combine_uniprot_and_quick_go_data(uniprot_data, quick_go_data)

# Load GFF data using the configured path
gff_data <- load_gff_data(config$paths$gff)

# Filter GFF data based on the final matrix
filtered_gff_data <- filter_gff_data(gff_data, final_matrix)

# Create gene info, chromosome data, fSym and fChr data based on the filtered GFF data
gene_info_data <- create_gene_info_data(filtered_gff_data)
chromosome_data <- create_chromosome_data(filtered_gff_data)
fSym <- create_fsym_data(filtered_gff_data)
fChr <- create_fchr_data(filtered_gff_data)

# Create fGO data based on the final matrix
fGO <- create_fgo_data(final_matrix)

# Retrieve ontology information from the configured org databases
ontology_information <- get_ontology_information()

# Create final GO data based on fGO data and ontology information
final_go_data <- create_final_go_data(fGO, ontology_information)

output_dir <- config$paths$output_dir
# Create the org package using the created data and configuration settings
create_org_package(gene_info_data, chromosome_data, final_go_data, fSym, fChr, output_dir, config)
