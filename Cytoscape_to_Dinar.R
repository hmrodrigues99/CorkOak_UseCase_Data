#!/usr/bin/Rscript

#Finding python - Anaconda Python Fix
options(python_cmd = "C:/ProgramData/Anaconda3/python")

#Installing necessary packages and respective dependencies
if (!require("argparse")) install.packages("argparse")
suppressMessages(library(argparse))
if (!require("dplyr")) install.packages("dplyr")
suppressMessages(library(dplyr))
if (!require("data.table")) install.packages("data.table")
suppressMessages(library(data.table))
if (!require("stringi")) install.packages("stringi")
suppressMessages(library(stringi))

#Ensembl Plants API
BiocManager::install("biomaRt")
library(biomaRt)

#Dinar Preprocessing Task (add coordinates)
if (!require("igraph")) install.packages("igraph")
library(igraph)

#Get and set current directory as working directory
dir <- getwd()
setwd(dir)

#USAGE
parser <- ArgumentParser(description="This script prepares a Cytoscape network to be imported into DiNaR. The annotated network can be imported into the preprocessing DiNARsubApp (https://nib-si.shinyapps.io/pre-processing/), after which it can be imported and analysed within the DiNAR application (https://nib-si.shinyapps.io/DiNAR/)")
parser$add_argument("-n", "--nodes", dest="nodes", required=TRUE, help="Network Node Table in .csv format (Cytoscape default) - Warning! First column must have the gene/protein IDs | additional columns are optional")
parser$add_argument("-e", "--edges", dest="edges", required=TRUE, help="Network Edge Table in .csv format (Cytoscape default) - Warning! First 2 columns must have the interacting gene/protein IDs | additional columns are optional")
#parser$add_argument("-s", "--species", dest="species", required=FALSE, help="GoMapMan Mode (FOR PROTEINS ONLY) - Specify string with species name (e.g. 'quercus_suber') - this option automatically retrieves protein annotations from the GoMapMan database") 
parser$add_argument("-c", "--custom", dest="annotation", required=FALSE, help ="Custom Annotation Mode - Input a Mercator4 Webtool output file (e.g. jobname.results)")
parser$add_argument("-p", "--ensemblplants", dest="ensemblplants", required=FALSE, help="Specify a species scientific name to query Ensembl Plants (if present) for short names, short descriptions and arabidopsis thaliana orthologs (e.g. -p 'species_name')")
parser$add_argument("-o", "--outputnetworkname", dest="outputnetworkname", required=FALSE, help="Output Network Name (default: input_network_name + '_DiNaR_ready.txt'")

#Storing User input arguments into variables
args <- parser$parse_args()
nodes <- args$nodes
edges <- args$edges
#species <- args$species
custom <- args$custom
ensemblplants <- args$ensemblplants
outputnetworkname <- args$outputnetworkname

nodes_df <- nodes
edges_df <- edges
annotation <- custom

#Read and process Input network file
nodes_df <- read.csv(nodes_df, sep = ",")
nodes_df <- read.csv("C:\\Users\\Hugo Rodrigues\\Documents\\corkoakdataFIM\\node1.csv", sep = ",")
edges_df <- read.csv(edges_df, sep = ",")
edges_df <- read.csv("C:\\Users\\Hugo Rodrigues\\Documents\\corkoakdataFIM\\edge1.csv", sep = ",")
#Gene/Protein column must be in the first position/first column of the Node Table
ID_column_name <- names(nodes_df)[1]
#List of genes/proteins present in the network
IDlist <- nodes_df[ , 1]
#Safety measure - remove possible gene/protein ID duplicates from input Network
IDlist <- sapply(IDlist, unique)

#Code chunk for the -species option (might be available later if GoMapMan supplies a direct link to exports)
#For the GoMapMan annotation option
#if( grepl(".", annotation, fixed = TRUE) == FALSE) {
  #print(paste("Running GoMapMan option for the user-defined species", annotation))
  #print("WARNING: This option is only available when working with Protein Networks and with species stored into the GoMapMan database")
  #print("GoMapMan currently available species: arabidopsis_thaliana; ...")
#if( annotation == "arabidopsis_thaliana") {
  #Download arabidopsis mapping file (mercator.results) from GoMapMan database
  #zipped_annotation <- gzcon(url("http://www.gomapman.org/export/current/mapman/ath_Araport11_2018-05-25_mapping.txt.gz"))
#} ifelse( annotation == "cork_oak") {
  #zipped_annotation <- gzcon(url("xpto"))
#}
#Unzip and store into an annotation dataframe the downloaded file
#annotation_txt <- readLines(zipped_annotation)
#annotation <- read.csv(textConnection(annotation_txt), sep = "\t")
#If it fails insert a break here and say:
#print("ERROR: The user-defined species is not present in the GoMapMan database, or a Protein Input Network was not provided")

#Check and read user input for MapMan annotations (obtained in Mercator4, for example)
#The annotation file or PATH/TO/file should be specified in the -c (custom) option

if( exists("custom") == TRUE) {
  annotation <- read.csv("C:\\Users\\Hugo Rodrigues\\Documents\\corkoakdataFIM\\corkoak.results.txt", sep = "\t")
  annotation <- read.csv(annotation, sep = "\t")
}


#Cleaning Mercator file
annotation[ , 1] <-gsub("'","",as.character(annotation[ , 1]))
annotation[ , 2] <-gsub("'","",as.character(annotation[ , 2]))
annotation[ , 3] <-gsub("'","",as.character(annotation[ , 3]))
annotation[ , 4] <-gsub("'","",as.character(annotation[ , 4]))

#Making Mercator results Uppercase
annotation$IDENTIFIER <- toupper(annotation$IDENTIFIER)
#Removing rows from the annotation file which contain gene/protein IDs not present in the input Network
annotation_IDs <- annotation$IDENTIFIER
annotation <- annotation[annotation$IDENTIFIER %in% IDlist, ]
#If gene/protein IDs from Input Network don't match IDs in the Mercator results file or the ones stored into GoMapMan database, display error message
if (nrow(annotation) == 0) {
  stop(" Input Gene/Protein IDs from Input Network are not matching with the ones supplied in the Mercator results file.\n
      If they match, this error may be due to gene/protein IDs in Input network not being in the first column (mandatory).")
}
  
#Creating Temporary Empty Dataframes to store the MapManBINs
mat5 <- matrix(ncol = 5, nrow = 0)
mat2 <- matrix(ncol = 2, nrow = 0)
single_bins <- data.frame(mat5)
multiple_MapManBINs <- data.frame(mat2)
new_multiple_bins <- data.frame(mat5)
names(single_bins) <- (c("BINCODE","NAME","IDENTIFIER","DESCRIPTION", "TYPE"))
names(multiple_MapManBINs) <- (c("IDENTIFIER","MapManBin"))
  
#Retrieve MapManBIN annotation for each gene/protein ID in the input Network
for (ID in 1:length(IDlist)) {
  bins <- annotation[annotation[ , 3] == IDlist[ID], ]
  #Get gene/protein ID which are associated to MapManBINs
  if (nrow(bins) >= 1) {
    #Store gene/protein IDs associated to only 1 BIN into the single_bins dataframe
    if (nrow(bins) == 1) {
      single_bins <- rbind(single_bins, bins)
    } else {
      #Transform multiple BIN associations into one single Gene - BINs association row
      bins$MapManBin <- paste(bins$BINCODE, bins$NAME, sep = "_")
      mapmanvector <- bins$MapManBin
      for (i in 1:length(mapmanvector) - 1) {
        MapManBin <- paste(mapmanvector[i], mapmanvector[i+1], sep = " | ")
      }
      #Create dataframe (multiple_MapManBINs) with Gene associated with multiple BINs (2 columns)
      IDENTIFIER <- IDlist[ID]
      new_entry <- data.frame(IDENTIFIER, MapManBin)
      multiple_MapManBINs <- rbind(multiple_MapManBINs, new_entry)
    }
  }
}

#Creating the New MapManBIN column for genes associated with only 1 BIN
single_bins$MapManBin <- paste(single_bins$BINCODE, single_bins$NAME, sep = "_")
single_MapManBINs <- single_bins[ , c("IDENTIFIER","MapManBin")]

#Join MapManBINs in the Original Input Network
All_MapManBINs <- rbind(single_MapManBINs, multiple_MapManBINs)
colnames(All_MapManBINs)[1] <- ID_column_name
#Safe-check, remove duplicate gene/protein IDs from node_df and MapManBins
nodes_df <- dplyr::distinct(nodes_df, geneID, .keep_all = TRUE)
All_MapManBINs <- dplyr::distinct(All_MapManBINs, geneID, .keep_all = TRUE)
#Finnaly merge the Bins in their correspondent IDs
Output_network <- dplyr::left_join(nodes_df, All_MapManBINs, by = "geneID")
#Replace NA for gene/protein IDs associated with no BINs with '-'
Output_network[is.na(Output_network)] <- '-'



#Add cluster Info, X and Y coordinates for DiNaR compatibility
bin_nodes <- Output_network

#Construct igraph object from Node and Edge tables
g <- graph.data.frame(edges_df, vertices = bin_nodes, directed = TRUE)

l1 = layout_on_grid(g, dim = 2)

if ((vcount(g) <= 2^11) & (ecount(g) >= 2^2) & (ecount(g) <= 2^14)) {
  l2 = layout_with_kk(g, coords = l1, dim = 2,
                      maxiter = 999 * vcount(g),
                      epsilon = 0, kkconst = vcount(g),
                      #weights = rep(100, length.out),
                      minx = NULL, maxx = NULL,
                      miny = NULL, maxy = NULL,
                      minz = NULL,maxz = NULL)
} else {l2 = l1}
z = round(ecount(g)/vcount(g))
l2 = l2*2*z

#Add vertex attributes
V(g)$shortName <- rep("-", vcount(g))
V(g)$shortDescription <- rep("-", vcount(g))
V(g)$clusterID <- rep(1, vcount(g))
V(g)$x <- as.numeric(l2[,1])
V(g)$y <- as.numeric(l2[,2])
mydeg = igraph::degree(g, loops = FALSE, normalized = FALSE,  mode = "all")
V(g)$clusterSimplifiedNodeDegree <- mydeg
V(g)$expressed <- rep(1, vcount(g))

#Preparing Output Node Table
geneID <- V(g)$name
shortName <- V(g)$shortName
shortDescription <- V(g)$shortDescription
MapManBin <- V(g)$MapManBin
clusterID <- V(g)$clusterID
x <- V(g)$x
y <- V(g)$y
clusterSimplifiedNodeDegree <- V(g)$clusterSimplifiedNodeDegree
expressed <- V(g)$expressed
g_df <- as.data.frame(geneID)
g_df <- cbind(g_df, shortName, shortDescription, MapManBin, clusterID, x, y, clusterSimplifiedNodeDegree, expressed)

#Preparing Output Edge Table
cluster_info <- g_df[ , c('geneID', 'clusterID', 'clusterSimplifiedNodeDegree')]
names(cluster_info) <- c('geneID1', 'clusterID_geneID1', 'clusterSimplifiedNodeDegree_geneID1')
newedges_1 <- left_join(edges_df, cluster_info, by="geneID1")
names(cluster_info) <- c('geneID2', 'clusterID_geneID2', 'clusterSimplifiedNodeDegree_geneID2')
newedges <- left_join(newedges_1, cluster_info, by="geneID2")
newedges$exists <- rep(1, nrow(newedges))

Final_Output_Node_network <- g_df
Final_Output_Edge_network <- newedges

#Ensembl Plants option to retrieve shortNames, shortDescriptions, GO:Term annotations and athaliana Homologs
if( exists("ensemblplants") == TRUE) {
  
  #Read Input Query List
  genes <- IDlist
  species <- ensemblplants
  if( grepl('_', species, fixed = TRUE) == TRUE) {
    species <- paste0(substr(species,1,1), strsplit(species, "_")[[1]][[2]])
  }
  species <- paste0(species, "_eg_gene")
  
  #Connect to EnsemblPlantsDB
  plant_ensembl = useEnsemblGenomes(biomart="plants_mart")
  #Connect to Query Genome
  plant_mart = useEnsemblGenomes(biomart="plants_mart", dataset= species )
  
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
  annotation <- getBM(attributes=c('ensembl_gene_id','go_id','goslim_goa_description'),filters = 'ensembl_gene_id', values = new_genes, mart = plant_mart)
  annotation$go_id_description <- paste(annotation$go_id, annotation$goslim_goa_description, sep = "_")
  
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
  
  #Adding Ensembl output into Output_network
  names(output)[names(output) == 'ensembl_gene_id'] <- "geneID"
  Final_Output_Node_network <-dplyr::select(Final_Output_Node_network, -c('shortName', 'shortDescription'))
  Final_Output_Node_network <- dplyr::left_join(Final_Output_Node_network, output, by = "geneID")
  Final_Output_Node_network <- Final_Output_Node_network[, c(1,8,9,2:7,10:ncol(Final_Output_Node_network))]
}

#Finishing Final_Output_Node_network
colnames(Final_Output_Node_network) <- c('geneID','shortName','shortDescription','MapManBin','clusterID','x','y','clusterSimplifiedNodeDegree','expressed','GO:Terms','Athaliana_Homolog_ID','Athaliana_Homolog_name','Athaliana_Homolog_peptideID','Athaliana_Homolog_perc')
Final_Output_Node_network[Final_Output_Node_network == "" | Final_Output_Node_network == " "] <- NA
Final_Output_Node_network <- Final_Output_Node_network %>% dplyr::mutate_all(~replace(., is.na(.), "-"))



#Creating a Output network file name by default (Same as input network file + _DiNaR_Ready.txt)
output_file_name_node <- paste(deparse(substitute(network)), "DiNaR_Ready_Node.txt", sep = "_")
output_file_name_node <- "DINAR_READY_NODE.txt"
output_file_name_edge <- paste(deparse(substitute(network)), "DiNaR_Ready_Edge.txt", sep = "_")
output_file_name_edge <- "DINAR_READY_EDGE.txt"
#OR
#Creating a Output network file name specified by the user (-o, --output optional argument)
if (is.null(output) == FALSE) {output_file_name <- paste(output, ".txt")}


#Writing the Output Node Network - DiNaR Ready!
complete_output_file_name <- paste(dir, output_file_name_node, sep = "/")
write.table(Final_Output_Node_network, complete_output_file_name, sep = "\t", row.names = FALSE, quote = FALSE)
complete_output_file_name <- paste(dir, output_file_name_edge, sep = "/")
write.table(Final_Output_Edge_network, complete_output_file_name, sep = "\t", row.names = FALSE, quote = FALSE)
#write.csv(Output_network, "teste1.csv", row.names = FALSE, quote = FALSE)