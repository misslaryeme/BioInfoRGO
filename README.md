# BioInfoRGO

BioInfoRGO is a bioinformatics project that processes and analyzes Gene Ontology data using the R programming language. It combines data from QuickGO and UniProt databases, processes GFF files, and creates an organism-specific package with gene annotation information.

## Features

- Merges Gene Ontology data from QuickGO and UniProt databases
- Processes GFF files for gene annotation information
- Creates gene info, chromosome data, fSym, and fChr data based on the filtered GFF data
- Generates an organism-specific package with gene annotation data
- Retrieves additional information from other species for a more comprehensive analysis

## Installation

1. Clone this repository to your local machine:

```bash
git clone https://github.com/misslaryeme/BioInfoRGO.git
```

2. Open the R script in your favorite R IDE (e.g., RStudio), and install the required packages:
```R
install.packages(c("clusterProfiler", "rtracklayer", "AnnotationForge", "yaml"))
```
## Usage

- Update the config.yml file with the appropriate paths to your input files and desired output directory.
- Run the R script to process the data and create the organism-specific package.
- Use the generated package for further analysis of gene annotations and Gene Ontology data.

## Configuration
The config.yml file contains the project settings, input file paths, and species information. Update this file with your project-specific information before running the main.R script.

## Contributing
If you'd like to contribute to the project, please submit a pull request with your proposed changes or open an issue to discuss improvements and bug fixes.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.