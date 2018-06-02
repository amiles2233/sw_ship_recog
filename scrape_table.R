library(rvest)
library(jsonlite)
library(httr)
library(magick)
library(purrr)

key <- '20ce40b2826f4f49b7785e603567cf4d'

ships <- c('x_wing', 'tie_fighter', 'millennium_falcon', 'star_destroyer', 'y_wing', 'tie_bomber', 'slave_1',
           'naboo_starfighter', 'shuttle_tyderium', 'jedi_starfighter')


get_ships <- function(x, y){
  offset <- seq(from=0, to=y-1, by=150)
   fun <- function(y){
     result <- GET(paste0("https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=",x,"&count=150","&offset=",y),
                   add_headers("Ocp-Apim-Subscription-Key" = key))
     val <- result$content %>% rawToChar() %>% fromJSON() %>% .$value
     val$ship <- x
     val <- val %>% dplyr::select(ship, contentUrl, thumbnailUrl, encodingFormat, imageId)
     return(val)
     
   }
  
  data <- purrr::map_df(offset,  fun)
  
  return(data)
}


data <- map_df(ships, get_ships, y=600)
