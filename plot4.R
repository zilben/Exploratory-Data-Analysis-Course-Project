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
# Q4 #
######
###################################################################################
# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999-2008?
###################################################################################

library(ggplot2)

# subset data by Coal combustion related sources
#################################
SCC.coal = SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]
head(SCC.coal)

# Merge NEI and subset SCC data sets
####################################
mergeData <- merge(x=NEI, y=SCC.coal, by='SCC')
mergeData.sum <- aggregate(mergeData[, 'Emissions'], by=list(mergeData$year), sum)
colnames(mergeData.sum) <- c('Year', 'Emissions')

# Generate graph in same directory
##################################
png(filename='plot4.png')

ggplot(data=mergeData.sum, 
       aes(x=Year, y=Emissions/1000)) + 
  geom_line(aes(group=1, col=Emissions)) +
  geom_point(aes(size=2, col=Emissions)) + 
  ggtitle(expression('Total Emissions of PM'[2.5])) + 
  ylab(expression(paste('PM', ''[2.5], ' in tons/1000'))) + 
  geom_text(aes(label=round(Emissions/1000,digits=2),
                size=2, hjust=1.5, vjust=1.5)) + 
  theme(legend.position='none') +
  scale_colour_gradient(low='black', high='red')

dev.off()

