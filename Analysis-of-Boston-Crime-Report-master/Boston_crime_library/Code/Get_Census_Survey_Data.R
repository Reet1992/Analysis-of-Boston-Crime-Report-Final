
CENSUS_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
# ^ Note: To run this script, you will need to request a Census API token!
#install.packages('censusapi')
library(censusapi)

api_list = censusapi::listCensusApis()


get_vars <- listCensusMetadata(name = 'acs/acs5', vintage = 2015, 'v')
dim(get_vars)

write.csv(get_vars, 'DataSet/Census_Data/Census_Variables.csv')
get_geo <- listCensusMetadata(name = 'acs/acs5', vintage = 2017, 'g')
listCensusMetadata()
dim(get_geo)
View(get_geo)

str(get_geo)
get_geo = as.data.frame(get_geo)
get_geo$wildcard[c(1:18,21:23)] = "NULL"
get_geo$wildcard = unlist(get_geo$wildcard)

get_geo$requires[c(1:4,9:10,13:15,18)] = 'NULL'
get_geo$requires[[24]] = 'NULL'
requirecol = unlist(get_geo$requires)
get_geo$requires = requirecol[1:23]

#write.csv(get_geo, '/Users/Alex/Library/Mobile Documents/com~apple~CloudDocs/School/Fall 19/Applied Data Science/Project/crimes-in-boston/Census_Geo.csv')

  Median_Income_past_12months_Total <- 'B06011_001E'
  
  Race_Overall <- 'B02001_001E'
  Race_Wht <- 'B02001_002E'
  Race_Blk <- 'B02001_003E'
  Race_Lat <- 'B03002_001E'
  Race_Asn <- 'B02001_005E'
  Race_Am_Indn <- 'B02001_004E'
  Race_Isl <- 'B02001_006E'
  Race_Other <- 'B02001_007E'
  Race_Two <- 'B02001_008E'

  
  Lat_Orgn<- 'B03003_001E'
  NonLat_Orgn <- 'B03003_002E'
  
  Income_Wht <- 'B19001A_001E'
  Income_Blk <- 'B19001B_001E'
  Income_NonLat <- 'B19001H_001E'
  Income_Lat <- 'B19001I_001E'
  Income_Natv <- 'B19001C_001E'
  Income_Asn <- 'B19001D_001E'
  Income_Isl <- 'B19001E_001E'
  Income_Other <- 'B19001F_001E'
  Income_TwoRaces <- 'B19001G_001E'

Income_Under10k <- 'B25121_093E'
Income_10k <- 'B25121_094E'  
Income_20k <- 'B25121_095E'  
Income_30k <- 'B25121_096E'
Income_40k <- 'B25121_097E'
Income_50k <- 'B25121_098E'
Income_60k <- 'B25121_099E'
Income_70k <- 'B25121_100E'
Income_80k <- 'B25121_101E'
Income_90k <- 'B25121_102E'
Income_100_199k <- 'B25121_103E'
Income_200_249k <- 'B25121_104E'
Income_250_499k <- 'B25121_105E'
Income_500k_up <- 'B25121_105E'
Income_Imputed <- 'B99191_008E'


#Edu_Wht <- 'B15002A_001E'
Edu_Blk <- 'B15002B_001E'
Edu_NonLat <- 'B15002H_001E'
Edu_Lat <- 'B15002I_001E'
Edu_Natv <- 'B15002C_001E'
Edu_Asn <- 'B15002D_001E'
Edu_Isl <- 'B15002E_001E'
Edu_Other <- 'B15002F_001E'
Edu_TwoRace <- 'B15002G_001E'

Nativity_Ctzn <- 'C05001_001E'
Vacancy_Status <- 'B25004_001E'

Worker_Class <- 'B99243_002E'
  Occupation_16_up <- 'B99242_002E'
  Educational_Attainment_25yrs_up <- 'B99151_002E'
Employment_Status <- 'B99231_002E'
  Poverty_Status_Past12 <- 'B99172_014E'
  Food_Stamps <- 'B99221_002E'
  Ctzn_Status <- 'B99051_006E'
  
  Total_Housing_Units <- 'B25001_001E'
Gini_Income_Ineq <- 'B19083_001E'
  
  
  

survey_vars =  c('B06011_001E',
                 #'B02001_001E',
                 'B02001_002E',
                 'B02001_003E',
                 'B03002_001E',
                 'B02001_005E',
                 'B02001_004E',
                 'B02001_006E',
                 'B02001_007E',
                 'B02001_008E',
                 'B03003_001E',
                 'B03003_002E',
                 'B19001A_001E',
                 'B19001B_001E',
                 'B19001H_001E',
                 'B19001I_001E',
                 'B19001C_001E',
                 'B19001D_001E',
                 'B19001E_001E',
                 'B19001F_001E',
                 'B19001G_001E',
                 'B25121_093E',
                 'B25121_094E', 
                 'B25121_095E',  
                 'B25121_096E',
                 'B25121_097E',
                 'B25121_098E',
                 'B25121_099E',
                 'B25121_100E',
                 'B25121_101E',
                 'B25121_102E',
                 'B25121_103E',
                 'B25121_104E',
                 'B25121_105E',
                 'B25121_105E',
                 'B99191_008E',
                # 'B15002A_001E',
                # 'B15002B_001E',
                # 'B15002H_001E',
                # 'B15002I_001E',
                # 'B15002C_001E',
                # 'B15002D_001E',
                # 'B15002E_001E',
                # 'B15002F_001E',
                # 'B15002G_001E',
                # 'C05001_001E',
                 'B25004_001E',
                 #'B99243_002E',
                 'B99242_002E',
                 'B99151_002E',
                 'B99231_002E',
                 'B99172_014E',
                 'B99221_002E',
                 # 'B99051_006E',
                 'B25001_001E',
                 'B19083_001E')

census_cols <- c('State', 'County', 'Tract',
  'Median_Income_past_12months_Total',
 # 'Race_Overall',
  'Race_Wht',
  'Race_Blk',
  'Race_Lat',
  'Race_Asn',
  'Race_Am_Indn',
  'Race_Isl',
  'Race_Other',
  'Race_Two',
  'Lat_Orgn',
  'NonLat_Orgn',
  'Income_Wht',
  'Income_Blk',
  'Income_NonLat',
  'Income_Lat',
  'Income_Natv',
  'Income_Asn',
  'Income_Isl',
  'Income_Other',
  'Income_TwoRaces',
  'Income_Under10k',
  'Income_10k' ,
  'Income_20k',
  'Income_30k',
  'Income_40k' ,
  'Income_50k' ,
  'Income_60k' ,
  'Income_70k' ,
  'Income_80k' ,
  'Income_90k' ,
  'Income_100_199k',
  'Income_200_249k',
  'Income_250_499k',
  'Income_500k_up',
  'Income_Imputed',
#  'Edu_Wht',
 # 'Edu_Blk',
 # 'Edu_NonLat',
#  'Edu_Lat',
#  'Edu_Natv',
#  'Edu_Asn',
#  'Edu_Isl',
#  'Edu_Other',
#  'Edu_TwoRace',
#  'Nativity_Ctzn',
  'Vacancy_Status',
#  'Worker_Class',
  'Occupation_16_up',
  'Educational_Attainment_25yrs_up',
  'Employment_Status' ,
  'Poverty_Status_Past12',
  'Food_Stamps',
#  'Ctzn_Status',
  'Total_Housing_Units',
  'Gini_Income_Ineq')

  census_data <- getCensus(name="acs/acs5",
                         vintage=2015,
                         key=CENSUS_KEY,
                         vars= survey_vars,
                        region = "tract:*",
                         regionin="state:25")


colnames(census_data) <- census_cols
  


tracts <- jsonlite::fromJSON('./DataSet/Census_Data/Crime_Location_Data.txt')
filtered_census <- census_data[which(census_data$Tract %in% tracts),]
# ^ Filter out tracts that are not in the Boston Area (or rather just our dataset...)

write.csv(filtered_census, './DataSet/Census_Data/Boston_Census_4_Join.csv')
  
CensusMetaData <- censusapi::listCensusMetadata('acs/acs5', vintage = 2017)
write.csv(CensusMetaData, './DataSet/Census_Data/Census_Metadata.csv')







