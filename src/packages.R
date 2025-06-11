packages <- c("dplyr", "precintcon", "tidyr", "grid","png")

sapply(packages, function(pkg){
  if(!requireNamespace(pkg, quietly = TRUE, character.only = TRUE)){
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
})
