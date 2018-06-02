library(plyr)
library(tidyverse)
library(magick)
library(caret)

data <- readRDS('ship_prep_data.RDS') %>%
  mutate(ship=str_replace_all(ship, "\\+", "_"))

data$nrow <- seq(1:nrow(data))

# Create TrainTest Split
part <- createDataPartition(data$ship, p=.7, list=FALSE) 

# Assign Data to Group
data$part <- ifelse(data$nrow %in% part, "train", "test")

# Create Path Variable
data$path <- paste0('images/', data$part,"/", data$ship,"/", data$ship, "_", data$nrow,".jpeg")

# Write Image to Path
get_write_image <- function(x){
  img <- image_read(data$thumbnailUrl[x])
  image_write(img, data$path[x], format="jpeg")
}


map(data$nrow[-1422], get_write_image)


