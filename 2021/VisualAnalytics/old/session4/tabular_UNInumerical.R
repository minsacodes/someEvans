## Course: VISUAL ANALYTICS FOR POLICY AND MANAGEMENT
### Prof. José Manuel Magallanes, PhD 
# Session 4: Tabular data: Univariate Numerical
    
# ----getData, --------------------------------------------------
link='https://github.com/EvansDataScience/VisualAnalytics_2_tabularData/raw/master/data/eduwa.rda'

#getting the data TABLE from the file in the cloud:
load(file=url(link))


# ----unique, ---------------------------------------------------
# how many unique values
length(unique(eduwa$Reduced.Lunch))


# ---------------------------------------------------------------
# barplot without ggplot
library(questionr)
NumDf=freq(eduwa$Reduced.Lunch) 

NumDf=data.frame(variable=as.numeric(row.names(NumDf)),
                 NumDf,
                 row.names = NULL)


# ---------------------------------------------------------------
#resultado
head(NumDf)




# ----BAD_barplot, ----------------------------------------------
library(ggplot2)
base = ggplot(data=NumDf,aes(x=variable,y=n))
base + geom_bar(stat='identity')


# ----summary, --------------------------------------------------
summary(eduwa$Reduced.Lunch)


# ---------------------------------------------------------------
# standard deviation:
sd(eduwa$Reduced.Lunch,na.rm = T)


# ---------------------------------------------------------------
# median absolute deviation:
mad(eduwa$Reduced.Lunch,na.rm = T)


# ---------------------------------------------------------------
# asymmetry
library(DescTools)
Skew(eduwa$Reduced.Lunch,na.rm = T,conf.level = 0.95, ci.type = "bca",R=3000)



# ---------------------------------------------------------------
# shape
#library(DescTools)
Kurt(eduwa$Reduced.Lunch,na.rm = T,conf.level = 0.95, ci.type = "bca",R=3000)


# ----GGLikeBase,,fig.height=7-----------------------------------
#ggplot
base= ggplot(eduwa,aes(x = Reduced.Lunch))  
h1= base + geom_histogram(binwidth = 20) 
h1


# ---------------------------------------------------------------
MEAN=summary(eduwa$Reduced.Lunch)[4]
h1+ geom_vline(xintercept = MEAN)


# ---------------------------------------------------------------
base= ggplot(eduwa,aes(y = Reduced.Lunch))  
b1= base + geom_boxplot() 
b1 +coord_flip()


# ---------------------------------------------------------------
# difference between q3 and q1:
theIQR=IQR(eduwa$Reduced.Lunch,na.rm = T)


# ---------------------------------------------------------------
(upperT=summary(eduwa$Reduced.Lunch)[[5]] + theIQR*1.5)


# ---------------------------------------------------------------
sum(eduwa$Reduced.Lunch>upperT,na.rm = T)

# ---------------------------------------------------------------
someValues=as.vector(summary(eduwa$Reduced.Lunch)[-c(4,6,7)])
theTicks = round(c(someValues,upperT),0)
b2 = b1 +coord_flip()
b3 = b2 + geom_hline(yintercept = upperT, 
                color='grey8',linetype="dotted", size=2) 
b3 + scale_y_continuous(breaks = theTicks)


# ----summaryMeans, ---------------------------------------------
summary(eduwa$Student.Teacher.Ratio)


# ----histMeasu,,fig.height=7------------------------------------
#ggplot
base= ggplot(eduwa,aes(x = Student.Teacher.Ratio))  
h1= base + geom_histogram(binwidth = 15) #changing width

h1


# ---------------------------------------------------------------
d1= base + stat_density(geom = "line")
d1


# ---------------------------------------------------------------
theMean=mean(eduwa$Student.Teacher.Ratio, na.rm = T)
theMedian=median(eduwa$Student.Teacher.Ratio, na.rm = T)

d1 + geom_vline(xintercept = theMedian,color='blue') +
     geom_vline(xintercept =theMean,color='red') 

# ---------------------------------------------------------------
d1 + geom_vline(aes(xintercept = theMedian,color='median')) +
     geom_vline(aes(xintercept =theMean,color='mean')) +
     scale_color_manual(name = "Central Measures",
                        values = c(median = "blue", mean = "red"),
                        breaks = c('median','mean'),
                       labels=c("MEDIAN", "HELLOmean"))


# ---------------------------------------------------------------

base= ggplot(eduwa,aes(y = Student.Teacher.Ratio))  
b1= base + geom_boxplot()

b1 + coord_flip()


# ---------------------------------------------------------------
# variable of interest
theVAR=eduwa$Student.Teacher.Ratio
# interquartile range
theIQR=IQR(theVAR,na.rm = T)

#thresholds
upperT=summary(theVAR)[[5]] + theIQR*1.5
lowerT=summary(theVAR)[[2]] - theIQR*1.5

# dataframes of subpopulations
belows=eduwa[which(theVAR < lowerT),]
normals=eduwa[which(theVAR >=lowerT & theVAR <= upperT),]
aboves=eduwa[which(theVAR > upperT),]


# ----histBott,,fig.height=7-------------------------------------
#ggplot
base= ggplot(belows,aes(x = Student.Teacher.Ratio))  
d1B= base + stat_density(geom = "line") + labs(title = 'belows')

base= ggplot(normals,aes(x = Student.Teacher.Ratio))  
d1N= base + stat_density(geom = "line") + labs(title = 'normals',
                                               y=NULL)

base= ggplot(aboves,aes(x = Student.Teacher.Ratio))  
d1A= base + stat_density(geom = "line") + labs(title = 'aboves',
                                               y=NULL)


# ---------------------------------------------------------------
library(ggpubr)
multid1_a = ggarrange(d1B,d1N,d1A,ncol = 3,nrow = 1)
multid1_a

# ---------------------------------------------------------------
multid1_b = ggarrange(d1B,d1N,d1A,ncol = 1,nrow = 3)

multid1AN = annotate_figure(multid1_b,
                            top = text_grob("Visualizing Tooth Growth",
                                            face = "bold", size = 14),
                            bottom = text_grob("Data source: EDUWA", 
                                               hjust = 1, x = 1,
                                               face = "italic", 
                                               size = 10),
                            left = "DENSITY for all",
                            right = "some text here???")

multid1AN

