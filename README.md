# soils-long-tail-recovery
Recover the long tail of soils related data

Table structure:
1) Vocabulary (measurement) table has measurement [measurement_ID, measurement_type, measurement_method]
2) Field site has [field ID, time (collection date), depth.min, depth.max, depth.unit, latitude, longitude, description]
3) Field treatment has [field treatment ID, type, quantiy, units, method]
4) Lab has [lab ID, individualName.givenName, individualName.surName, positionName, electronicMailAddress, onlineUrl, ORCID, organizationName] (labs are made up of organizations and personel)
5) Lab treatment has [lab treatment ID, type, quanity, units, method]
6) Sample has [sample ID, field ID, field treatment ID, lab ID, lab treatment ID, DOI, time, time unit, mesurement type, measurment value, measurement unit]
7) Study table [DOI, type, info] (lead author ORCID, PI name, support staff name, manuscript)