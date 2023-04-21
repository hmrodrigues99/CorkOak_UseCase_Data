.. _task2-label:

Task 2 - Metabolic Pathway Visualization
========================================

Integrate and visualize a set of biological data (e.g. genes,proteins,enzymes,..) . This task will handle the set of biological data previously annotated in the :ref:`task1-label` and integrate/visualize it within metabolic pathways of interest using the `MapMan Desktop App <https://plabipd.de/mapman_main.html>`_.

Integrating annotated cork oak data in the Lignin biosynthesis metabolic pathway
--------------------------------------------------------------------------------

1. Perform the download and installation of the MapMan Desktop App using the **download & installation** tab within this 'guide  <https://plabipd.de/mapman_main.html>`_.
2. Launch MapMan, and in the main menu select **Show Pathway to visualize your data in the context of metabolic pathways**.
3. In the left box, right-click **Experiments** -> **Add Data** -> select the **corkoak_DE_001.txt** file.
4. In the left box, right-click **Mappings** -> **New Mapping** -> **from file**, browse and select the **corkoak_proteins_mercator.results** file (obtained in :ref:`task1-label`).
5. In the left box, right-click **Pathways** -> **Add Pathway** -> **download**, select the file named **“/Cell Wall/ X4.1 Lignin R1.0: X4_R1.0"**.
6. In the left-box, right-click **Pathways** -> **Add Pathway** -> **from file** -> select the **“/Cell Wall/ X4.1 Lignin R1.0: X4_R1.0”** file.
7. In the Pathway Workflow - Choose Pathway box, select the **“/Cell Wall/ X4.1 Lignin R1.0: X4_R1.0”** pathway file.
8. In the Pathway Workflow – Choose Mapping box, select the corkoak_proteins_mercator.results mapping file.
9. In the Pathway Workflow – Choose Experimental Data Set, select the **corkoak_DE_001.txt** file.
10. Click **Show Pathway** and download the image using **File** -> **Export as Image**, renaming it as ``corkoak_ligninmap``.

We now have annotated plant data in the context of a specific metabolic pathway. For visualization of the annotated data in a network format, go to the following :ref:`task3-label`.

