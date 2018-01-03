## procesData_BES-LTER.R
#' Script to process soil dataset from BES-LTER site
#' Created by Sam Zipper during AGU 2017 Soil Hackathon
#' 
#' Data description: https://beslter.org/metacat_harvest_attribute_level_eml/html_metadata/bes_584.asp
#' Data: http://beslter.org/pub/soil/chemistry/RC_Summary_Data-AddressesReplacedWithNumbers.txt

require(ggplot2)
require(dplyr)

df.in <- read.csv("http://beslter.org/pub/soil/chemistry/RC_Summary_Data-AddressesReplacedWithNumbers.txt", stringsAsFactors=F)

# make site dataframe -----------------------------------------------------

df.site.temp <- unique(df.in[,c("Site", "LU_Current", "LU_Previous", "Yr_Built")])

# note: previous vegtype and year of conversion
# only available for non-forest sites
df.site <- data.frame(site_name = df.site.temp$Site,
                      vegtype = df.site.temp$LU_Current,
                      veg_note = paste0("Previous veg type: ", df.site.temp$LU_Previous, "; converted ", df.site.temp$Yr_Built))

# set lat/lon - note that site coordinates are not provided to preserve anonymity of landowners
# but all of them are within a 17 km^2 watershed with bounding box: 
# West	-77.314183; East	-76.012008; North	39.724847; South	38.708367
df.site$lat <- -76.6631
df.site$lon <- 39.21661
df.site$location_acc <- 17*(1000^2)

rm(df.site.temp)

# make metadata dataframe --------------------------------------------------

df.metadata <- data.frame(curator_personName="Jonathan Walsh",
                          curator_organization="Baltimore Ecosystem Study LTER",
                          curator_email="walshj@caryinstitute.org",
                          dataset_name="Physical, chemical and biological properties of forest and home lawn soils",
                          dataset_description = "One-meter soil cores were taken to evaluate soil texture, bulk density, carbon and nitrogen pools, microbial biomass carbon and nitrogen content, microbial respiration, potential net nitrogen mineralization, potential net nitrification and inorganic nitrogen pools in 32 residential home lawns that differed by previous land use and age, but had similar soil types. These were compared to soils from 8 forested reference sites.",
                          reference = "Raciti, S. R., P. M. Groffman, J. C. Jenkins, R. V. Pouyat, and T. J. Fahey. 2011a. Controls on nitrate production and availability in residential soils. Ecological Applications:In press. Raciti, S. R., P. M. Groffman, J. C. Jenkins, R. V. Pouyat, T. J. Fahey, M. L. Cadenasso, and S. T. A. Pickett. 2011b. Accumulation of carbon and nitrogen in residential soils with different land use histories. Ecosystems 14:287-297.",
                          acknowledgment = "The scientists the BES-LTER Program and the Cary Institute of Ecosystem Studies must receive adequate acknowledgement for the use of data. Please inform the BES Project Facilitator and use a statement such as the following to give credit on any document using the data: Data was supported by the Baltimore Ecosystem Study")

# make sample dataframe ---------------------------------------------------

df.sample <- data.frame(site_name = df.in$Site,
                        sample = df.in$REP.,
                        layer_top = 0,
                        layer_bottom = 10)

df.sample$layer_top[df.in$Depth=="0to10"] <- 0
df.sample$layer_bottom[df.in$Depth=="0to10"] <- 10

df.sample$layer_top[df.in$Depth=="10to30"] <- 10
df.sample$layer_bottom[df.in$Depth=="10to30"] <- 30

df.sample$layer_top[df.in$Depth=="30to70"] <- 30
df.sample$layer_bottom[df.in$Depth=="30to70"] <- 70

df.sample$layer_top[df.in$Depth=="70to100"] <- 70
df.sample$layer_bottom[df.in$Depth=="70to100"] <- 100

# bulk density
df.sample$bd_samp <- df.in$BD
df.sample$bd_method <- "Subsamples of homogenized soil from each depth interval were analyzed for soil dry weight and percent moisture (48 hrs at 105 oC). Bulk density (BD) was calculated as BD = (Total Dry Mass - Rock Mass) / (Total Volume - Rock Volume)."

# soil texture
df.sample$sand_tot_psa <- df.in$Sand_Perc
df.sample$silt_tot_psa <- df.in$Silt_Perc
df.sample$clay_tot_psa <- df.in$Clay_Perc

# carbon and nitrogen
df.sample$c_tot <- df.in$C_Perc
df.sample$n_tot <- df.in$N_Perc
df.sample$c_to_n <- df.in$C_N

# transform sample from wide to long format
df.sample.long <- reshape2::melt(df.sample, id=c("site_name", "sample", "layer_top", "layer_bottom", "bd_method"))
