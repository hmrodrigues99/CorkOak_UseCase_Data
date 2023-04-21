.. _tool1-mercator-label:

Mercator4 Webtool
=================

The `mercator4 <https://www.plabipd.de/mercator_main.html>`_ webtool is a online tool to assign functional annotations to protein sequences of land plants. The **Mercator4 - about** section describes in greater detail the use and purpose of this tool, which can be accessed under the **online tools - protein annotation** section. Additionaly, this section also provides a FASTA validator tool which can be used prior to job submission in Mercator4 to verify if the user input FASTA is compatible with Mercator4. Lastly, after obtaining the job results, these can be used in the enrichment analysis tool to check for enriched MapMan BINs in a annotated gene/protein list of interest.

Mercator4 Result Visualization Tools
------------------------------------

The output files (``corkoak.results`` and ``corkoak.faa``) which are used throughout tasks 2 and 3 of this use case represent Mercator4 main outputs.
Nevertheless, upon job conclusion, the user can further explore the following **Result Tabs** within Mercator4 for additional information:

* **Job submission** - Summary of which MapMan Bins the data was annotated in.

* **Result tree viewer** - Allows comparison between the number of genes/protein which occupy each Bin for the organism submitted by the user and other reference species. It can serve as a basis to understand if the user input species has more or less genes/proteins annotated in a specific process when compared to other organisms. This comparison can be performed between organisms from multiple job submissions.

* **Result Heatmap viewer** - Different visualization layout of simmilar information provided in the **Result tree viewer** tab.