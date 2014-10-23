
################################################################################
### script for building plot3.png from Coursera EDA Course Project 2 ###########
################################################################################

# you should change path according to your system
setwd("C:/Users/gregory/Documents/!Projects/Trainings/Coursera - Exploratory Data Analysis/Coursera-EDA---CP2")

library(dplyr)
library(ggplot2)
library(scales)
options(stringsAsFactors = FALSE)
# Data was downloaded from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# on 23.10.2014 with commented line below. It is not reasonable to download data every time so it is commented.
# download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","eda_cp2_data.zip")

# Unzip file
unzip("eda_cp2_data.zip")

# read data
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# we will keep only zipped version
unlink("Source_Classification_Code.rds")
unlink("summarySCC_PM25.rds")

# aggregate emissions per year
marylend_per_year = NEI %>% 
    filter(fips == "24510") %>% 
    mutate(type = factor(type),Emissions=Emissions/1000)  %>%  
    group_by(type, year) %>% 
    summarize(Emissions = sum(Emissions))

# plot
png(filename="plot3.png", width = 640, height = 480)
qplot(year,Emissions,
      data = marylend_per_year,
      facets = .~type,
      geom = "line",
      xlab = "Year",
      ylab = expression(paste(PM[2.5], ", thousands tons")),
      main = expression(paste("Baltimore emission of ",PM[2.5],
                              " increased in POINT source during 1999-2008"))) + 
    theme_bw()

dev.off()



