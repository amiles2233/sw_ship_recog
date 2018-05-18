library(rvest)
library(jsonlite)
library(httr)
library(magick)
library(purrr)

key <- 'uwish'

ships <- c('x+wing', 'tie+fighter', 'millennium+falcon', 'star+destroyer', 'y+wing', 'tie+bomber', 'slave+1',
           'naboo+starfighter', 'shuttle+tyderium', 'jedi+starfighter')

get_ships <- function(x){
  result <- GET(paste0("https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=",x,"&count=",600),
                add_headers("Ocp-Apim-Subscription-Key" = key))
  
  content <- result$content %>% rawToChar() %>% fromJSON()
  
  val <- content$value
  
  val$ship <- x
  
  val <- val %>% dplyr::select(ship, contentUrl, thumbnailUrl, encodingFormat, imageId)
  
  return(val)
  
}

data <- map_df(ships, get_ships)

saveRDS(data, 'ship_prep_data.RDS')

