#!/usr/bin/env python
# coding: utf-8

# <center><img src="http://i.imgur.com/sSaOozN.png" width="500"></center>

# ## Course: Computational Thinking for Governance Analytics
# 
# ### Prof. José Manuel Magallanes, PhD 
# * Visiting Professor of Computational Policy at Evans School of Public Policy and Governance, and eScience Institute Senior Data Science Fellow, University of Washington.
# * Professor of Government and Political Methodology, Pontificia Universidad Católica del Perú. 
# 
# _____
# <a id='home'></a>
# 
# # Data Preprocessing in Python: Data gathering

# 1. [Uploading files](#part1a)
# 2. [APIs](#part2) 
# 3. [Scraping](#part3) 
# 4. [Social media](#part4) 

# ____
# <a id='part1a'></a>
# 
# ## Uploading 'proprietary software' files

# Several times, you may find that you are given a file that was previously prepared with proprietary software. The most common in the policy field are:
# 
# * SPSS (file extension: **sav**).
# * STATA (file extension: **dta**).
# * EXCEL (file extension: **xlsx** or **xls**).
# 
# Getting these files up and running is the easiest, as they are often well organized and do not bring much pre processing challenges. However, I need to have the file where I am currently writing my code:

# In[ ]:


import os
os.getcwd()


# For sure, you can leave the file anywhere you want in your machine; but you would need to know all the *path* to the file. To avoid that, it is better to store your data in the *cloud*. If you need the file in the same format, GitHub is great choice. For instance, I have a repository (aka *repo*) with several data files [here](https://github.com/EvansDataScience/data). I will upload the file *hsb_ok* into memory in the next examples. 
# 
# The files I will use look like a data table which are known as the **data frame**, like the ones you use in Excel. Python needs the help of external packages to read those data frames. **Pandas** is a great package that will make our life easier, so make sure it is installed:

# In[ ]:


get_ipython().system('pip show pandas')


# If you do not have *pandas*, please install it by writing **_!pip install pandas_** in a code cell. You can also install it in Anaconda Navigator or via the Terminal. Remember that you are writing an interactive document, so I recommend that you write a **_#_** before the codes you do not to be executed more than once.

# In[ ]:


#!pip install pandas   #I already have it!


# [home](#home)
# 
# ____
# 
# ## Reading a STATA file:
# 
# Let me open the **hsb_ok.dta** file:

# In[ ]:


import pandas as pd

location='https://github.com/EvansDataScience/data/raw/master/'
fileDTA=location+'hsb_ok.dta'
dataStata=pd.read_stata(fileDTA,convert_categoricals=True)


# The object **dataStata** has received a data frame, let's check the contents:

# In[ ]:


dataStata


# [home](#home)
# 
# ____
# 
# ## Reading an SPSS file

# Pandas [tells](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_spss.html) there is a function **read_spss**, so you may want to try this:

# In[ ]:


fileSPSS=location + "hsb_ok.sav"
dataSPSS= pd.read_spss(fileSPSS,convert_categoricals=True)


# You need here some extra help from the package **pyreadstat**. Please install it:

# In[ ]:


#!pip install pyreadstat


# Notice that **pyreadstat** cannot read from an url, so we need some some extra coding:

# In[ ]:


# to open link:
from urllib.request import urlopen
fileSPSS=location + "hsb_ok.sav"
response = urlopen(fileSPSS) 

# reading contents
content = response.read() 

# opening a file
fhandle = open('hsb_ok_fromGIT.sav', 'wb') 

# saving contents in that file
fhandle.write(content) 

# closing the file
fhandle.close() 


# If you see the folder where you are writing this code, you should find that the file from the url is now in your computer. Now just read it:

# In[ ]:


dataSPSS= pd.read_spss("savFromGit.sav",convert_categoricals=True)

# here it is
dataSPSS


# [home](#home)
# 
# _____
# 
# ## Reading an EXCEL file:
# 
# The steps to open an Excel file are very simple (you can read from a link):

# In[ ]:


# the location has not changed:
fileXLSX=location+'hsb_ok.xlsx'
dataExcel=pd.read_excel(fileXLSX) # new function


# If you get an error complaining you do not have the library **xlrd** (xls) or the library **openpyxl** (xlsx), just install both using **!pip install**. 

# When you have the data frame, you can see the variables:

# In[ ]:


dataExcel.columns # just to see the column names


# Notice that the contents look different; as you do not see the categories but numbers. In general, you should always read the metadata documentation of the files you are downloading. [Here](https://github.com/UWDataScience2020/data/blob/master/hsb_ok_metadata.pdf) is the metadata for the current file.

# Remember that an Excel file can have **several sheets**:

# In[ ]:


fileXLSXs=location+'WA_COVID19_Cases_Hospitalizations_Deaths.xlsx'
dataExcelCovidCases=pd.read_excel(fileXLSXs,sheet_name='Cases')
dataExcelCovidDeaths=pd.read_excel(fileXLSXs,sheet_name='Deaths') 
dataExcelCovidHospitalizations=pd.read_excel(fileXLSXs,sheet_name='Hospitalizations') 
dataExcelCovidDataDictionary=pd.read_excel(fileXLSXs,sheet_name='DataDictionary') 


# Of course, now you have several data frames:

# In[ ]:


# basic statistics:
dataExcelCovidCases.describe()


# In[ ]:


# checking data frame contents:
dataExcelCovidDeaths.info()


# In[ ]:


# checking number of rows and columns:
dataExcelCovidHospitalizations.shape


# In[ ]:


# seeing contents:
dataExcelCovidDataDictionary


# In[ ]:


# if you need more space:
pd.set_option('max_colwidth', 800)
dataExcelCovidDataDictionary


# [home](#home)
# 
# ____
# 
# <a id='part2'></a>
# 
# ## Collecting data from APIs
# 
# Open data portals from the government and other organizations have APIs, a service that allows you to collect their data. Let's take a look a Seattle data about Seattle Real Time Fire 911 Calls:

# In[ ]:


from IPython.display import IFrame  
fromAPI="https://dev.socrata.com/foundry/data.seattle.gov/kzjm-xkqj" 
IFrame(fromAPI, width=900, height=500)


# That page tells you how to get the data into pandas. But first, you need to install **sodapy**. Then you can continue:

# In[ ]:


from sodapy import Socrata

client = Socrata("data.seattle.gov", None)
results = client.get("kzjm-xkqj", limit=1000)

# Convert to pandas DataFrame
results_df = pd.DataFrame.from_records(results)
results_df.head()


# Data from APIs may need some more pre processing than the previous files. Besides, you should study the API documentation to know how to interact with the portal. Not every open data portal behaves the same.

# [home](#home)
# ____
# <a id='part3'></a>
# 
# ## Scraping

# Sometimes you are interested in data from the web, which will require further processing. Let me get a table from wikipedia:

# In[ ]:


from IPython.display import IFrame  
wikiLink="https://en.wikipedia.org/wiki/Democracy_Index" 
IFrame(wikiLink, width=700, height=300)


# I will use pandas to get the table, but you need to install these first:
# * html5lib 
# * beautifulsoup
# * lxml

# In[ ]:


dataWIKI=pd.read_html(wikiLink,header=0,flavor='bs4',attrs={'class': 'wikitable'})


# Pandas has this command **read_html** that will save lots of coding, above I just said:
# * The link to the webpage.
# * The position of the header.
# * The external library that will be used to extract the text (_flavor_).
# * The attributes of the table.

# dataWIKI is not a data frame:

# In[ ]:


type(dataWIKI)


# The command **read_html** returns all the elements from the link with the same attributes. Let's see how many there are:

# In[ ]:


len(dataWIKI)


# This means you have three tables. Ours is the first one:

# In[ ]:


# remember that Python starts counting in ZERO!
dataWIKI[0]


# [home](#home)
# ____
# <a id='part4'></a>
# 
# ## Social media data

# Social media offer APIs too that allow you to get _some_ data. In general, you need to go register as a developer and create a service, and Twitter, Facebook and others will allow you to get some of their data (the more you pay the more they offer). 
# 
# There is a simple library named **facebook_scraper**, which allows basic interaction facebook. It really gets the messages that are visible and does not use the API so you can not expect much information, but it is worth knowing it:

# In[ ]:


# install it
#!pip install facebook_scraper


# Let me now get the facebook posts from the WA State department of Health. 
# 
# First, let me use just one function:

# In[ ]:


# this is how you call a function from a library:
from facebook_scraper import get_posts


# This function works like this:

# In[ ]:


# see the 'help' for the function:
get_ipython().run_line_magic('pinfo', 'get_posts')


# Then, I simply write the arguments I desire:

# In[ ]:


# this will give you a 'generator'
faceWAHealth=get_posts(account='WADeptHealth', extra_info=True)


# In[ ]:


# this is the generator, not the data:
faceWAHealth


# You can get each element from the generator like this:

# In[ ]:


json_data = [r for r in faceWAHealth]


# In[ ]:


#what is this?
type(json_data)


# In[ ]:


#what is the first element:


# In[ ]:


json_data[0]


# In[ ]:


#what is it?
type(json_data[0])


# We have a list with several dictionaries (dicts). Dictionaries are not table, but complex containers of data. Python can **flat** a list of dictionaries into a data frame like this:

# In[ ]:


allFace=pd.json_normalize(json_data)


# This is the result:

# In[ ]:


#more familiar:
allFace


# You can save this posts into a file in your computer. Let me create a CSV file (where each row is separate by commas):

# In[ ]:


allFace.to_csv('faceWAHealth.csv',index=False)


# You could have saved any of your previous data frames the same way!
