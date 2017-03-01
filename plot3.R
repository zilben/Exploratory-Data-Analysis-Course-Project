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
# Q3 #
######
###################################################################################
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for 
# Baltimore City? Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.
###################################################################################

library(ggplot2)

# Subset data by fips 24510 and set 'year' as factor
####################################################
MD <- subset(NEI, fips == 24510)
MD$year <- factor(MD$year, levels=c('1999', '2002', '2005', '2008'))

# Generate graph in same directory
##################################
png(filename='plot3.png')

ggplot(data=MD, aes(x=year, y=log(Emissions))) + 
  facet_grid(. ~ type) + 
  guides(fill=F) + 
  geom_boxplot(aes(fill=type)) + 
  stat_boxplot(geom ='errorbar') + 
  ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + 
  xlab('Year') + 
  ggtitle('Emissions per Type in Baltimore City, Maryland') + 
  geom_jitter(alpha=0.10)

dev.off()

