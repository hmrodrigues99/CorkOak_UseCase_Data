.. CorkOak_UseCase documentation master file, created by
   sphinx-quickstart on Thu Feb  2 16:41:08 2023.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Plant Data Visualization Tool Bundle -  Cork Oak Use Case
==========================================================

.. note::

   This project is under active development.

Extensive phenotypic measurements and high-throughput RNA-seq experiments often make plant data fall in the scope of big data. The current plant data visualization tool bundle provides a set of interopable tools ranging from data annotation, analysis and visualisation to ease treatment and interpretation of plant data.

The present use-case aims to provide the user with the necessary knowledge to properly use and navigate this tool bundle. The use of data obtained from studies in Cork Oak, a non-model woody plant, highlights possible shortcomings which the user may also face regarding the lack of a full reference genome and absent/incomplete data annotations.

.. _download-data-label:

Download Cork Oak Data
----------------------

The first step to follow the present use-case is to download data obtained from cork oak studies. It can be manually downloaded from `github <https://github.com/hmrodrigues99/CorkOak_UseCase>`_ (``https://github.com/hmrodrigues99``), or by running the following in the command line:

**Linux users:**

.. code-block:: Bash

   #Create and move to a new directory named corkoak_usecase
   mkdir corkoak_usecase
   cd corkoak_usecase

   #Download cork oak data from github
   wget https://github.com/hmrodrigues99/CorkOak_UseCase_Data/archive/main.zip

   #Unzip the downloaded file and move into it's directory
   unzip ./main.zip
   #If unzip fails, either install it using ``sudo apt install unzip`` or unzip the ``main.zip`` file manually
   cd CorkOak_UseCase_Data-main

**Windows R Users:**

.. code-block:: R

   #Create and move to a new directory named corkoak_usecase
   dir.create("corkoak_usecase")
   setwd("corkoak_usecase")

   #Installing R.utils package, if not already installed
   if (!require("utils")) install.packages("utils")
   library("utils")

   #Download the cork oak data folder from github
   download.file(https://github.com/hmrodrigues99/CorkOak_UseCase_Data/archive/main.zip)

   #Unzip the downloaded file and move into it's directory
   unzip(corkoak_data.zip)
   setwd("CorkOak_UseCase_Data-main")

**Windows Python (3.7+) Users:**

.. code-block:: python

   #Within the Command line, install the requests package
   pip install requests

   #Now in a Python IDE, download the cork oak data folder [replace "PathToFile" with a target directory (e.g. "C://Users//hrodrigues//Data//")]
   import requests
   file = requests.get("https://github.com/hmrodrigues99/CorkOak_UseCase_Data/archive/main.zip")
   open('PathToFile//corkoakdata.zip', 'wb').write(file.content)
   

Cork Oak Data Contents:
-----------------------

``corkoak_proteins.faa``
   A FASTA file containing aminoacid sequences of cork oak proteins.

``corkoak_edge``
   Table containing cork oak predicted protein-protein relationships.
   
``corkoak_node``
   Table containing protein IDs and respective descriptions present in ``corkoak_edge``.

``cork_oak_DE_001``, ``cork_oak_DE_002`` and ``cork_oak_DE_003``
   Files containing cork oak experimental data (log2FC values obtained from gene differential expression analysis between well-watered and water-deficit cork oak tissue samples)

``Cytoscape_DiNaR.R``
   R script used to process a Cytoscape network ready to be imported into DiNaR.

Task Workflow:
--------------

After data download, it's all set to start performing the proposed tasks, starting with :ref:`task1-label`.

.. toctree::
   :maxdepth: 2
   :caption: Tasks
   :titlesonly:

   source/task1
   source/task2
   source/task3
   source/task4

.. toctree::
   :maxdepth: 2
   :caption: Tools
   :titlesonly:

   source/tool1_mercator
   source/tool2_mapman
   source/tool3_dinar

.. toctree::
   :maxdepth: 2
   :caption: References
   :titlesonly:

   source/references

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`