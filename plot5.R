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
# Q5 #
######
###################################################################################
# How have emissions from motor vehicle sources changed from 1999-2008 in
# Baltimore City? 
###################################################################################

library(ggplot2)

# set 'year' as factor
######################
NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))

# subset on Baltimore City, Maryland, and on 'ON-ROAD'
######################################################
MD.onroad <- subset(NEI, fips == 24510 & type == 'ON-ROAD')

# Aggregate by year sum
#######################
MD.sum <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.sum) <- c('year', 'Emissions')

# Generate graph in same directory
##################################
png('plot5.png')

ggplot(data=MD.sum, aes(x=year, y=Emissions)) +
  geom_bar(stat = "identity", 
           show.legend = T) +
  guides(fill=F) + 
  ggtitle('Total Emissions by Motor Vehicle Sources\nin Baltimore City, MD') + 
  ylab(expression('PM'[2.5])) +
  xlab('Year') +
  theme(legend.position='none') + 
  geom_label(label.r = unit(0, "lines") ,aes(label=round(Emissions,0)))

dev.off()
