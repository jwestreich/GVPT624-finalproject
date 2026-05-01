#check Google Maps Street View metadata to make sure locations have street view imagery
locations <- locations_draft %>%
  rowwise() %>%
  #see what the API call says about the location
  mutate(
    valid = {
      coords <- str_split(location, ",")[[1]]
      lat <- coords[1]
      lng <- coords[2]
      res <- fromJSON(GET(
        paste0(
          "https://maps.googleapis.com/maps/api/streetview/metadata?location=",
          location, "&key=", Sys.getenv("GOOGLE_MAPS_API_KEY")
        )
      ) %>% content("text"))
      res$status == "OK"
    },
    latitude = {
      if (valid) {
        coords <- str_split(location, ",")[[1]]
        res <- fromJSON(GET(
          paste0(
            "https://maps.googleapis.com/maps/api/streetview/metadata?location=",
            location, "&key=", Sys.getenv("GOOGLE_MAPS_API_KEY")
          )
        ) %>% content("text"))
        res$location$lat
      } else {
        NA
      }
    },
    longitude = {
      if (valid) {
        coords <- str_split(location, ",")[[1]]
        res <- fromJSON(GET(
          paste0(
            "https://maps.googleapis.com/maps/api/streetview/metadata?location=",
            location, "&key=", Sys.getenv("GOOGLE_MAPS_API_KEY")
          )
        ) %>% content("text"))
        res$location$lng
      } else {
        NA
      }
    }
  ) %>%
  ungroup() %>%
  #filter to valid locations only
  filter(valid == TRUE)%>%
  #give locations an order, and keep only the first 5 locations
  mutate(seqnum=row_number())%>%
  filter(seqnum<=5)

#data check: if less than 5 valid locations were found, return an error
if (nrow(locations) < 5) {
  stop("Less than 5 valid locations found")
}

write_csv(locations, paste0(output_location,"/locations.csv"))