

#select file from file explorer
dir <- rstudioapi::selectDirectory()
#or input file path
dir <- "C:\Users\marpo\Documents\Research\STICS\JavaSTICS-1.5.3-STICS-10.3.0\irrigation_assessment"

stations <- c("Harrington",
              "East Point",
              "Summerside",
              "New Glasgow")

data <- setNames(lapply(stations, append_files),
                 stations)

#Get growing season GDD and cummulative GDD 
gs_GDD <- lapply(data, calculate_GDD)

#Get growing season total precipitation by year
yearly_cum <- lapply(data, get_cumulative, variables = c("Precipitation","GDD"))

#Get growing season total precipitation by year, month
monthly_cum <- lapply(data, get_cumulative, groupbymonth = T)

#Get climate data statistics
summary <- lapply(data, summarise_climate)


