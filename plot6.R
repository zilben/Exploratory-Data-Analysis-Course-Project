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
# Q6 #
######
###################################################################################
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == 06037).
# Which city has seen greater changes over time in motor vehicle emissions?
###################################################################################

library(ggplot2)

# set 'year' as factor
######################
NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))


# subset on Baltimore City, Maryland, and on Los Angeles, CA
############################################################
MD.onroad <- subset(NEI, fips == '24510' & type == 'ON-ROAD')
CA.onroad <- subset(NEI, fips == '06037' & type == 'ON-ROAD')

# Aggregate by year sum
#######################
MD.sum <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.sum) <- c('year', 'Emissions')
MD.sum$City <- paste(rep('Baltimore City, MD', 4))

CA.sum <- aggregate(CA.onroad[, 'Emissions'], by=list(CA.onroad$year), sum)
colnames(CA.sum) <- c('year', 'Emissions')
CA.sum$City <- paste(rep('Los Angeles, CA', 4))

merged <- as.data.frame(rbind(CA.sum, MD.sum))
merged$City <- factor(merged$City, levels=c('Los Angeles, CA', 'Baltimore City, MD'))

# Generate graph in same directory
##################################
png('plot6.png')

ggplot(data=merged, aes(x=year, y=Emissions)) + 
  geom_bar(mapping = aes(fill=City), stat = "identity") +
  guides(fill=F) + 
  ggtitle('Total Emissions of Motor Vehicle Sources\nLos Angeles County, CA vs. Baltimore City, MD') + 
  ylab(expression('PM'[2.5])) +
  xlab('Year') +
  theme(legend.position='none') +
  facet_grid(. ~ City) + 
  geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=-1))

dev.off()