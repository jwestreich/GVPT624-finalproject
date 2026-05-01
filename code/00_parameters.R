library(tibble)
library(dplyr)
library(readr)
library(sf)
library(httr)
library(jsonlite)
library(purrr)
library(tidyverse)
library(janitor)
library(googlesheets4)
library(stringr)
library(geosphere)
library(leaflet)
library(magick)
library(metro)
library(gtfstools)
library(readxl)
library(arrow)

google_sheet_link<-"https://docs.google.com/spreadsheets/d/188wl-XhzJ0fz0TCU9zHMOKmARJes0_Is-VX1b9NZgAs/edit?usp=sharing"
auto_run<-"yes"

code_base<-paste0("C:/Users/jwest/Documents/APAN/GVPT624/final project/code/")
output_location<-paste0("C:/Users/jwest/Documents/APAN/GVPT624/final project/output/")
data_location<-paste0("C:/Users/jwest/Documents/APAN/GVPT624/final project/data/")

if (auto_run=="yes"){
  source(paste0(code_base,"01_locations.R"))
  source(paste0(code_base,"02_metadata.R"))
  source(paste0(code_base,"03_images.R"))
}
