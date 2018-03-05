Description of files:

+  EmptyKey.csv
    - a template with the ISCN3 standard variables in it and their mapped data tables
+ ISCNtemplate_2016Key.csv
    - a template with a partial key for the ISCN4 data ingestion from the ISCN template
+ PowellCenterV4Key.csv
    - a template for the Powell Center working group template for soil fraction data
+ ISCNKey.xlsx
    - a template for the ISCN3 data set ingestion
    - Decrepid and should not be used for anything other then historical reference.

Below is a discription of the headers expected in the key. 
Extra columns are allowed but ignored by the general processing script.

+  header
    -  the exact header names in the data file
+  headerLong
    -  the long word-y explination of what is in this row/column
+  var
    -  Internal matched variable, if no internal variable is specified then the data is dropped
    -  ISCN variables are recommended (see EmptyKey.csv for ISCN3 variables) for downstream processing but not required
+  flagID
    -  flag one column as an identifying keys for the study, field, and treatment (optional) tables, this can be multiple columns but the column will be duplicated so try to keep the number of id's small
+  dataframe
    -  which table the data goes into: currently study, field, treatment, and sample are supported. The method table is constructed from sample information.
+  class
    -  what data type is in the column (factor, character or numeric are suggested)
+  softType
    -  for the sample table only, identify whether the data is a value, sigma (uncertantiy), method, or unit
    -  variables can not be assigned more then one value, sigma or unit but can be assigned more then one method, multiple methods will be concatonated in a way that preserves the orginal header name
+  hardValue, hardSigma, hardUnit, hardMethod
    -  for the sample table only, hard code information about the value, sigma, method or unit associated with this column
    -  For non-sample tables value will be used if header is not assigned. For example if the download URL is not specified in the data itself then it can be filled in here and assigned to the variable download_url.
