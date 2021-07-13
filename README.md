This repository provides the data and code necessary to reproduce the analyses from the following article:

Giomi, Evan, Barbara J. Mills, Leslie D. Aragon, Benjamin A. Bellorado, and Matthew A. Peeples
Reading between the Lines: The Social Value of Dogoszhi Style in the Chaco World. _American Antiquity_ in press.

Note that the site locations included in this repository have been jittered and rounded to the nearest 10km to ensure the security of site location informatoin.

If you simply want to rerun all of the analyses in the paper and produce new versions of the figures, you can place all of the included files in a single directrory and run the "Dogoszhi_all.R" script which will initialize and call of the required functions and reproduce figures 5-11 from the paper in PDF form. I describe the individual analytical steps and files involved in detail below.

# Analysis Procedures: 

## 1) Apportioning 

The first step required for this analysis is to chronologically apportion ceramic data from all sites in the database into 50-year intervals for further analysis. As described in the paper, we do this using procedures originally published by Roberts et al. 2012. The code required is included in this repository but this apporitioning code is also available and documented in detail in [another repository here](https://github.com/mpeeples2008/CeramicApportioning). 

All of the code required for completing this step in the analysis is in the **apportion_all.R** file. Running this script produces the **apportioned.RData** file which contains both the two input files as R objects and an object called **wareapp** which contains the final apportioned ceramic data aggregated by ware and **typeapp** which includes the same data by type.

This function uses the following input files
* preapportion.csv - This is the raw ceramic data which includes a long-formatted table with a with rows representing unique site ID, site name, ceramic type name, and ceramic count combinations. For each row the beginning and end date of the site and beginning and end date of the type are also included.
* Ceramic_type_master.csv - This file contains a list of every ceramic type and ware in the [Southwest Social Networks Project](https://southwestsocialnetworks.net/) database as of the completion of this article. This is how ceramic type names from the "preapportion file" are converted to ceramic ware categories (SWSN_Ware). This file also includes other descriptive information on the ceramics including the type of decoration, the associated dates, references, and a column called "Dogoszhi" which marks decorated types that show up in the Chaco database as 0 when they do not include Dogoszhi style designs and 1 where they do.
* app_init.csv - This file is produced as an intermediate step in the analysis and rerpresents all ceramic types by site apportioned into 25 year intervals prior to the applicatoin of the iterative proportional fitting procedures (see Roberts et al. 2012 and the repository linked above for more details).
* app_room.csv - This file includes the final apportioned ceramic data after the iterative proportional fitting procedure. 

## 2) Creating Networks

The next step is to create network objects based on the ceramic data. The function **networks_all.R** conducts all of the necessary analysis to complete this step. This set of functions aggregates the apportioned **wareapp** object into 50-year intervals, calculates Brainard-Robinson similarity coeficients for every pair of sites for each of those intervals, and then calculates eigenvector centralities for each site for each 50-year interval based on the weighted similarity network. Note that when this script is called it loads the current apportioned.Rdata file created in the previous step. This procedure will create a new RData file called **network.RData** that includes all of the objects produced in the first two steps.

This function will produce a number of new R objects for each 50-year interval as follows:
* AD900cer - dataframe containing sites as rows and ceramic wares as columns with counts repreenting the apportioned count for the relevant interval (in this case AD 900-949)
* AD900cent - dataframe containing eigenvector centrality scores by site for the relevant interval.
* AD900sim - dataframe containing the raw Brainard-Robinson symmetric similarity matrix for the relevant interval.

## 3) 

Reference Cited:

Roberts, John M., Jr., Barbara J. Mills, Jeffery J. Clark, W. Randall Haas, Jr., Deborah L. Huntley, and Meaghan A. Trowbridge 2012 A method for chronologically apportioning of ceramic assemblages. Journal of Archaeological Science 39(5):1513-1520.

