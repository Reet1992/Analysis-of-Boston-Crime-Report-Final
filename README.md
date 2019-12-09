# Analysis-of-Boston-Crime-Report-Final


## Social Covariates of Larceny

An XGBoost model with is fitted to predict Larceny from crime report data, as well as census data, using a Binary:Logistic objective and a tree-based booster. Both models are trained on a random sample of 50,000 observations.

To examine Larceny with the original Boston Crime DataSet, see code/Larceny_Boston_XGBoost.R  

To run the analogous model on the Census Dataset, see code/Larceny_Census_XGBoost.R  

Notes on the construction of the dataset used for census analyses are provided below. 

## Merging Census Data

In order to merge Census Data with the Boston Crime data, the longitude and latitude columns from the crime reports are used for requests to the Census API for corresponding tract codes. Note that even when coordinate data is rounded up to the 3rd decimal place (i.e., fewer coordinates are requested)  this first step is a time consuming process and will likely take multiple hours to fully run.

To make census requests using crime locations, see Crime_Geocode.pynb

Using the Crime_Location_Data.txt document produced by the above python script, the Get_Census_Survey_Data.R scipt may be used to collect response data from the 2015 ACS survey for the Census Tracts in Crime_Location_Data.txt, producing a csv titled Boston_Census_4_Join.csv.

After this is done, the Census_Data_Merge.R script merges the Original Dataset, Boston_Crime_Data.csv, with Boston_Census_4_Join.csv to produce the final merged document of the two datasets, which is titled Merged_Census_Crime_Data.csv. 


## Primary investigation 

In order to deploy the primary investigation, run the boston.R which will make the label ("level_of_violation") and will make several ggplots which shows the crime Trend of Friday Data and Decision Rule Segregation of WeekDays and WeekEnds Crime Rule. The Decision Rule will clearly able to tell that the strong violated crime infected Day which is Friday Belongs to the Weekdays Decision Rule which has a different Probability from the Weekends crime Rule.

## Prediction Model on python

User needs to run the crime_prediction.ipynb which will tell about the prediction model (decision Tree) and later it will show the feature clustering through support vetor machine classifier with both linear and rbf kernel.


### References

[1] Boston DataSet From Kaggle : https://www.kaggle.com/AnalyzeBoston/crimes-in-boston#crime.csv

[2] Decision Tree Classifier : http://benalexkeen.com/decision-tree-classifier-in-python-using-scikit-learn/

[3] Python Data Science Handbook: http://shop.oreilly.com/product/0636920034919.do

[4] MIT Open Course ware support Vector Machines : https://www.youtube.com/watch?v=_PwhiWxHK8o



