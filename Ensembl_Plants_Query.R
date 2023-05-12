#!/usr/bin/Rscript

#Finding python - Anaconda Python Fix
options(python_cmd = "C:/ProgramData/Anaconda3/python")

#Installing necessary packages and respective dependencies
#User Input Arguments
if (!require("argparse")) install.packages("argparse")
suppressMessages(library(argparse))
#Working and cleaning Dataframes
if (!require("dplyr")) install.packages("dplyr")
suppressMessages(library(dplyr))
if (!require("data.table")) install.packages("data.table")
suppressMessages(library(data.table))
if (!require("stringi")) install.packages("stringi")
suppressMessages(library(stringi))

#Ensembl Plants API
if (!require("biomaRt")) BiocManager::install("biomaRt")
library(biomaRt)

#Get and set current directory as working directory -> PathToFile\\CorkOak_UseCase_Data-main
dir <- getwd()
setwd(dir)
#Fix files directory to avoid R "permission denied" error
new_dir <- gsub("/", "\\\\", dir)

#USAGE
parser <- ArgumentParser(description="This script receives a Gene/Protein ID list and retrieves correspondent short names, short descriptions, annotations and orthologs from the Ensembl Plants Database.")
parser$add_argument("-g", "--genes", dest="genes", required=TRUE, help="Specify a query ID list (one per line)")
parser$add_argument("-s", "--species", dest="species", required=TRUE, help="Specify the Query Species scientific name (e.g. quercus_suber OR qsuber)")
parser$add_argument("-o", "--outputname", dest="outputname", required=FALSE, help="Output File Name (default: Ensembl_Plants_Query_Output.txt")

#Storing User input arguments into variables
args <- parser$parse_args()
genes <- args$genes
species <- args$species
outputname <- args$outputname

#Make Ensembl_Plants Species name compatible with available Plant Datasets
if( grepl('_', species, fixed = TRUE) == TRUE) {
  species <- paste0(substr(species,1,1), strsplit(species, "_")[[1]][[2]])
}
species <- paste0(species, "_eg_gene")

#Read Input Query List
genes <- readLines(genes)

#Connect to EnsemblPlantsDB
plant_ensembl = useEnsemblGenomes(biomart="plants_mart")
#List available genomes
#listDatasets(plant_ensembl)
#Connect to Query Genome
plant_mart = useEnsemblGenomes(biomart="plants_mart", dataset= species )
#List available Atributes within Ensembl_Plants
#listAttributes(plant_mart)

#For Gene Queries
new_genes <- paste0("gene-", genes)


#Gathering data for all Query IDs
#Collecting only GeneID,TranscriptID,description,
descriptions <- getBM(attributes=c('ensembl_gene_id', 'ensembl_peptide_id','description'),filters = 'ensembl_gene_id', values = new_genes, mart = plant_mart)
descriptions$ensembl_peptide_id <- stri_replace_all_regex(descriptions$ensembl_peptide_id, pattern=c('cds-'), replacement=c(''), vectorize=FALSE)

ensembl_gene_id <- descriptions$ensembl_gene_id
ensembl_peptide_id <- descriptions$ensembl_peptide_id
new_descriptions <- data.table(ensembl_gene_id, ensembl_peptide_id)

unduplicated_descriptions1 <- subset(descriptions, !duplicated(ensembl_gene_id))
unduplicated_descriptions1 <- subset(unduplicated_descriptions1, select = -ensembl_peptide_id)

unduplicated_descriptions2 <- new_descriptions[, lapply(.SD, paste0, collapse=" | "), by=ensembl_gene_id]

unduplicated_descriptions <- merge(unduplicated_descriptions1, unduplicated_descriptions2, by = "ensembl_gene_id")

final_descriptions <- unduplicated_descriptions %>% dplyr::select(ensembl_gene_id, ensembl_peptide_id, everything())


#Collecting only GO:IDs, GOslim:descriptions
annotation <- getBM(attributes=c('ensembl_gene_id','go_id','name_1006'),filters = 'ensembl_gene_id', values = new_genes, mart = plant_mart)
annotation$go_id_description <- paste(annotation$go_id, annotation$name_1006, sep = "_")

ensembl_gene_id <- annotation$ensembl_gene_id
go_id_description <- annotation$go_id_description
new_annotation <- data.table(ensembl_gene_id, go_id_description)

final_annotation <- new_annotation[, lapply(.SD, paste0, collapse=" | "), by=ensembl_gene_id]


#Collecting Arabidopsis thaliana Homologs
homologs <- getBM(attributes=c('ensembl_gene_id','athaliana_eg_homolog_ensembl_gene','athaliana_eg_homolog_associated_gene_name','athaliana_eg_homolog_ensembl_peptide','athaliana_eg_homolog_perc_id_r1'),filters = 'ensembl_gene_id', values = new_genes, mart = plant_mart)
ordered_homologs <- homologs[order(homologs$ensembl_gene_id, -homologs$athaliana_eg_homolog_perc_id_r1), ]
final_homologs <- ordered_homologs[!duplicated(ordered_homologs[ , c("ensembl_gene_id")]),]


#Merge all into single Output Table
output <- dplyr::left_join(final_descriptions, final_annotation, by = "ensembl_gene_id")
output <- merge(output, final_homologs, by = "ensembl_gene_id")
output$ensembl_gene_id <- stri_replace_all_regex(output$ensembl_gene_id, pattern=c('gene-'), replacement=c(''), vectorize=FALSE)

#Write Output Table
outputname_file <- paste(new_dir, "Ensembl_Plants_Query_Output.txt", sep = "\\")
if (is.null(outputname) == FALSE) {
  outputname_file <- paste(outputname, "Query_Output.txt", sep = "_")
  outputname_file <- paste(new_dir, outputname_file, sep = "\\\\")
}
write.table(output, outputname_file, sep = "\t", row.names = FALSE, quote = FALSE)

#All Description (prov)
#description <- getBM(attributes=c('ensembl_gene_id', 'ensembl_peptide_id','chromosome_name','description','gene_biotype','transcript_biotype','source'),filters = 'ensembl_gene_id', values = 'gene-CFP56_47201', mart = plant_mart)
#All Annotations (prov)
#annotation <- getBM(attributes=c('go_id','goslim_goa_description','embl','uniprotswissprot','uniprotsptrembl','pfam','pfscan','superfamily','tigrfam','interpro'),filters = 'ensembl_gene_id', values = 'gene-CFP56_47201', mart = plant_mart)
#Arabidopsis thaliana Homologs
#homologs <- getBM(attributes=c('ensembl_gene_id','athaliana_eg_homolog_ensembl_gene','athaliana_eg_homolog_associated_gene_name','athaliana_eg_homolog_ensembl_peptide','athaliana_eg_homolog_perc_id'),filters = 'ensembl_gene_id', values = 'gene-CFP56_47201', mart = plant_mart)
