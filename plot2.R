# Load Household Consumption Data into R and create plot of Global Active Power over time
# Assumes that the data file is in the R working directory and that user has dplyr and readr
# packages. If you do not, please install those packages.

# Using dplyr and readr
library(dplyr)
library(readr)

# Read text file in with read_delim() from readr
hcp <- read_delim("household_power_consumption.txt", delim = ";", na = "?")

# Convert Date from character to R Date format using mutate() from dplyr
hcp <- mutate(hcp, Date = as.Date(Date, format = "%d/%m/%Y"))

# Create two Date variables for the dates we want to subset
Date_1 <- as.Date("2007-02-01")
Date_2 <- as.Date("2007-02-02")

# Subset hcp over those dates and bind them into a new data frame
hcp_1 <- subset(hcp, Date == Date_1)
hcp_2 <- subset(hcp, Date == Date_2)
hcp_target <- rbind(hcp_1, hcp_2)


# Remove hcp, hcp_1, and hcp_2 from Environment as they are no longer needed
rm(hcp)
rm(hcp_1)
rm(hcp_2)

# Create a new column called Date_time that combines date and time using mutate
hcp_target <- mutate(hcp_target, Date_time = as.POSIXct(paste(hcp_target$Date, 
                                                              hcp_target$Time), format = "%Y-%m-%d %H:%M:%S"))

# Open PNG file to write plot to
png(file = "plot2.png")

# Plot a line graph of Date_time vs Global Active Power
plot(hcp_target$Date_time, hcp_target$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)",
     xlab = "")

# Copy plot to PNG file
dev.off()

# Remove hcp_target, Date_1, and Date_2 from the Environment
rm(hcp_target)
rm(Date_1)
rm(Date_2)