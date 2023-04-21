.. _task1-label:

Task 1 - Plant Data Annotation
==============================

To make sense of biological data, we often annotate it with terms that help group and organize it.
Annotated data can be further analysed to gather new insights, such as identifying and/or understanding biological processes of interest.

The `Mercator4 Webtool <https://plabipd.de/portal/mercator4>`_ uses the **MapMan ontology**, a curated vocabulary tailored to annotate plant data. It differs from the more generic Gene Ontology as it describes terms with higher depth and specificity to plant species. A extensive comparison between them is acessible `here <https://www.frontiersin.org/articles/10.3389/fgene.2012.00115/full>`_.

This first task should be performed at the starting point of usage of this tool bundle, as further tasks require **MapMan** annotated data for a more in-depth analysis. If you haven´t already, please download the cork oak data required to follow this use-case in :ref:`download-data-label`. 

Annotating biological data using the MapMan Ontology
----------------------------------------------------

1. Open the Mercator4 Webtool (insert mercator link here)
2. Select the **Sequence Type** as Protein
3. In **Upload FASTA file**, click **Choose File** - corkoak_proteins.faa
4. Fill **Job name** with corkoak_proteins_mercator (maybe get this name into a easy to copy-paste box)
5. **Submit Job**
6. Upon job conclusion, download both the **Mapping file for MapMan** and **Annotated FASTA file**
7. Finally, extract both .rar files (e.g. with WinRar or WinZip)

With the plant annotated data, we are ready to move into :ref:`task2-label`.