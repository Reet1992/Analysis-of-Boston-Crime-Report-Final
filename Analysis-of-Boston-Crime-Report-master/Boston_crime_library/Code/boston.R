setwd("C:/Users/Ted/Desktop/6300")

data <- read.csv("crime.csv")

data2 <- data
head(data2)


View(dat)

offense_table <- table(data$OFFENSE_CODE_GROUP)
offense_table <- data.frame(offense_table)

library(plyr)
offense_table_order <- arrange(offense_table,desc(Freq))

library(ggplot2)

ggplot(data2, aes(x=data2$YEAR, fill = factor(data2$MONTH)))+
  geom_bar(width = 0.5)+
  xlab("year")+
  ylab("Totalcountof month")

##Identified the strong ,medium and low violation crime filtering them into a data range

sv = offense_table_order %>% filter(a>10000)
sv <- mutate(sv,violation_level = 'strong')

mv = offense_table_order %>% filter(2000<a & a<10000)
mv <- mutate(mv,violation_level = 'medium')

lv = offense_table_order %>% filter(500<a & a<2000)
lv <- mutate(lv,violation_level = 'low')

nv = offense_table_order %>% filter(a<500)
nv <- mutate(nv,violation_level = 'noviolation')

group_crime <- rbind(sv,mv,lv,nv)
offense_table_sorted <- merge.data.frame(group_crime,offense_table)



####make the tally column########


data2$tally = rep(1, times = nrow(data2))
data2$tally = rep(NA, times = 100)
for(i in 1:length(table(data2$OFFENSE_CODE_GROUP)))
{
  
  
  dat = data2 %>%
    filter(OFFENSE_CODE_GROUP == unique(data2$OFFENSE_CODE_GROUP)[i])
  
  dat = dat %>%
    mutate(tally = offense_table_sorted[which(offense_table_sorted$Var1 == unique(data2$OFFENSE_CODE_GROUP)[i]), 3]) 
  
  data2[which(data2$OFFENSE_CODE_GROUP == unique(data2$OFFENSE_CODE_GROUP)[i]),]$tally = as.character(dat$tally)
  
  
  
}


sum(dat$tally) #Insert any factor level, and sum to view total frequency

##### find the frequncy of violation VS levelof violation in the Boston

#1:length(levels(data2$OFFENSE_CODE_GROUP))
#length(table(data2$OFFENSE_CODE_GROUP))

# dim(data)
 #dim(data2)
 # data = data2 %>%
 #   filter(data$OFFENSE_CODE_GROUP == "Larceny")
ggplot(offense_table_sorted, aes(x=offense_table_sorted$violation_level, fill = factor(offense_table_sorted$Freq)))+
       geom_bar(width = 0.5)+
       xlab("level of violation in Boston")+
       ylab("frequency of violation")

write.csv(offense_table_sorted,'C:/Users/Ted/Desktop/6300/offense_table_sorted')


#######Analysis after getting the levelof violation column("tally)########

ggplot(data2, aes(x=data2$DAY_OF_WEEK, fill = factor(data2$tally)))+
              geom_boxplot(aes(data2$DAY_OF_WEEK,data2$tally))+
              xlab("Days In a week")+
              ylab("Violation level")

ggplot(data2, aes(x=data2$DAY_OF_WEEK, fill = factor(data2$tally)))+
  geom_bar(width=0.5)+
  xlab("Days In a week")+
  ylab("Violation level")

data2_copy <- data2
write.csv(data2_copy,'C:/Users/Ted/Desktop/6300/updated_data_with_vl.csv')



########FIND THE MOST OCCURENCE DAY OF CRIME AND THE TYPE OF CRIME OCURRED #############



ggplot(data2, aes(x = data2$DAY_OF_WEEK, color = data2$tally)) + geom_density() +
  facet_grid(data2$YEAR)

#####The above code tells us most of the ocurrence happened in friday#####

#####Below code put friday data only into a different data frame#####

friday_data <- filter(data2_copy,data2_copy$DAY_OF_WEEK == 'Friday')

Friday_data_crime_group <- table(friday_data$OFFENSE_CODE_GROUP)
Friday_data_crime_group <- data.frame(Friday_data_crime_group)
write.csv(Friday_data_crime_group,'C:/Users/Ted/Desktop/6300/Friday_data_crime_group.csv')
write.csv(friday_data,'C:/Users/Ted/Desktop/6300/Friday_data.csv')

library(plyr)
Friday_data_crime_group_order <- arrange(Friday_data_crime_group,desc(Freq))
##this tells that the most crime occurred on friday is motor vehicle accident response#

#######################################################################################

ggplot(data2, aes(x = data2$HOUR, color = data2$tally)) + geom_density() +
  facet_grid(data2$YEAR)

ggplot(friday_data, aes(x = friday_data$HOUR, color = friday_data$tally)) + geom_density() +
      facet_grid(friday_data$YEAR)

########weekly and Friday########most occurence hourly crime timeline





######form a Decision Tree Predictor Model###########


set.seed(1234)


#partition data into test and validate

pd <- sample(2,nrow(data2_copy),replace = TRUE,prob = c(0.85,0.15))
train2 <- data2_copy[pd==1,]
validate2 <- data2_copy[pd==2,]

library(partykit)

####Building the tree#######

tree <- ctree(tally~DAY_OF_WEEK+HOUR,data = train2, control = ctree_control(mincriterion = 0.999,minsplit = 50000))
tree
plot(tree) 

#####make the prediction of the tree with the test/validate data######

predict(tree,validate2,type = "prob")

#####Create the confusion matrix#######

tab <- table(predict(tree),train2$tally)

print(tab)

1-sum(diag(tab))/sum(tab)



######Decision Tree with rpart#######

library(rpart)
tree2 <- rpart(OFFENSE_CODE_GROUP~DAY_OF_WEEK+HOUR,train2)
library(rpart.plot)
rpart.plot(tree2)

plot(tree2)


