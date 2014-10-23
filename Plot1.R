
################################################################################
### script for building plot1.png from Coursera EDA Course Project 2 ###########
################################################################################

# you should change path according to ypur system
setwd("C:/Users/gregory/Documents/!Projects/Trainings/Coursera - Exploratory Data Analysis/Coursera-EDA---CP2")

options(stringsAsFactors = FALSE)
# Data was downloaded from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# on 23.10.2014 with commented line below. It is not reasonable to download data every time so it is commented.
# download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","eda_cp2_data.zip")

# Unzip file
unzip("eda_cp2_data.zip")

# read data
power_cons_data = read.table(unzipped_file,header=TRUE,sep=";",na.strings = "?",stringsAsFactors = FALSE)

unlink (unzipped_file)