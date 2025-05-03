# Plot database growth over time
# BBL 2024-09-30

if(basename(getwd()) != "srdb") stop("Working directory must be srdb/")

library(ggplot2)
theme_set(theme_bw())
library(scales)
library(dplyr)
library(tidyr)

read.csv("srdb-data.csv") %>% 
  mutate(Y = as.integer(substr(Entry_date, 1, 4))) ->
  x

x %>%
  group_by(Y) %>% 
  summarise(N = n()) %>% 
  mutate(type = "Total records") ->
  x1

x %>% 
  filter(Manipulation == "None", !is.na(Rs_annual)) %>% 
  group_by(Y) %>% 
  summarise(N = n()) %>% 
  mutate(type = "Rs_annual, no manipulation") ->
  x2

x %>% 
  filter(Manipulation == "None", !is.na(Rh_annual)) %>% 
  group_by(Y) %>% 
  summarise(N = n()) %>% 
  mutate(type = "Rh_annual, no manipulation") ->
  x3

x %>% 
  filter(Manipulation == "None", !is.na(Rs_growingseason)) %>% 
  group_by(Y) %>% 
  summarise(N = n()) %>% 
  mutate(type = "Rs_growingseason, no manipulation") ->
  x4

bind_rows(x1, x2, x3, x4) %>% 
  complete(Y = 2008:2024, type, fill = list(N = 0)) %>% 
  arrange(Y) %>% 
  group_by(type) %>% 
  mutate(cum_N = cumsum(N)) ->
  x_final

p <- ggplot(x_final, aes(Y, cum_N, color = type)) + 
  geom_line(linewidth = 1) +
  xlab("Year of entry") + ylab("Database entries") +
  scale_color_discrete("") +
  scale_y_continuous(labels = comma) +
  theme(legend.position = "inside", 
        legend.position.inside = c(0.3, 0.85),
        legend.background = element_blank())
print(p)
ggsave("R/growth_plot.png", width = 8, height = 5)
