packages <- c("dplyr", "precintcon", "tidyr", "grid","png")

sapply(packages, function(pkg){
  if(!(pkg %in% installed.packages())){
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
})
