library(tidyverse)
library(wesanderson)

source("./plot_conf.R")

D <- read_tsv("../../output/plot/simulation_count_support.txt")
D$Yield <- D$Depth * 3

D$Yield2 <- factor(as.character(D$Yield), 
                   levels = c(30, 60, 90, 120, 150),
                   labels = c("30 Gbp", "60 Gbp", "90 Gbp", "120 Gbp", "150 Gbp"))

D$Tumor_Purity2 <- factor(as.character(D$Tumor_Purity), 
                          levels = c("0", "20", "40", "60", "80", "100"))

D2 <- D %>% filter(Tumor_Purity != "0") %>% 
  mutate(Precision = TP / (TP + FP + 1), Recall = TP / (TP + FN + 1)) %>%
  gather(key = Measurement, value = Ratio, Precision, Recall) 

ggplot(D2, 
       aes(x = Support_Read, y = Ratio, group = Tumor_Purity2, colour = Tumor_Purity2)) + 
  geom_line() +
  geom_point() +
  my_theme() +
  theme(legend.position = "bottom",
        panel.grid.major = element_line()) +
  facet_grid(Measurement~Yield2) +
  ylim(c(0, 1)) +
  scale_colour_manual(values = wes_palette("Cavalcanti1")) +
  scale_x_continuous(breaks = seq(3, 10, 1)) + 
  labs(x = "Minimum supporting read", y = "Ratio", colour = "Tumor Purity (%)")

ggsave("../../output/plot/simulation_support.pdf", width = 20, height = 8, units = "cm")

  

