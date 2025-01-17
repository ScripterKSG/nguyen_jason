# Homework #2 -------------------------------------------------------------

#imports packages from the tidyverse
library(tidyverse)

#sets working directory inside datasets/gop_frags
setwd("~/datasets/gop_frags/")

#defines a variable files which stores a list of the files in the working
#directory
files <- list.files()

#defines a variable data which stores the data from a map function
#with parameters files, function(x) and read_csv(x)
# - is also a list of 11
data <- map(files,function(x) read_csv(x))

#defines a variable gop_data which stores the data from a map function
#with parameters files, function(x,y) and cbind(x,y)
# - is also a list of 11
gop_data <- map2(files,data, function(x,y) cbind(x,y))

#defines a variable gop_df which stores text and date data from speakers such
#as Trump, Paul and Carson
gop_df <- do.call(rbind,gop_data)


#renames the variable x in gop_df to date
names(gop_df)[1] <- "date"

#df1 takes the data from gop_df and adds on 2 columns, one which points out the 
#speaker of each line of text and another which records the text length
df1 <- gop_df %>% 
  separate(date,"date",sep = "\\.") %>% 
  separate(text, "speaker", sep = ":", remove = FALSE) %>% 
  mutate(text_length = nchar(text))

#df2 takes the data from df1 and uses it to find and list the speakers, how
#many times they each took a turn to talk, their total text length (or total
#number of characters spoken) and their average text length per turn
df2 <- df1 %>% 
  group_by(speaker) %>% 
  summarise(talking_turns = n(), 
            total_length = sum(text_length),
            ave_length = mean(text_length)) %>% 
  pivot_longer(-speaker,names_to = "variable", values_to = "value")
