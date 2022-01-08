## ----collect, eval=TRUE--------------------------------------------------
# collecting the data
link="https://github.com/EvansDataScience/data/raw/master/crime.RData"
load(file = url(link))


## ----names, eval=TRUE----------------------------------------------------
# variables in the data:
names(crime)


## ------------------------------------------------------------------------
# some stats:
summary(crime)


## ----summaryTime, eval=TRUE----------------------------------------------
# stats of days to report
# notice the spread of values.
summary(crime$DaysToReport)


## ------------------------------------------------------------------------
# 'order' decreasing

library(magrittr) # for %>%
crime[order(-crime$DaysToReport),c('year','DaysToReport')]%>%head(20)


## ----aggregate, eval=TRUE------------------------------------------------
# non missing 'precint'
crime=crime[complete.cases(crime$Precinct),]

# summary: mean by groups
aggregate(data=crime, DaysToReport~Precinct,mean)


## ----boxNumCat1, eval=TRUE-----------------------------------------------
# boxplot of days to report per precint

library(ggplot2)
base=ggplot(data=crime,
            aes(x=Precinct,y=DaysToReport))

base + geom_boxplot()


## ----tapplySummary, eval=TRUE--------------------------------------------
# aggregate using "summary" function
# Distribution of days to report?

aggregate(data=crime,DaysToReport~Precinct,summary)


## ----weeksandabove, eval=TRUE--------------------------------------------
# several boxplots, from week and above

library(ggpubr)

base7=ggplot(data=crime[crime$DaysToReport>=7,],
            aes(x=Precinct,y=DaysToReport)) 
box7=base7 + geom_boxplot() + labs(title = "week and above")

base30=ggplot(data=crime[crime$DaysToReport>=30,],
            aes(x=Precinct,y=DaysToReport))
box30=base30 + geom_boxplot() + labs(title = "month and above")

base180=ggplot(data=crime[crime$DaysToReport>=180,],
            aes(x=Precinct,y=DaysToReport)) 
box180=base180 + geom_boxplot() + labs(title = "half year and above")


base365=ggplot(data=crime[crime$DaysToReport>=360,],
            aes(x=Precinct,y=DaysToReport)) 
box365=base365 + geom_boxplot() + labs(title = "year and above")



#all in one:
ggarrange(box7,box30,box180,box365)



## ----casesCountYear, eval=TRUE-------------------------------------------
# check crimes per year to filter again
table(crime$year)


## ----crimeAfter2000, eval=TRUE-------------------------------------------
# let's keep durantion longer than a year,
# and after 2000

# new filtered data frame
crimeY2000=crime[crime$year>=2000 & crime$DaysToReport>=365,]

#counting
table(crimeY2000$Precinct)


## ----boxpAfter2000, eval=TRUE--------------------------------------------
# box plot for new filtered data frame:

base=ggplot(data=crimeY2000,
            aes(x=Precinct,y=DaysToReport))
base + geom_boxplot() 


## ----convertYear, eval=TRUE----------------------------------------------
# create new variable in YEARS:
crimeY2000$YearsToReport=crimeY2000$DaysToReport/365

# new box plot, only vertical units change
base=ggplot(data=crimeY2000,
            aes(x=Precinct,y=YearsToReport))
base + geom_boxplot() 


## ----exploreBOX2, eval=TRUE----------------------------------------------

#boxplot by Year
base=ggplot(data = crimeY2000,
            aes(x=as.factor(year),
                y=YearsToReport))
boxByYear=base + geom_boxplot()

#boxplot by Crime
base=ggplot(data =crimeY2000,
            aes(x=reorder(crimecat,YearsToReport), # using reorder!
                y=YearsToReport))
boxByCrime=base + geom_boxplot() 
boxByCrime= boxByCrime + theme(axis.text.x = element_text(angle = 45,
                                                          hjust = 1,
                                                          size = 5))
# combining plots
ggarrange(boxByYear,boxByCrime,ncol = 1)



## ----boxBYE, eval=TRUE---------------------------------------------------
# plotting the MIN values:
base  = ggplot(crimeY2000,aes(x=factor(year), y=YearsToReport))
mins = base + stat_summary(fun.y=min, # function for 'y' is min()
                           geom="line",
                           size=2,
                           aes(group=1,col='Min'))
mins # just the min values



## ---- eval=TRUE----------------------------------------------------------
# plotting the MAX values on top:
minsMaxs= mins + stat_summary(fun.y=max,
                              geom="line",
                              size=2,
                              aes(group=1,col='Max'))

minsMaxs



## ---- eval=TRUE----------------------------------------------------------
# another layer with MEDIANS
minsMaxsMd= minsMaxs + stat_summary(fun.y=median,
                                    geom="line",
                                    size=2,
                                    aes(group=1,col='Median'))
minsMaxsMd


## ---- eval=TRUE----------------------------------------------------------
# Change color of lines:
all1=minsMaxsMd + scale_colour_manual(name="Stats",
                                      values=c("black", "grey50","grey90") #alphabetic
                                      )
all1 + theme_classic()


## ----crimeWeek, eval=TRUE------------------------------------------------
# data we did not use:

crimeLessYear2000=crime[(crime$DaysToReport<365) & (crime$year>=2000),]



## ----plotCrimeWeek, eval=TRUE--------------------------------------------
#plotting it as before:
base = ggplot(crimeLessYear2000,aes(x=factor(year), y=DaysToReport)) 
mins = base + stat_summary(fun.y=min,size=2,
                           geom="line", 
                           aes(group=1,col='Min'))
minsMaxs= mins + stat_summary(fun.y=max,
                              geom="line",size=2,
                              aes(group=1,col='Max'))
minsMaxsMd= minsMaxs + stat_summary(fun.y=median,
                                    geom="line",size=2,
                                    aes(group=1,col='Median'))
all2=minsMaxsMd + scale_colour_manual(name="Stats",
                                      values=c("black", "grey50","grey90") 
                                      )
all2 + theme_classic()


## ----anova, eval=TRUE----------------------------------------------------

#checking the mean per factor value.
#are crime in precints different on average?

aggregate(data=crimeY2000,YearsToReport~Precinct, mean)


## ----CI, eval=TRUE-------------------------------------------------------

#are crime in precints different on average?
library(Rmisc)

group.CI(YearsToReport ~ Precinct, 
         data=crimeY2000, 
         ci = 0.95)


## ----plotCI, eval=TRUE---------------------------------------------------
#are crime in precints different on average?

# introducing ggpubr
library(ggpubr)
ggline(data=crimeY2000,x = "Precinct", y = "YearsToReport",
       add = 'mean_ci') 


## ----testAnova, eval=TRUE------------------------------------------------
# Compute the analysis of variance
res.aov <- aov(YearsToReport ~ Precinct, data = crimeY2000)

# Summary of the analysis
summary(res.aov)

## ----Tukey, eval=TRUE----------------------------------------------------
# where are the differences detected in aov?
TukeyHSD(res.aov)

## ----TukeyFiltered, eval=TRUE--------------------------------------------
# where are the differences detected in aov?
# result into a data frame
ResPar=as.data.frame(TukeyHSD(res.aov)$Precinct)
ResPar[ResPar$`p adj`<0.05,]


## ----kruskal, eval=TRUE--------------------------------------------------
# non parametric
kruskal.test(YearsToReport ~ Precinct, data = crimeY2000)

## ----dunn, eval=TRUE-----------------------------------------------------
# where are the differences detected in Kruskal?
library(FSA)

dunnTest(YearsToReport ~ Precinct, data = crimeY2000)


## ----dunnFiltered, eval=TRUE---------------------------------------------
# where are the differences detected in Kruskal?
# result into a data frame
ResNonPar=dunnTest(YearsToReport ~ Precinct, data = crimeY2000)$res
ResNonPar[ResNonPar$P.adj<0.05,]

