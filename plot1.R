wd <- "C:/Users/lsanchez/Desktop/Coursera Data Science/Course 4 Exploratory Data Analysis/CourseProjectW4/Exploratory-Data-Analysis-Course-Project"

## Download/unzip data
#######################
setwd(wd)
zipFile <- "data.zip"

if (!file.exists(zipFile)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, zipFile)
}

if (!file.exists("data")) { 
  unzip(zipFile) 
}


# Load data 
###########
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

######
# Q1 #
######
###################################################################################
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from
# all sources for each of the years 1999, 2002, 2005, and 2008.
###################################################################################


# Aggregate by year
###################
yEmissions <- aggregate(NEI[, 'Emissions'], by=list(NEI$year), FUN=sum)
yEmissions$PM <- round(yEmissions[,2]/1000,2)
colnames(yEmissions) <- c("year", "emissions", "PM")

# Generate graph in same directory
##################################
png(filename='plot1.png')

barplot(yEmissions$PM, names.arg=yEmissions$year, 
        main=expression('Total Emission of PM'[2.5]),
        xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in tons/1000')))

dev.off()
