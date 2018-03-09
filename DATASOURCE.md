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

|          | manuscript | data | description |     identifier     | flag |
| ------ | -----|------ | ----------------- | ------------ | ---------- |
| He 2016 | [He etal Science 2016](http://science.sciencemag.org/content/353/6306/1419.full) | | This is a soil radiocarbon meta analysis with 150+ data points from several different studies. | @ktoddbrown | hold for MPI group |
| Pommier 2017 | | [Pommier, Thomas (2017): Measures of microbial, soil and plant variables of three grass-based agro-ecosystems in Austria, the UK and France. PANGAEA, https://doi.org/10.1594/PANGAEA.879537](https://doi.pangaea.de/10.1594/PANGAEA.879537) | Measures of microbial, soil and plant variables of three grass-based agro-ecosystems in Austria, the UK and France (underrepresented regions) | @marzipanwich | |
| Hume 2017 | [Hume etal J of App Eco, 2017](https://doi.org/10.1111/1365-2664.12942) | [data](http://datadryad.org/resource/doi:10.5061/dryad.dd602) | Forest harvest meta-analysis of 808 observations from 49 studies to test the effects of harvesting on the stocks and concentrations of soil C, N, and P and C:N:P ratios relative to uncut control stands | @SJTumber | |
| Ingrisch 2010 |  [Isgrisch etal, Sci of Tot Enviro 2014](https://doi.org/10.1016/j.scitotenv.2014.10.082)  | [Ingrisch, Johannes; Biermann, Tobias; Seeber, Elke; Leipold, Thomas; Li, Maoshan; Ma, Yaoming; Xu, Xingliang; Miehe, Georg; Guggenberger, Georg; Foken, Thomas; Kuzyakov, Yakov (2014): Carbon pools and fluxes measured during a field campaign conducted in 2010 on the Tibetan Plateau at Kema. PANGAEA](https://doi.org/10.1594/PANGAEA.833208)| Tibetan plateau C stocks study | @marzipanwich| |
| Cong 2014 | Cong W, van Ruijven J, Mommer L, De Deyn G, Berendse F, Hoffland E (2014) Plant species richness promotes soil carbon and nitrogen stocks in grasslands without legumes. Journal of Ecology 102(5): 1163-1170. https://doi.org/10.1111/1365-2745.12280 | http://datadryad.org/resource/doi:10.5061/dryad.p83h7 | Plant species richness promotes soil carbon and nitrogen stocks in grasslands without legumes. Data were collected in the 11-year grassland biodiversity experiment in Wageningen, the Netherlands, in 2010 and 2011. |  @SJTumber | |
| LUCAS Soil 2009-2018 | | doi: 10.1111/ejss.12499 | The ‘Land Use/Cover Area frame statistical Survey Soil’ (LUCAS Soil) is an extensive and regular topsoil survey that is carried out across the European Union to derive policy-relevant statistics on the effect of land management on soil characteristics. Approximately 45 000 soil samples have been collected from two time-periods, 2009–2012 and 2015.  | @ktoddbrown  | |
| Shaw 2018 | Shaw, C., Hilger, A., Filiatrault, M. and Kurz, W. (), A Canadian upland forest soil profile and carbon stocks database. Ecology. Accepted Author Manuscript. doi.org/10.1002/ecy.2159 | http://onlinelibrary.wiley.com/store/10.1002/ecy.2159/asset/supinfo/ecy2159-sup-0001-DataS1.zip?v=1&s=f95f40084248b880723282404305327c0aa95aeb http://onlinelibrary.wiley.com/store/10.1002/ecy.2159/asset/supinfo/ecy2159-sup-0002-MetadataS1.pdf?v=1&s=1b267bc2e7bbafc52b12a9e522033fa590445713 | 3,253 pedons of Canadian upland forest soil profile and carbon stocks | Cindy Shaw ||

# Active data

coders: list the coders who are active on this data
status: discribe where the data is in the data harmonization queue
    + keyed - data headers have been mapped to internal variables and relationship tables
    + scripted - data has a scripted ingestion

|             | DOI or url |  download link | description | id and coders | status |
| -------- | ----------- | -----------------| ------------- | -------- | ------- |
| Treat 2015 | ISCN 4 queue | [link](http://iscn.fluxdata.org/wp-content/uploads/sites/15/ISCNtemplate_Treat_peatProps_v2.xlsx) | Peat properties synthesis dataset (2MB, XLSX format, download only; ISCNtemplate_Treat_peatProps_v2): This dataset is a synthesis of literature and site-level data on peat properties, C, N, 14C, and vegetation from 366 sites worldwide. Data are available for nearly 16,000 layers from 659 profiles. Data contributed by Claire Treat. | @ktoddbrown | keyed |
| Moore 2015 | Moore JAM, Jiang J, Patterson CM, Mayes MA, Wang G, Classen AT (2015) Interactions among roots, mycorrhizae and free-living microbial communities differentially impact soil carbon processes. Journal of Ecology 103(6): 1442-1453. https://doi.org/10.1111/1365-2745.12484 | https://doi.org/10.5061/dryad.pb271 | Soil respiration, soil carbon pools, and enzyme activities. | @SJTumber, @ktoddbrown | keyed |
| ISCN3 | 10.17040/ISCN/1305039 | data: ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C2_1-1.xlsx ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C3_1-1.xlsx ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx citations -- ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL-DATA-CITATION_1-1.xlsx contributing -- ftp://ftp.fluxdata.org/.deba/ISCN/ALL-DATA/ISCN_ALL_DATA_DATASET_1-1.xlsx | Collection of soil survey data from around the world | @ktoddbrown | scripted |

