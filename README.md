# Long tail recovery project for soils

## Purpose

The purpose of this project is to aggregate data sets related to soils research. This includes field surveys, field manipulation studies, and labortory experiments. 
The hope is that this will serve as an open community resource to uncover new mechansims and quantify effects related to soil processes that are globally generalizable.

This project identifies soil carbon datasets that are publically avaiable, provides data harmonization scripts to integrate those data sets, and provides output scripts for the harmonized data product.

This project is not a repository or data archive.
End users are responsible for complying with ALL data use policies, please check with the orginal archives and reposities to ensure you are complying with use policies.
Data repositiories with relatively unrestricted (citation/acknowledgement but no co-authorship requirements) reuse policies are prioritized for data scripting.

## How to contribute

There are three main ways to contribut to this project:
1) *Identify* data sets of interest
2) *Code* data processing scripts to ingest new data sets
3) *Review* submitted scripts for complience with larger data set


Contributers who identify, code and/or review will be acknowledged as co-authors during data set versioning milestones. Please ensure that your name, affiliation and role is correctly identified in the CONTRIBUTORS.txt file. 
Once a data set is found please start an issue including full citation and link to the archived data, this should be updated and used to coordinate data migration from identification to fully processed.
Processing scripts should be submitted to [SoilDataR](https://github.com/ktoddbrown/soilDataR) via a pull request and filenames should follow the 'processData_\$PI\$year.R' format.
There is a generalized [key-template script](https://github.com/ktoddbrown/soilDataR/blob/master/R/processData_Templet.R) which we suggest you use when possible.
Place any dataset keys in the dataset_keys folder of this project; variables should be keyed to ISCN standard names when possible (see the `var` column in [ISCNKey](https://github.com/ktoddbrown/soils-long-tail-recovery/blob/master/dataset_keys/ISCNKey.xlsx)), new variables will be considered as standardized canidates for future ISCN data products. For more details on the expected input file formats and structure of the data key please see the [wiki](https://github.com/ktoddbrown/soils-long-tail-recovery/wiki).

Data contributes are welcome, however the data set must be previously archived elsewhere with an assigned DOI.
Data providers are encouraged to collaborate with coders to ensure correct data ingestion.
Data sets with unrestricted reuse policies are priority incorperation in this project.
Data may be excluded from versioning due to data permissions and study authors are encouraged to check permissions before publication.

## Open data calls
Below are active data calls that have reviewers interested in targeted data types for future manuscripts.

1) Labratory incubated soil respiration response to moisture manipulation. Reviewers: K Todd-Brown and B Bond-Lamberty

## Citations
Repository versions will be assigned DOIs as needed.
Any manuscripts which use these data harmonization scripts are asked to cite the appropreate version but are not required to list contributers as co-authors.
The aggregation scripts here are licensed under BSD 2-clause. See LICENSE.txt for details.

# References of interest

rOpenSci Project: https://ropensci.github.io/

R package for interacting with DataOne: https://jsta.github.io/2017/03/28/dataone.html

Five ways consortia can catalyse open science, Nature, 2017 http://www.nature.com/news/five-ways-consortia-can-catalyse-open-science-1.21706

National Data Service: http://www.nationaldataservice.org/
