library("ggplot2")

create_plot <- function(data_list) {
  g <- qplot(year, x, data = data_list, geom="bar", stat = "identity")
  g2 <- g + ggtitle("Motor Vehicle Emissions by Year in Baltimore, MD") + ylab("Tons PM2.5") + xlab("Year")
  ggsave(filename="plot5.png", plot=g2)
}

# The EPA website states: 
# The four sectors for on-road mobile sources include emissions from motorized vehicles 
# that are normally operated on public roadways. This includes passenger cars, motorcycles,
# minivans, sport-utility vehicles, light-duty trucks, heavy-duty trucks, and buses. 
# The sectors include emissions from parking areas as well as emissions while the vehicles 
# are moving.
subsetToMotorVehicles <- function(data_frame) {
  subset(data_frame, type == "ON-ROAD")
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
  NEI$SCC <- as.factor(NEI$SCC)
  NEI
}

runScript <- function() {
  create_plot(aggregateOnYear(reduceToBalMD(subsetToMotorVehicles(readData()))))
}