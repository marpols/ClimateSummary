
get_na <- function(df, column){
  count <- sum(is.na(df[column]))
  instances <- df[is.na(df[column]), ]
  list(count = count, instances = instances)
}