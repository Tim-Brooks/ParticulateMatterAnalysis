
create_plot <- function(data_list) {
  png(filename="plot2.png", width=480, height=480)
  barplot(byYear$x, main="Emissions By Year", names.arg=byYear$year, cex.names=0.8)
  dev.off()
}

reduceToBalMD <- function(data_frame) {
  subset(data_frame, fips == "24510")  
}

aggregateOnYear <- function(data_frame) {
  aggregate(data_frame$Emissions, by=list(year=data_frame$year), FUN=sum)  
}

readData <- function() {
  NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
  NEI$year <- as.factor(NEI$year)
}

runScript <- function() {
  create_plot(aggregateOnYear(reduceToBalMD(readData())))
}