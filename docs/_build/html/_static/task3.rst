.. _static/task3-label:

Task 3 - Cytoscape into DiNaR Network Visualization
===================================================

DiNaR is a tool used to obtain a dynamic representation of a biological data network over multiple timepoints or different conditions.

Obtaining a dynamic network representation from a cork oak co-expression network
--------------------------------------------------------------------------------

1. Run the``Cytoscape_DiNaR.R`` from the command line.

   .. code-block:: R

      #Inside the directory of the downloaded cork oak data (should also contain ``Cytoscape_DiNaR.R``)
      Rscript ./Cytoscape_DiNaR_link.R -n ./corkoak_node.csv -e ./corkoak_edge.csv -a ./corkoak_mercator.results -o corkoak_ready_to_process

2. Go to the DiNaR preprocessing subApp and select the **tables** option tab (at the top).
3. With the Tab default Separator, click **Choose Nodes File** and select ``node_corkoak_ready_to_process.txt``.
4. Click **Choose Edges File** and select ``edge_corkoak_ready_to_process.txt``.
5. Fill the **Type in desired network name:** with ``corkoak_processed``.
6. Click download (at the bottom) **BOTH** in the Nodes tab, and in the Edges tab (both next to Plot), to ensure both the node and edge tables are downloaded.
7. Go to the `DiNaR App <https://nib-si.shinyapps.io/DiNAR/>`_.
8. In **select network**, choose **Custom network**.
9. In **Upload nodes table**, select the ``processed_node`` file.
10. In **Upload edges table**, select the ``processed_edge`` file.
11. Download the animation with - get final .html output.

Congratulations, this task concludes the present use-case. 
Further questions or recomendations can be submitted to: myemail?

