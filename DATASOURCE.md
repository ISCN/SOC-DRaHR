We love data and believe that if someone took the time to record something that data has value. That being said not every data is appropreate for this project.

For incorporation into this project a dataset needs to have:

1) Soil carbon stocks [mass volume-1] quantified, preferably bulk density [mass volume-1] and organic carbon percentage [mass mass-1]. Any gap-filling needs to be clearly identified.
2) A public archive-level DOI or permanent URL guarantee for at least 10 years

Datasets will be prioritized based on:

1) Large number of sites (latitude-longitude-depth-time) characterized
2) Data that are currently of interest to contributors working on meta-analysis
3) Data with permissive reuse policy

# Identified data

flag
    + hold - do not ingest data in SOC-DRaHR, likely another ongoing data effort

|          | references | description |     identifier     | flag |
| ------ | ----------- | ----------------- | ------------ | ---------- |
| He 2016 | [He etal Science 2016](http://science.sciencemag.org/content/353/6306/1419.full) | This is a soil radiocarbon meta analysis with 150+ data points from several different studies. | @ktoddbrown | hold for MPI group |
| Pommier 2017 | [Pommier, Thomas (2017): Measures of microbial, soil and plant variables of three grass-based agro-ecosystems in Austria, the UK and France. PANGAEA, https://doi.org/10.1594/PANGAEA.879537](https://doi.pangaea.de/10.1594/PANGAEA.879537) | Measures of microbial, soil and plant variables of three grass-based agro-ecosystems in Austria, the UK and France (underrepresented regions) | @marzipanwich | |
| Hume 2017 | [Hume etal J of App Eco, 2017](https://doi.org/10.1111/1365-2664.12942) [data](http://datadryad.org/resource/doi:10.5061/dryad.dd602) | Forest harvest meta-analysis of 808 observations from 49 studies to test the effects of harvesting on the stocks and concentrations of soil C, N, and P and C:N:P ratios relative to uncut control stands | @SJTumber | |

# Active data

coders: list the coders who are active on this data
status: discribe where the data is in the data harmonization queue
    + keyed - data headers have been mapped to internal variables and relationship tables
    + scripted - data has a scripted ingestion

|             | DOI or url |  download link | description | coders | status |
| -------- | ----------- | -----------------| ------------- | -------- | ------- |
| Treat 2015 | ISCN 4 queue | [link](http://iscn.fluxdata.org/wp-content/uploads/sites/15/ISCNtemplate_Treat_peatProps_v2.xlsx) | Peat properties synthesis dataset (2MB, XLSX format, download only; ISCNtemplate_Treat_peatProps_v2): This dataset is a synthesis of literature and site-level data on peat properties, C, N, 14C, and vegetation from 366 sites worldwide. Data are available for nearly 16,000 layers from 659 profiles. Data contributed by Claire Treat. | @ktoddbrown | keyed |
| ISCN3 | 10.17040/ISCN/1305039 | [1](ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx) [2](ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C2_1-1.xlsx) [3](ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C3_1-1.xlsx) [4](ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx) [citations](ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL-DATA-CITATION_1-1.xlsx) [contributing](ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_DATASET_1-1.xlsx) | Collection of soil survey data from around the world | @ktoddbrown | scripted |

