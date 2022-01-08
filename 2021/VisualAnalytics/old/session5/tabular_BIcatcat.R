## ----collect
# collecting the data
link="https://github.com/EvansDataScience/data/raw/master/crime.RData"
load(file = url(link))


## ----names--
# seeing the variable names
names(crime)


## ----head---
# checking first rows
head(crime)


## ----str----
# checking data types
str(crime)#,width = 70,strict.width='cut')


## ---- 
# checking statistics
summary(crime)


## ---- 
# contingency table of counts
(PrecintDaytime=table(crime$Precinct,crime$Occurred.DayTime))


## ---- 
# computing marginal percent (per column) from contigency table
(PrecDayti_mgCol=prop.table(PrecintDaytime,
                            margin = 2))


## ---- 
#making a data frame from contingency table

PrecDaytiDF=as.data.frame(PrecintDaytime)
names(PrecDaytiDF)=c("precint","daytime","counts")

#adding marginal percents:
PrecDaytiDF$pctCol=as.data.frame(PrecDayti_mgCol)[,3]


## ---- 
# head of data frame representing contingency table and marginals
head(PrecDaytiDF)


## ---- 
# ggplot using data frame
# basic bar plot DODGED

library(ggplot2)
base1=ggplot(data=PrecDaytiDF, 
             aes(x=precint,y=counts,fill=daytime)) # VARS NEEDED

barDodge= base1 +  geom_bar(stat="identity",
                            position="dodge") # NOT a default

barDodge= barDodge + geom_text(position = position_dodge(width = 0.9),
                               angle=90,
                               hjust=1,
                               aes(label=counts)) # its own AES!
barDodge


## ---- 
# Stacked bar plot

barStacked = base1 + geom_bar(stat = "identity")  # stack is default
barStacked = barStacked + geom_text(size = 3,
                                    position = position_stack(vjust = 0.5),
                                    aes(label=counts))# its own AES!
barStacked


## ---- 
#stacked percent
# they show the marginal table above: "PrecDayti_mgCol"
library(scales) # notice in 'percent()" below"

base2=ggplot(data=PrecDaytiDF, 
             aes(fill=precint,y=counts,x=daytime)) # changes

barStackPct= base1 +  geom_bar(stat = "identity",
                       position="fill") # you need this

barStackPct= barStackPct + geom_text(size = 3,# check below:
                             position = position_fill(vjust = 0.5),
                             aes(label=percent(pctCol)))

barStackPct


## ----table--
# contingency table with many levels:

(CrimeDay=table(crime$crimecat,crime$Occurred.DayTime))


## ---- 
#making a data frame from contingency table

CrimeDayDF=as.data.frame(CrimeDay)
#renaming:
names(CrimeDayDF)=c("crime","daytime","counts")
#marginal
CrimeDay_mgCol=prop.table(CrimeDay,margin = 2)
#adding marginal
CrimeDayDF$pctCol=as.data.frame(CrimeDay_mgCol)[,3]

# result for ggplot:
head(CrimeDayDF)


## ----BADplot
# bad idea
base2=ggplot(data=CrimeDayDF,
             aes(x=crime,y=counts,fill=daytime))
base2 + geom_bar(stat = "identity") + 
        geom_text(size = 3, 
                  position = position_stack(vjust = 0.5),
                  aes(label=counts))


## ----plotTable_gg
# plotting a representation of contingency table:

library(ggplot2)                           
base3 = ggplot(CrimeDayDF, aes(x=daytime,y=crime)) 
# plot value as point, size by value of percent
tablePlot = base3 + geom_point(aes(size = pctCol*100)) 
# add value of Percent as label
tablePlot = tablePlot + geom_text(aes(label = percent(pctCol)),
                                    nudge_x = 0.2,
                                    size=3)
tablePlot


## ---- 
# improving previous plot

tablePlot = tablePlot + theme_minimal() # less ink
tablePlot = tablePlot + theme(legend.position="none") # no legend
tablePlot


## ----facet--
# as usual for barplot (less info than base1)
base4 = ggplot(CrimeDayDF, aes(x = crime, y = counts ) ) 

#the bars
bars  = base4 + geom_bar( stat = "identity" ) + theme_minimal()

# bar per day time with 'facet'
barsFa = bars + facet_grid(~ daytime) 

barsFa


## ---- 
# change the minimal theme

barsFa = barsFa + theme( axis.text.x = element_text(angle = 90,
                                                    hjust = 1,
                                                    size=3 ))
barsFa


## ----flip_facet
# similar to base4
base5  = ggplot(CrimeDayDF, aes(x = crime,  y = pctCol ) ) 
barsIO = base5 + geom_bar( stat = "identity" )
barsIO = barsIO + facet_grid( ~ daytime) 
barsIO = barsIO + coord_flip()

barsIO


## ----orderFacet
# introducing "reorder""

#crime ordered by pctcl
base5b  = ggplot(CrimeDayDF, 
                 aes(x = reorder(crime, pctCol), #here
                     y = pctCol ) ) 

barsIOb = base5b + geom_bar( stat = "identity" )
barsIOb = barsIOb + facet_grid( ~ daytime) 
barsIOb= barsIOb + coord_flip() 

# something extra:
barsIOb= barsIOb + theme(axis.text.y = element_text(size=4,angle = 45)) 

barsIOb


## ----heatDescending-------------------------------------------
# heatplot
base  = ggplot(CrimeDayDF, aes(x = daytime, 
                               y = reorder(crime, pctCol), 
                               fill = pctCol*100)) 
heat = base +  geom_tile()

# coloring intensity
heat = heat +scale_fill_gradient(low = "white", 
                                   high = "black")
heat


## ---- 
# improving heat plot

heat = heat + theme_classic() 
heat = heat + labs(y="Crime")
heat = heat + theme(axis.text.x = element_text(angle = 90, 
                                               vjust = 0.6), 
                      legend.title = element_blank(), #no leg. title 
                      legend.position="top", 
                      legend.direction="horizontal",
                      legend.key.width=unit(1, "cm"),
                      legend.key.height=unit(1, "cm")) 

heat

