#read in the GTD
#a version that has only a few variables, to make reading in the data easier
locations_draft<-read.csv(paste0(data_location,"gtd_lessvars.csv"))%>%
  #create a random variable, and sort by that variable
  mutate(rand=runif(n()))%>%
  arrange(rand)%>%
  #filter to only the first 20 rows
  #this is a random sample of 20 terrorist attacks
  #using 20 rows because some locations may not have Google Maps Street View coverage
  filter(row_number()<=20)%>%
  #data cleaning
  mutate(location=paste0(latitude,",",longitude))%>%
  rename(longitude_draft=longitude,
         latitude_draft=latitude)
