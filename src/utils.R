
get_na <- function(df){
  rows_with_na <- df |>
    filter(if_any(everything(), is.na))
  na_counts <- df |>
    summarise(across(everything(), ~ sum(is.na(.))))
  list(Rows = rows_with_na, Counts = na_counts)
}