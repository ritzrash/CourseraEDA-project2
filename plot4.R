NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
coal_SCC <- SCC[grep("coal", SCC$Short.Name, ignore.case = TRUE), ]
SCC_coallist <- unique(coal_SCC$SCC)
coal_NEI <- subset(NEI, SCC %in% SCC_coallist)
totalPM_coal <- with(coal_NEI, tapply(Emissions, year, sum, na.rm=TRUE))
png("plot4.png", height = 480, width = 480)
barplot(totalPM_coal, main = "Total PM2.5 emissions due to coal related combustion year-wise", xlab="year", ylab="Total PM2.5 Emission")
dev.off()