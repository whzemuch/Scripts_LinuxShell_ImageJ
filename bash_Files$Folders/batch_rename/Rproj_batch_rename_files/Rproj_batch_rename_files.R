# Load packages
library(data.table)
library(tidyverse)

# import the raw dataframe
file <- fread("NHASLab.txt", data.table = FALSE, header = FALSE)
colnames(file) <- c("year","description", "doc_file", "size", "date" )

# get the list of old files
file_path <- list.files(".", pattern = "*.XPT", full.names = TRUE)

# conctruct the dataframe with old names and new names
names_from_to <- 
file %>% 
  mutate(xpt_file = str_replace_all(doc_file, " Doc", "")) %>% 
  mutate(
    old_file_name = paste0("./", xpt_file, ".XPT"),
    new_file_name = paste0(year, "_", xpt_file, ".XPT")
    ) %>% 
  select(old_file_name, new_file_name) %>% 
  filter(old_file_name %in% file_path) 
  
# rename files
file.rename(from = names_from_to$old_file_name, to = names_from_to$new_file_name)


