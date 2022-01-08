## ----collecting, eval=TRUE-----------------------------------------------
link='https://github.com/UWDataScience2020/data/raw/master/hdidemocia.RDS'
# a RDS file from the web needs:
myFile=url(link)

# reading in data:
fromPy=readRDS(file = myFile)

# reset indexes to R format:
row.names(fromPy)=NULL


## ---- eval=TRUE----------------------------------------------------------
str(fromPy[,c(2,13,16)])


## ---- eval=TRUE----------------------------------------------------------
fromPy$co2_in_millionMT=fromPy$co2_in_MT/10^6


## ----clusSubset, eval=TRUE-----------------------------------------------
dfClus=fromPy[,c(2,13,17)]


## ----clusRename, eval=TRUE-----------------------------------------------
row.names(dfClus)=fromPy$Country
head(dfClus)


## ----clusSeed, eval=TRUE-------------------------------------------------
set.seed(999) # this is for replicability of results


## ----clusDistance, eval=TRUE---------------------------------------------
library(cluster)
dfClus_D=cluster::daisy(x=dfClus,metric="gower")


## ----clusPam, eval=TRUE--------------------------------------------------
NumCluster=4
res.pam = pam(x=dfClus_D,k = NumCluster,cluster.only = F)


## ----cluspamSave, eval=TRUE----------------------------------------------
fromPy$pam=as.factor(res.pam$clustering)


## ----cluspamquery1, eval=TRUE--------------------------------------------
fromPy[fromPy$pam==1,'Country']


## ----cluspamquery2, eval=TRUE--------------------------------------------
fromPy[fromPy$Country=="Peru",'pam']


## ----cluspamREPORTtable, eval=TRUE---------------------------------------
table(fromPy$pam)


## ----cluspamREPORT_silave, eval=TRUE-------------------------------------
library(factoextra)
fviz_silhouette(res.pam)


## ----cluspamREPORT_datasil, eval=TRUE------------------------------------
pamEval=data.frame(res.pam$silinfo$widths)
head(pamEval)


## ----cluspamREPORT_silnegative, eval=TRUE--------------------------------
pamEval[pamEval$sil_width<0,]


## ----clusagn, eval=TRUE--------------------------------------------------
library(factoextra)

res.agnes= hcut(dfClus_D, k = NumCluster,isdiss=T,
                 hc_func='agnes',
                 hc_method = "ward.D2")


## ----clusagnSave, eval=TRUE----------------------------------------------
fromPy$agn=as.factor(res.agnes$cluster)


## ----clusagnQuery1, eval=TRUE--------------------------------------------
fromPy[fromPy$agn==1,'Country']


## ----clusagnQuery2, eval=TRUE--------------------------------------------
fromPy[fromPy$Country=="Peru",'agn']


## ----clusagnREPORTtable, eval=TRUE---------------------------------------
table(fromPy$agn)


## ----clusagnREPORTdendo, eval=TRUE---------------------------------------
fviz_dend(res.agnes,k=NumCluster, cex = 0.7, horiz = T)


## ----clusagnREPORTsilave, eval=TRUE--------------------------------------
library(factoextra)
fviz_silhouette(res.agnes)


## ----clusagnREPORTsildata, eval=TRUE-------------------------------------
agnEval=data.frame(res.agnes$silinfo$widths)
head(agnEval)


## ----clusagnREPORTsilnega, eval=TRUE-------------------------------------
agnEval[agnEval$sil_width<0,]


## ----clusdia, eval=TRUE--------------------------------------------------
library(factoextra)

res.diana= hcut(dfClus_D, k = NumCluster,
                 hc_func='diana',
                 hc_method = "ward.D")


## ----clusdiaSave, eval=TRUE----------------------------------------------
fromPy$dia=as.factor(res.diana$cluster)


## ----clusdiaQuery1, eval=TRUE--------------------------------------------
fromPy[fromPy$dia==1,'Country']


## ----clusdiaQuery2, eval=TRUE--------------------------------------------
fromPy[fromPy$Country=="Peru",'dia']


## ----clusdiaREPORTtable, eval=TRUE---------------------------------------
table(fromPy$dia)


## ----clusdiaREPORTdendo, eval=TRUE---------------------------------------
fviz_dend(res.diana,k=NumCluster, cex = 0.7, horiz = T)


## ----clusdiaREPORTavesil, eval=TRUE--------------------------------------
library(factoextra)
fviz_silhouette(res.diana)


## ----clusdiaREPORTdata, eval=TRUE----------------------------------------
diaEval=data.frame(res.diana$silinfo$widths)
head(diaEval)


## ----clusdiaREPORTsilnega, eval=TRUE-------------------------------------
diaEval[diaEval$sil_width<0,]


## ----clusdbKNN, eval=TRUE------------------------------------------------
library(dbscan)
#minNeighs> num cols in data
minNeighs=4
kNNdistplot(dfClus_D, k = minNeighs)
abline(h=.03, col = "red", lty=2)


## ----clusdb, eval=TRUE---------------------------------------------------
distance=0.03
res.db = dbscan::dbscan(dfClus_D, eps=distance, 
                     minPts=minNeighs)


## ----clusdbREPORT, eval=TRUE---------------------------------------------
# '0' identifies outliers: 
res.db


## ----clusdbSave, eval=TRUE-----------------------------------------------
fromPy$db=as.factor(res.db$cluster)


## ----cmdMap, eval=TRUE---------------------------------------------------
projectedData = cmdscale(dfClus_D, k=2)
#
# save coordinates to original data frame:
fromPy$dim1 = projectedData[,1]
fromPy$dim2 = projectedData[,2]


## ----plotCmdmap, eval=TRUE-----------------------------------------------
base= ggplot(data=fromPy,
             aes(x=dim1, y=dim2,
                 label=Country)) 
base + geom_text(size=2)


## ----plotpam, eval=TRUE--------------------------------------------------
pamPlot=base + labs(title = "PAM") + geom_point(size=2,
                                              aes(color=pam),
                                              show.legend = F)  


## ----plotagn, eval=TRUE--------------------------------------------------
agnPlot=base + labs(title = "AGNES") + geom_point(size=2,
                                              aes(color=agn),
                                              show.legend = F) 


## ----plotdia, eval=TRUE--------------------------------------------------
diaPlot=base + labs(title = "DIANA") + geom_point(size=2,
                                              aes(color=dia),
                                              show.legend = F) 


## ----plotcompare, eval=TRUE----------------------------------------------
library(ggpubr)
ggarrange(pamPlot, agnPlot, diaPlot,ncol = 3)


## ----plotdb, eval=TRUE---------------------------------------------------
dbPlot= base + labs(title = "DBSCAN") + geom_point(aes(color=db),
                                               show.legend = T) 
dbPlot


## ----plotdb_annot1, eval=TRUE--------------------------------------------
library(ggrepel)
dbPlot + geom_text_repel(size=3,aes(label=Country))


## ----plotdb_annot2, eval=TRUE--------------------------------------------
LABEL=ifelse(fromPy$db==0,fromPy$Country,"")

dbPlot + geom_text_repel(aes(label=LABEL))

