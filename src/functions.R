append_files <- function(station){
  files <- list.files(path = dir, 
                      pattern = toupper(gsub(" ", "_", station)),
                      full.names = T
                      )
  setNames(do.call(rbind, lapply(files, read.csv,
                                 sep = "\t",
                                 stringsAsFactors = FALSE,
                                 header = F)),
           c("station","year","month","day","jul","MinTemp","MaxTemp",
              "SolarRad","PET","Precipitation","WindSpeed","VP","CO2")
           )
}

calculate_GDD <- function(df, 
                          base = 5,
                          gs = 5:9) {
  df <- df[df$month %in% gs, ] |>
    mutate(GDD = pmax(0, ((MaxTemp + MinTemp) / 2 - base))) |>
    group_by(year) |>
    mutate(GDD_cum = cumsum(GDD), Precip_cum = cumsum(Precipitation)) |>
    ungroup()
  df
}

# timeframe
# 0 = whole year
# 1 = growing season
# groupbymonth = T/F
get_cumulative <- function(df,
                           timeframe = 1,
                           groupbymonth = F,
                           variables = c("Precipitation"),
                           gs = 5:9){
  
  if (timeframe == 1) {
    df <- df[df$month %in% gs, ]
  }
  
  if (!("GDD" %in% names(df)) && "GDD" %in% variables){
    df <- calculate_GDD(df, gs = gs)
  }
  
  if (groupbymonth){
    group_vars <- c("year", "month")
  } else {
    group_vars <- "year"
  }
  
  new_df <- df |>
    group_by(across(all_of(group_vars))) |>
    summarise(across(
      .cols = variables,
      .fns = ~sum(.x, na.rm = T)
    ))
  
  new_df
}

# timeframe
# 0 = whole year
# 1 = growing season
# years
# 0 = over all years
# 1 = yearly
# group
# M = by month
# D = by day
summarise_climate <- function(df,
                              timeframe = 1,
                              years = 0,
                              group = NULL,
                              gs = 5:9) {
  groups <- c(M = "month", D = "jul")
  
  # Filter May–September if timeframe = 1
  if (timeframe == 1) {
    df <- df[df$month %in% gs, ]
  }
  
  # Determine grouping columns
  group_vars <- NULL
  
  if (!is.null(group) && group %in% names(groups)) {
    group_vars <- groups[group]
  }
  
  if (years == 1) {
    group_vars <- c("year", group_vars)
  }
  
  # Group and summarise using tidy evaluation
  new_df <- df |>
    group_by(across(all_of(group_vars))) |>
    summarise(across(
      .cols = c(MinTemp, MaxTemp, SolarRad, Precipitation, WindSpeed, VP),
      .fns = list(
        min = ~ min(.x, na.rm = TRUE),
        max = ~ max(.x, na.rm = TRUE),
        mean = ~ mean(.x, na.rm = TRUE),
        median = ~ median(.x, na.rm = TRUE),
        sd = ~ sd(.x, na.rm = TRUE)
      ),
      .names = "{.col}_{.fn}"
    ),
    .groups = "drop")
  
  new_df
}
  

