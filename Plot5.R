
################################################################################
### script for building plot5.png from Coursera EDA Course Project 2 ###########
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

# find 'vehicle' EI.Sector. There is an ambiguity in this task so I choose EI.Sector.
vehicle = levels(SCC$EI.Sector)[grep("vehicle",tolower(levels(SCC$EI.Sector)))]

# [1] "Mobile - On-Road Diesel Heavy Duty Vehicles"   "Mobile - On-Road Diesel Light Duty Vehicles"  
# [3] "Mobile - On-Road Gasoline Heavy Duty Vehicles" "Mobile - On-Road Gasoline Light Duty Vehicles"

SCC_vehicle = with(SCC,SCC[EI.Sector %in% vehicle])


# aggregate emissions per year
baltimore_per_year = NEI %>% 
    filter((SCC %in% SCC_vehicle) & (fips == "24510")) %>% 
    group_by(year) %>% 
    summarize(Emissions = sum(Emissions))

# plot
png(filename="plot5.png", width = 640, height = 480)
par(las=1) # place labels on Y vertically
with(baltimore_per_year,{
    plot(year, Emissions,
         xlim = c(1999,2008),
         type = "b",
         main = bquote(atop(paste("Baltimore emission of ",PM[2.5]," from"),
                                 " motor vehicle sources decreased in 1999-2008")),
         xaxt = "n",
         xlab = "Year",
         ylab = expression(paste(PM[2.5], ", tons")))
    axis(1, at=unique(year), labels=unique(year)) # Places x-labels in correct places
})

dev.off()



