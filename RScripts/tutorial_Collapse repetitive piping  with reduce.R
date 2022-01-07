# Collapse repetitive piping with reduce()
# https://yjunechoe.github.io/posts/2020-12-13-collapse-repetitive-piping-with-reduce/?panelset=method-2


# Example 1 : ggplot2===================================

library(purrr)
library(tidyverse)

reduce(1:5, `+`, .init = 0.5)

reduce(1:5, ~ .x + .y, .init = 0.5)

ggplot(mtcars, aes(hp, mpg))  + 
  geom_point(size = 8, alpha = .5) +
  geom_point(size = 4, alpha = .5) +
  geom_point(size = 2, alpha = .5)



reduce(
    c(8, 4, 2),
    ~ .x + geom_point(size = .y, alpha = .5),
    .init = ggplot(mtcars, aes(hp, mpg))
)

viridis_colors <- viridis::viridis(10)

mtcars %>% 
  ggplot(aes(hp, mpg)) +
  geom_point(size = 20, color = viridis_colors[10]) +
  geom_point(size = 18, color = viridis_colors[9]) +
  geom_point(size = 16, color = viridis_colors[8]) +
  geom_point(size = 14, color = viridis_colors[7]) +
  geom_point(size = 12, color = viridis_colors[6]) +
  geom_point(size = 10, color = viridis_colors[5]) +
  geom_point(size = 8, color = viridis_colors[4]) +
  geom_point(size = 6, color = viridis_colors[3]) +
  geom_point(size = 4, color = viridis_colors[2]) +
  geom_point(size = 2, color = viridis_colors[1]) +
  scale_x_discrete(expand = expansion(.2)) +
  scale_y_continuous(expand = expansion(.2)) +
  theme_void() +
  theme(panel.background = element_rect(fill = "grey20"))


  
#  Method 2: Use reduce() in place, with the help of the {magrittr} dot .  
 mtcars %>% 
    ggplot(aes(hp, mpg)) %>% 
    
    reduce(
      10L:1L,
      ~ .x + geom_point(size = .y * 2, color = viridis_colors[.y]),
      .init = . #<- right here!
    ) + 
    
    scale_x_discrete(expand = expansion(.2)) +
    scale_y_continuous(expand = expansion(.2)) +
    theme_void() +
    theme(panel.background = element_rect(fill = "grey20"))
  

# Method 3: Move all the “constant” parts to the top, wrap it in parentheses,
# and pass the whole thing into .init using the {magrittr} dot.

(mtcars %>% 
    ggplot(aes(hp, mpg)) +
    scale_x_discrete(expand = expansion(.2)) +
    scale_y_continuous(expand = expansion(.2)) +
    theme_void() +
    theme(panel.background = element_rect(fill = "grey20"))) %>% 
  
  reduce(
    10L:1L,
    ~ .x + geom_point(size = .y * 2, color = viridis_colors[.y]),
    .init = . #<- right here!
  )


# Check out what happens if I change reduce() to accumulate() and return each element of the resulting list:
 
 plots <- (mtcars %>% 
    ggplot(aes(hp, mpg))+
    scale_x_discrete(expand = expansion(.2)) +
    scale_y_continuous(expand = expansion(.2)) +
    theme_void() +
    theme(panel.background = element_rect(fill = "grey20"))
    ) %>% 
    accumulate(
      10L:1L,
      ~ .x + geom_point(size = .y ^ 1.5, color = viridis_colors[.y]),
      .init = .
    ) 

 for (i in plots) {plot(i)}

 
 
 library(magick)

 # change ggplot2 objects into images
 imgs <- map(1:length(plots), ~{
   img <- image_graph(width = 672, height = 480)
   plot(plots[[.x]])
   dev.off()
   img
 }) 
 
 
 # combine images as frames
 imgs <- image_join(imgs)

 # animate
 
 image_animate(imgs)

 
 #  Example 2: {kableExtra} =======================
 
 library(kableExtra)

 mtcars %>% 
   head() %>% 
   kbl %>% 
   kable_classic(html_font = "Roboto") %>% 
   column_spec(3, background = "skyblue") %>% 
   column_spec(4, background = "forestgreen") %>% 
   column_spec(5, background = "chocolate") 
 
 numbers <- 3:5
 background_colors <- c("skyblue", "forestgreen", "chocolate")
 

 ( mtcars %>% 
     head() %>% 
     kbl() %>% 
     kable_classic(html_font = "Roboto")
 ) %>% 
   reduce(
       1:3,
       ~ .x %>% column_spec(numbers[.y], background = background_colors[.y]),
       .init = .
     ) 
     

     
     
 mtcars %>% 
       head() %>% 
       kbl() %>% 
       kable_classic(html_font = "Roboto") %>%       # No need to wrap in parentheses!
       reduce2(
         3:5,                                          
         c("skyblue", "forestgreen", "chocolate"),  
         ~ column_spec(..1, ..2, background = ..3),  # No need for the pipe!
         .init = .
       )
     
     
     
new_cols <- c("a", "b", "c")

mtcars %>% 
  head() %>% 
  select(mpg) %>% 
  mutate (!!new_cols[1] := NA) %>% 
  mutate (!!new_cols[2] := NA) %>%
  mutate (!!new_cols[3] := NA) 

mtcars %>% 
  head() %>% 
  select(mpg) %>% 
  reduce(
    new_cols,
    ~ mutate(.x, !!.y := NA),
    .init = .
  )

mtcars %>% 
  head() %>% 
  select(mpg) %>% 
  reduce(
    new_cols,
    ~ mutate(.x, !!.y := paste0(.y, "-", row_number())),
    .init = .
  )


mtcars %>% 
  head() %>% 
  select(mpg) %>% 
  reduce(
    pull(., mpg),
    ~ mutate(.x, !!as.character(.y) := .y + mpg),
    .init = .
  )
