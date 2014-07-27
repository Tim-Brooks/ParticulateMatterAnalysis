library("ggplot2")

create_plot <- function(data_list) {
  g <- qplot(year, x, data = yt, facets = .~ type, geom="bar", stat = "identity")
  g2 <- g + ggtitle("Emissions by type per year for Baltimore, MD") + ylab("Tons PM2.5") + xlab("Year")
  ggsave(filename="plot3.png", plot=g2)
}

reduceToBalMD <- function(data_frame) {
  subset(data_frame, fips == "24510")  
}

aggregateOnYear <- function(data_frame) {
  aggregate(data_frame$Emissions, by=list(type=data_frame$type, year=data_frame$year), FUN=sum)  
}

readData <- function() {
  NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
  NEI$year <- as.factor(NEI$year)
}

runScript <- function() {
  create_plot(aggregateOnYear(reduceToBalMD(readData())))
}