#### Get Columnn Labels for Dataset
Census_Data <- read.csv('./DataSet/Census_Data/Boston_Census_4_Join.csv')

#Get Tract No. from Census Code
Census_Data <- Census_Data[, -c(1:3)]
Census_Data$Tract <- as.integer(Census_Data$Tract)
rownames(Census_Data) = NULL


### Join coordinates to Census Data
tract_and_coord <- read.csv('/Users/Alex/Library/Mobile Documents/com~apple~CloudDocs/School/Fall 19/CPSC 6300 Applied Data Science/Project/crimes-in-boston/Tracts and Coordinates FOR MERGE.csv')
tract_and_coord <- tract_and_coord[,-1]
colnames(tract_and_coord)[1] = 'Tract'
Census_Data = full_join(Census_Data, tract_and_coord, by = 'Tract')
dim(tract_and_coord)

### Join Census Data to Boston Data
#Prep Boston Dat
bdat = read.csv('./DataSet/Boston_Crime_Data/Boston_Crime_Data.csv', header = T)



bdat$Long <- round(bdat$Long, 3)
bdat$Lat <- round(bdat$Lat, 3)

bdat <- bdat[which(!is.na(bdat$Lat)),]
bdat <- bdat[which(bdat$Lat != -1),]
dim(bdat)
#Crime Reports from Long Island, MA (not in census!)
bdat <- bdat[which((bdat$Long %in% Census_Data$Longitude)),]

sum((bdat$Long %in% Census_Data$Longitude) & (bdat$Lat %in% Census_Data$Latitude))


colnames(Census_Data)[which(colnames(Census_Data) == 'Longitude')] = 'Long'
colnames(Census_Data)[which(colnames(Census_Data) == 'Latitude')] = 'Lat'

bdat$Location = paste0('(',bdat$Lat, ',', bdat$Long, ')')
Census_Data$Location = paste0('(',Census_Data$Lat, ',', Census_Data$Long, ')')



sum(!(bdat$Location %in% Census_Data$Location))

bdat[which(!(bdat$Location %in% Census_Data$Location)),]
#THERE ARE 215 UCRs that could not be mactched... 

bdat <- bdat[which((bdat$Location %in% Census_Data$Location)),]
rownames(bdat) = NULL
rownames(Census_Data) = NULL
bdat = bdat[,-c(15,16)]
#^ removing longitude and latitude columns from bdat bc they will be duplicates after merge.

Crime_and_Census = inner_join(Census_Data, bdat, by = 'Location')
details <- lapply(Crime_and_Census, data.class)
#object.size(Crime_and_Census)



write.csv(Crime_and_Census, './Dataset/Census_Data/Merged_Census_Crime_Data.csv')



