# Convert a list to a data frame
# https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame

lst <- replicate(
  132,
  as.list(sample(letters, 20)),
  simplify = FALSE
)

df <- data.frame(matrix(unlist(l), nrow=length(l), byrow=T))
head(df)

# tidyverse version can work with unequal length list.


ll <- list(a = list(var.1 = 1, var.2 = 2, var.3 = 3)
          , b = list(var.1 = 4, var.2 = 5, var.3 = 6)
          , c = list(var.1 = 7, var.2 = 8, var.3 = 9)
          , d = list(var.1 = 10, var.2 = 11, var.3 = 12)
)


#1 ldply, data.frame===============
library (plyr)
df1 <- ldply (ll, data.frame)
df1

#2 reduce, rbind==============
data.frame(Reduce(rbind, ll)) %>% View


#3 data.table, rbindlist================================
library(data.table)
DT <- rbindlist(ll)
DT


# 4 tidyverse: unlist, enframe unnest=========================
ll %>% 
  unlist(recursive = FALSE) %>%
  enframe() %>% 
  unnest() %>% View

#5 purrr: map

map_df(ll, ~.x)

