.. _task2-label:

Task 2 - Metabolic Pathway Visualization
========================================

Integrate and visualize a set of biological data (e.g. genes,proteins,enzymes, ...) within metabolic pathways of interest using the `MapMan Desktop App <https://plabipd.de/mapman_main.html>`_.
This task will handle the set of proteins previously annotated in :ref:`task1-label`, and integrate/visualize them within a lignin biosynthesis metabolic pathway.

Integrating annotated cork oak data in a metabolic pathway of interest
----------------------------------------------------------------------

1. Perform the download and installation of the MapMan Desktop App using the **download & installation** intructions within this `guide <https://plabipd.de/mapman_main.html>`_.
2. Launch MapMan, and in the main menu select **Show Pathway to visualize your data in the context of metabolic pathways**.

.. figure:: images/mapman_arrow.png
   :scale: 80 %

3. In the left box, right-click **Experiments** -> **Add Data** -> select the ``corkoak_DE_001.txt`` file.
4. In the left box, right-click **Mappings** -> **New Mapping** -> **from file**, browse and select the ``corkoak.results`` file (obtained in :ref:`task1-label`).
5. In the left box, right-click **Pathways** -> **Add Pathway** -> **download**, select the file named ``“/Cell Wall/ X4.1 Lignin R1.0: X4_R1.0"``.
6. In the left-box, right-click **Pathways** -> **Add Pathway** -> **from file** -> select the ``“/Cell Wall/ X4.1 Lignin R1.0: X4_R1.0”`` file.
7. In the Pathway Workflow - Choose Pathway box, select the ``“/Cell Wall/ X4.1 Lignin R1.0: X4_R1.0”`` pathway file.
8. In the Pathway Workflow – Choose Mapping box, select the ``corkoak.results`` mapping file.
9. In the Pathway Workflow – Choose Experimental Data Set, select the ``corkoak_DE_001.txt`` file.
10. Click **Show Pathway** and download the image using **File** -> **Export as Image**, renaming it as ``corkoak_ligninmap.png``.

Video Guide:
^^^^^^^^^^^^

.. raw:: html

   <iframe width="560" height="315" src="https://www.youtube.com/embed/KWb1mpFiuOE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

|

We now have annotated plant data in the context of a specific metabolic pathway! Data can be visualized in different metabolic pathways by using different pathway files, which are acessible in https://plabipd.de/mapman_main.html under the **diagrams compatible with Mercator4 v.5** tab. Different mappings obtained in mercator4 can be used here (e.g. working with multiple datasets; or making a job submission with a complete genome/proteome). Finnaly, the Experiments file, although allow further interpretation of the results, is not mandatory, so a dummy Experiments file can be supplied.

For visualization of the annotated data in a network format, go to the following :ref:`task3-label`.