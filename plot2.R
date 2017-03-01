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
# Q2 #
######
###################################################################################
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.
###################################################################################

# Subset data by fips 24510
###########################

MD <- subset(NEI, fips=='24510')

# Generate graph in same directory
##################################

png(filename='plot2.png')

barplot(tapply(X=MD$Emissions, INDEX=MD$year, FUN=sum), 
        main='Total Emission in Baltimore City, MD, in tons', 
        xlab='Year', ylab=expression('PM'[2.5]))

dev.off()
