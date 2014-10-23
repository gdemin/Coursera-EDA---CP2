
################################################################################
### script for building plot6.png from Coursera EDA Course Project 2 ###########
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
per_year = NEI %>% 
    filter((SCC %in% SCC_vehicle) & (fips %in% c("24510","06037"))) %>% 
    mutate(city=factor(ifelse(fips == "24510","Baltimore","Los-Angeles"))) %>% 
    group_by(city,year) %>% 
    summarize(Emissions = sum(Emissions))

# here we convert emissions to percents of emission of 1999 year in corresponding city
# so we can better compare changes in this two cities
# absolute numbers differs in order of magnitude in this cities
per_year = within(per_year,{
    Emissions[city=="Baltimore"] = Emissions[city=="Baltimore"]/Emissions[city=="Baltimore" & year==1999]*100 
    Emissions[city=="Los-Angeles"] = Emissions[city=="Los-Angeles"]/Emissions[city=="Los-Angeles" & year==1999]*100 
    
})

# plot
png(filename="plot6.png", width = 640, height = 480)
qplot(year,Emissions,
      data = per_year,
      facets = . ~ city,
      geom = "line",
      xlab = "Year",
      ylab = expression(paste(PM[2.5], ", % of 1999 in corresponding city")),
      main = expression(atop(paste("Emission of ",PM[2.5]," in 1999-2008"),
                              "drastically decreased in Baltimore and didn't change in LA"))) + 
    theme_bw()

dev.off()



