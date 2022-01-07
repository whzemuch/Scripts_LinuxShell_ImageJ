

# convert a list to  a data frame (equal length)====================================
#   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame?rq=1

ll <- replicate(
  132,
  list(sample(letters, 20)),
  simplify = FALSE
)
ll

# 1. data.frame + matrix
df <- data.frame(matrix(unlist(ll), nrow=length(ll), byrow=TRUE))

# 2. plyr

l <- list(a = list(var.1 = 1, var.2 = 2, var.3 = 3)
          , b = list(var.1 = 4, var.2 = 5, var.3 = 6)
          , c = list(var.1 = 7, var.2 = 8, var.3 = 9)
          , d = list(var.1 = 10, var.2 = 11, var.3 = 12)
)

library(plyr)

ldply(l, data.frame) %>% View
ldply(ll, data.frame) %>% View

# 3. Reduce + rbind
data.frame(Reduce(rbind, l)) %>% View

# 4. data.table rbindlist
library(data.table)
rbindlist(l) %>% as.data.frame() %>% View

#5. dplyr

dplyr::bind_rows(l) %>% View
purrr::map_df(l, dplyr::bind_rows) %>% View
purrr::map_df(l, ~.x) %>% View

# convert nested list to a data frame: unequal length =========
#https://mp.weixin.qq.com/s/26JDnZBwhK5wkw0vNrI4QQ
set.seed(123456)
gs=list(tmp1=list(g1=sample(1000,abs(floor(100*rnorm(1)))),
                  g2=sample(1000,abs(floor(100*rnorm(1))))),
        tmp2=list(g1=sample(1000,abs(floor(100*rnorm(1)))),
                  g2=sample(1000,abs(floor(100*rnorm(1))))),
        tmp3=list(g1=sample(1000,abs(floor(100*rnorm(1)))),
                  g2=sample(1000,abs(floor(100*rnorm(1))))))
deg <- gs
deg_list=lapply(names(deg), function(y){
  tmp=deg[[y]]
  data.frame(group= paste(y,unlist(lapply(names(tmp), function(x){
    rep(x,length(tmp[[x]]))
  })),sep='_') ,
  gene=unlist(tmp))
}) 
group_g=do.call(rbind,deg_list)


gs %>% 
  unlist() %>% 
  enframe(value="gene") %>%
  separate(name, into=c("tmp", "group"), sep = 7) %>% 
  #separate(name, into=c("tmp", "group"), sep = "\\.") %>% 
  #separate(group, into=c("g", "index"), sep = 2) %>% View
  mutate(gene = as.character(gene)) %>% View 
  




# data.table rbindlist()===================

# default case
DT1 = data.table(A=1:3,B=letters[1:3])
DT2 = data.table(A=4:5,B=letters[4:5])
l = list(DT1,DT2)
rbindlist(l)

# bind correctly by names
DT1 = data.table(A=1:3,B=letters[1:3])
DT2 = data.table(B=letters[4:5],A=4:5)
l = list(DT1,DT2)
rbindlist(l, use.names=TRUE)

# fill missing columns, and match by col names
DT1 = data.table(A=1:3,B=letters[1:3])
DT2 = data.table(B=letters[4:5],C=factor(1:2))
l = list(DT1,DT2)
rbindlist(l, use.names=TRUE, fill=TRUE)

# generate index column, auto generates indices
rbindlist(l, use.names=TRUE, fill=TRUE, idcol=TRUE)
# let's name the list
setattr(l, 'names', c("a", "b"))
rbindlist(l, use.names=TRUE, fill=TRUE, idcol="ID")

X <- list(list(a = pi, b = list(c = 1L)), d = "a test")
# the "identity operation":
rapply(X, function(x) x, how = "replace") -> X.; stopifnot(identical(X, X.))
rapply(X, sqrt, classes = "numeric", how = "replace")
rapply(X, deparse, control = "all") # passing extras. argument of deparse()
rapply(X, nchar, classes = "character", deflt = NA_integer_, how = "list")
rapply(X, nchar, classes = "character", deflt = NA_integer_, how = "unlist")
rapply(X, nchar, classes = "character",                      how = "unlist")
rapply(X, log, classes = "numeric", how = "replace", base = 2)

# purrr===========
mtcars %>% 
  split(.$cyl) %>% 
  map(~ lm(mpg ~ wt, data = .x)) %>% 
  map(summary) %>% 
  map_dbl("r.squared") 

mtcars %>% 
  split(.$cyl) %>% 
  map(~ lm(mpg ~ wt, data = .x)) %>% 
  map_dfr(~ as.data.frame(t(as.matrix(coef(.))))) 
