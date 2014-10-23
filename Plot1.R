
################################################################################
### script for building plot1.png from Coursera EDA Course Project 2 ###########
################################################################################

# you should change path according to ypur system
setwd("C:/Users/gregory/Documents/!Projects/Trainings/Coursera - Exploratory Data Analysis/Coursera-EDA---CP2")

library(dplyr)
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
total_per_year = NEI %>% group_by(year) %>% summarize(Emissions = sum(Emissions))

# plot
png(filename="plot1.png", width = 480, height = 480)
par(las=1) # place labels on Y vertically
with(total_per_year,{
    plot(year, Emissions/1e6,
         xlim = c(1999,2008),
         type = "b",
         main = expression(paste("USA total emission of ",PM[2.5],
                                 " decreased during 1999-2008")),
         xaxt = "n",
         xlab = "Year",
         ylab = expression(paste(PM[2.5], ", millions tons")))
    axis(1, at=unique(year), labels=unique(year)) # Places x-labels in correct places
})

dev.off()



