.. _task4-label:

Task 4 - Ensembl Plants Query
=============================

This task will guide the user on how to retrieve gene names, descriptions and orthologs from the `Ensembl Plants database <https://plants.ensembl.org/index.html>`_ using R within the command line. The provided Ensembl_Query.R script also allows the user to retrieve information with predefined queries. Alternatively, this task can be mannualy performed in the Ensembl Plants website using the `BioMart Query tool <https://plants.ensembl.org/biomart/martview/dd3908a2674f948aee19f80a0e2bef9b>`_.

.. note:

The following steps require R (version 4.1+) to be installed. If not already installed, please `download and install R here <https://www.r-project.org/>`_.

Step-by-Step Single Gene Query
------------------------------

.. code-block:: R

   #Connect to the Ensembl Plants Database
   plant_ensembl = useEnsemblGenomes(biomart="plants_mart")

   #Check the available list of Plant Datasets available
   listDatasets(plant_ensembl)

   #Connect to a dataset of choosing (in this example, connect to the cork oak dataset)
   #To connect to other datasets, use the following syntax: Genus 1º letter + Species name + _eg_gene (e.g. qsuber_eg_gene)
   plant_mart = useEnsemblGenomes(biomart="plants_mart", dataset= species )

   #Check the available list of Dataset attributes/features
   listAttributes(plant_mart)

.. note::

   In cork oak's case, all gene ID's must have a "gene-" prefix for a sucessfull query

.. code-block:: R

   #Obtaining gene descriptions for a single gene
   single_description <- getBM(attributes=c('ensembl_gene_id', 'ensembl_peptide_id','description'),filters = 'ensembl_gene_id', values = "gene-CFP56_45155", mart = plant_mart)
   single_description

.. csv-table::
   :header: "ensembl_gene_id", "ensembl_peptide_id", "description"
   :widths: 10, 10, 15

   "CFP56_23532", "POE85947.1", "*NA*"

* ``ensembl_gene_id`` - Gene stable ID
* ``ensembl_peptide_id`` - Protein stable ID
* ``description`` - Gene description

Step-by-Step Multiple Genes Query
---------------------------------

.. code-block:: R

   #Set working directory within the corkoak_usecase folder
   cd corkoak_usecase

   #Connect with the Ensembl Plants Database
   plant_ensembl = useEnsemblGenomes(biomart="plants_mart")

   #Connect to the cork oak dataset
   plant_mart = useEnsemblGenomes(biomart="plants_mart", dataset= species )

   #Read Node Table (containing cork oak Gene IDs)
   genes <- readLines("Ensembl_Query.txt")

   #Modifying all Gene IDs to have the "gene-" prefix
   new_genes <- paste0("gene-", genes)

   #Obtaining multiple gene descriptions at once
   #In this case, instead of specifying a single gene ID in the *values field*, we provide a gene list (new_genes)
   multiple_descriptions <- getBM(attributes=c('ensembl_gene_id', 'ensembl_peptide_id', 'description'),filters = 'ensembl_gene_id', values = new_genes, mart = plant_mart)
   multiple_descriptions

.. csv-table::
   :header: "ensembl_gene_id", "ensembl_peptide_id", "description"
   :widths: 15, 15, 15

   "gene-CFP56_23532", "cds-POE85947.1", "*NA*"
   "gene-CFP56_24732", "cds-POF21607.1", "*NA*"
   "gene-CFP56_18234", "cds-POE85887.1", "*NA*"
   "...", "...", "..."

.. note::

   Available descriptions were not found within the Ensembl Plants database due to a lack of available cork oak annotations.

| More columns can be retrieved by specifying more atributes within the **attributes field**.
| Some additional atributes of interest include:

 * ``ensembl_transcript_id`` - Transcript stable ID
 * ``ensembl_exon_id`` - Exon stable ID
 * ``chromosome_name`` - Chromosome/scaffold name
 * ``start_position`` - Gene start (bp)
 * ``end_position`` - Gene end (bp)
 * ``strand`` - Strand
 * ``band`` - Karyotype band
 * ``transcript_start`` - Transcript start (bp)
 * ``transcript_end`` - Transcript end (bp)
 * ``transcription_start_site`` - Transcription start site (TSS)
 * ``transcript_length`` - Transcript length (including UTRs and CDS)
 * ``transcript_is_canonical`` - Ensembl Canonical
 * ``transcript_count`` - Transcript count
 * ``percentage_gene_gc_content`` - Gene % GC content
 * ``gene_biotype`` - Gene type
 * ``transcript_biotype`` - Transcript type
 * ``source`` - Source (gene)
 * ``transcript_source`` - Source (transcript)

.. note::

   For a complete attribute list, run the following:

.. code-block:: R

   all_attributes <- listAttributes(plant_mart) 
   view(all_attributes)

Step-by-Step Multiple Genes Query - Annotations
-----------------------------------------------

.. code-block:: R

   #Following the same syntax, by changing attributes within the attribute field, the retrieved information will be different
   #In this case, to obtain gene annotations (GO:Terms) and correspondent descriptions for a list of genes, run:
   gene_annotations <- getBM(attributes=c('ensembl_gene_id','go_id','name_1006'),filters = 'ensembl_gene_id', values = new_genes, mart = plant_mart)
   gene_annotations

.. csv-table::
   :header: "ensembl_gene_id", "go_id", "name_1006"
   :widths: 10, 10, 15

   "gene-CFP56_04669", "GO\:0016020", "membrane"
   "gene-CFP56_04669", "GO\:0030244", "cellulose biosynthetic process"
   "...", "...", "..."
   "gene-CFP56_18234", "GO\:0009834", "plant-type secondary cell wall biogenesis"
   "gene-CFP56_18234", "GO\:0010417", "glucuronoxylan biosynthetic process"
   "...", "...", "..."

* ``ensembl_gene_id`` - Gene stable ID
* ``go_id`` - GO term accession
* ``name_1006`` - GO term name

According to the retrieved annotations, we observe that the queried cork oak genes are putatively related with plant growth, apparent by their activity on phenylpropanoid biosynthetic processes in the cell membrane, which occurs during secondary cell wall biogenesis.

Some available atributes regarding **Annotation**, in addition to the previous, include:

 * ``definition_1006`` - GO term definition
 * ``go_linkage_type`` - GO term evidence code
 * ``namespace_1003`` - GO domain
 * ``goslim_goa_accession`` - GOSlim GOA Accession(s)
 * ``goslim_goa_description`` - GOSlim GOA Description
 * ``embl`` - European Nucleotide Archive ID
 * ``uniparc`` - UniParc ID
 * ``uniprotswissprot`` - UniProtKB/Swiss-Prot ID
 * ``pfam`` - Pfam ID
 * ``scanprosite`` - PROSITE patterns ID
 * ``superfamily`` - Superfamily ID
 * ``tigrfam`` - TIGRFAM ID
 * ``interpro`` - Interpro ID
 * ``interpro_short_description`` - Interpro Short Description
 * ``interpro_description`` - Interpro Description

Step-by-Step Multiple Genes Query - Homologs
--------------------------------------------

| Gene homologs can be retrieved for most plant species using the following attribute syntax:
| [Genus 1º letter + Species name + "_eg_homolog_ensembl_gene"] (e.g. athaliana_eg_homolog_ensembl_gene)

.. note::

   For a complete list of all plant species available for homolog query, run the following:

.. code-block:: R
   
   all_attributes <- listAttributes(plant_mart)
   view(all_attributes) 
   #Scroll down to the *Homologs* section. Every line containing _eg_homolog_ensembl_gene is an available species

Gathering *Arabidopsis thaliana* Homologs:

.. code-block:: R

   #Gathering Arabidopsis thaliana homologs
   gene_athaliana_homologs <- getBM(attributes=c('ensembl_gene_id','athaliana_eg_homolog_ensembl_gene','athaliana_eg_homolog_associated_gene_name'),filters = 'ensembl_gene_id', values = new_genes, mart = plant_mart))
   gene_athaliana_homologs

.. csv-table::
   :header: "ensembl_gene_id", "athaliana_eg_homolog_ensembl_gene", "athaliana_eg_homolog_associated_gene_name"
   :widths: 10, 10, 10

   "gene-CFP56_04669", "AT5G44030", "CESA4"
   "gene-CFP56_04887", "AT2G46495", "AT2G46495"
   "gene-CFP56_18234", "AT1G27440", "GUT2"
   "...", "...", "..."

* ``ensembl_gene_id`` - Gene stable ID
* ``athaliana_eg_homolog_ensembl_gene`` - *Arabidopsis thaliana* gene stable ID
* ``athaliana_eg_homolog_associated_gene_name`` - *Arabidopsis thaliana* gene name

A species list (possibly outdated) which allows homologs retrieval are, in addition to the previous:

 * ``achinensis_eg_homolog_ensembl_gene`` - *Actinidia chinensis* gene stable ID
 * ``atauschii_eg_homolog_ensembl_gene`` - *Aegilops tauschii* gene stable ID
 * ``atrichopoda_eg_homolog_ensembl_gene`` - *Amborella trichopoda* gene stable ID
 * ``acomosus_eg_homolog_ensembl_gene`` - *Ananas comosus* gene stable ID
 * ``ahalleri_eg_homolog_ensembl_gene`` - *Arabidopsis halleri* gene stable ID
 * ``alyrata_eg_homolog_ensembl_gene`` - *Arabidopsis lyrata* gene stable ID
 * ``aalpina_eg_homolog_ensembl_gene`` - *Arabis alpina* gene stable ID
 * ``aofficinalis_eg_homolog_ensembl_gene`` - *Asparagus officinalis* gene stable ID
 * ``asot3098_eg_homolog_ensembl_gene`` - *Avena sativa* OT3098 gene stable ID
 * ``assang_eg_homolog_ensembl_gene`` - *Avena sativa* Sang gene stable ID
 * ``bvulgaris_eg_homolog_ensembl_gene`` - *Beta vulgaris* gene stable ID
 * ``bdistachyon_eg_homolog_ensembl_gene`` - *Brachypodium distachyon* gene stable ID
 * ``bjuncea_eg_homolog_ensembl_gene`` - *Brassica juncea* gene stable ID
 * ``bnapus_eg_homolog_ensembl_gene`` - *Brassica napus* gene stable ID
 * ``boleracea_eg_homolog_ensembl_gene`` - *Brassica oleracea* gene stable ID
 * ``brro18_eg_homolog_ensembl_gene`` - *Brassica rapa R-o-18* gene stable ID
 * ``ccajan_eg_homolog_ensembl_gene`` - *Cajanus cajan* (pigeon pea) - GCA_000340665.1 gene stable ID
 * ``csativa_eg_homolog_ensembl_gene`` - *Camelina sativa* gene stable ID
 * ``csfemale_eg_homolog_ensembl_gene`` - *Cannabis sativa* female gene stable ID
 * ``cannuum_eg_homolog_ensembl_gene`` - *Capsicum annuum* gene stable ID
 * ``cbraunii_eg_homolog_ensembl_gene`` - *Chara braunii* gene stable ID
 * ``cquinoa_eg_homolog_ensembl_gene`` - *Chenopodium quinoa* gene stable ID
 * ...

Predefined Queries with Ensembl_Plants_Query.R
----------------------------------------------

This script allows the user to specify few input arguments in order to obtain a output table with the following format:

.. csv-table::
   :header: "geneID", "ensembl_peptide_id", "description", "go_id_description", "athaliana_eg_homolog_gene", "athaliana_eg_homolog_associated_gene_name", "athaliana_eg_homolog_perc_id_r1"
   :widths: 10, 10, 15, 10, 10, 10, 10

   "CFP56_04669", "POF10443.1", "*NA*", "GO\:0016020_d1 | GO\:0016020_d2 | GO\:0016020_d3 ...", "AT5G44030", "CESA4", "78.6642"
   "CFP56_18234", "POE85887.1", "*NA*", "GO\:0016757_d1 | GO\:0016757_d2 | GO\:0016757_d3 ...", "AT1G27440", "GUT2", "87.3786"
   "...", "...", "...", "...", "...", "...", "..."

* ``geneID`` - input gene ID
* ``ensembl_peptide_id`` - Protein stable ID
* ``description`` - Gene description
* ``go_id_description`` - list of GO\:Terms and respective descriptions associated with a given gene
* ``athaliana_eg_homolog_gene`` - Arabidopsis thaliana homolog ID (filtered for the highest %identity between query and *Arabidopsis thaliana* gene)
* ``athaliana_eg_homolog_associated_gene_name`` - *Arabidopsis thaliana* gene name
* ``athaliana_eg_homolog_perc_id_r1`` - %id. query gene identical to target *Arabidopsis thaliana* gene

This script receives the following mandatory arguments:

1. Gene ID list (.txt format, one per line)
2. Species name (e.g. qsuber)

And optional arguments:

3. Output name and format (e.g. qsuber_annotated.csv)

Example of use:

.. code-block:: R

   #Within the command line:
   Rscript Ensembl_Plants_Query.R -g genes.txt -s qsuber -o annotated_genes.csv

This concludes Task 4 of the current Use Case.

