
################################################################################
### script for building plot4.png from Coursera EDA Course Project 2 ###########
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

# find 'coal' EI.Sector. There is an ambiguity in this task so I choose EI.Sector because a lot of "combustion" in it
coal = levels(SCC$EI.Sector)[grep("coal",tolower(levels(SCC$EI.Sector)))]
# [1] "Fuel Comb - Comm/Institutional - Coal"       "Fuel Comb - Electric Generation - Coal"     
# [3] "Fuel Comb - Industrial Boilers, ICEs - Coal"

SCC_coal = with(SCC,SCC[EI.Sector %in% coal])

# aggregate emissions per year
total_per_year = NEI %>% 
    filter(SCC %in% SCC_coal) %>% 
    group_by(year) %>% 
    summarize(Emissions = sum(Emissions))

# plot
png(filename="plot4.png", width = 640, height = 480)
par(las=1) # place labels on Y vertically
with(total_per_year,{
    plot(year, Emissions/1000,
         xlim = c(1999,2008),
         type = "b",
         main = bquote(atop(paste("USA emission of ",PM[2.5]," from"),
                                 " coal combustion-related sources decreased in recent years")),
         xaxt = "n",
         xlab = "Year",
         ylab = expression(paste(PM[2.5], ", thousands tons")))
    axis(1, at=unique(year), labels=unique(year)) # Places x-labels in correct places
})

dev.off()



