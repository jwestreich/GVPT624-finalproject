#set maximum distance a guess can be wrong (in meters)
max_dist<-40000000

#read in the actual locations  
answers<-read_csv(paste0(output_location,"/locations.csv"))

#read in people's guesses
guesses <- read_sheet(google_sheet_link)%>%
  group_by(team_name,location)%>%
  #data check: if someone submitted more than once, take the most recent one
  filter(datetime==max(datetime))%>%
  ungroup()

#calculate distance and score
score_by_location<-answers%>%
  #merge the actual locations with the scores
  right_join(guesses,by=c("seqnum"="location"))%>%
  #calculate the distance between each guess and the real location
  mutate(distance = distHaversine(cbind(longitude, latitude), cbind(longitude_guess, latitude_guess)))%>%
  #calculate a score based on exponential distance
  mutate(score=round(5000 * exp(-10 * distance / max_dist),0))%>%
  #convert distance to miles and add unit
  mutate(distance_label=paste0(round(distance*0.000621371,1)," mi"))

#summarize scores by team
score_by_team<-score_by_location%>%
  group_by(team_name)%>%
  summarise(score=sum(score,na.rm=T))

write_csv(score_by_location, paste0(output_location,"results/results by location.csv"))
write_csv(score_by_team, paste0(output_location,"results/results by team.csv"))