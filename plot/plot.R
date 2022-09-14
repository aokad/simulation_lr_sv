library(tidyverse)
library(cowplot)
library("wesanderson")

source("./plot_conf.R")

D <- read_tsv("../output/plot/simulation_count.txt")
D$Method <- factor(D$Method, levels = c("nanomonsv" , "sniffles2", "delly", "cuteSV", "CAMPHORsomatic"),
    labels = c("nanomonsv", "Sniffles2", "delly", "cuteSV", "CAMPHORsomatic"))
D$Yield <- D$Depth * 3

D$Tumor_Purity2 <- factor(as.character(D$Tumor_Purity), 
                          levels = c("0", "20", "40", "60", "80", "100"))

D2 <- D %>% filter(Tumor_Purity != "0") %>% 
  mutate(Precision = TP / (TP + FP), Recall = TP / (TP + FN)) %>%
  gather(key = Measurement, value = Ratio, Precision, Recall) 


ggplot(D2, 
       aes(x = Yield, y = Ratio, group = Tumor_Purity2, colour = Tumor_Purity2)) + 
  geom_line() +
  geom_point() +
  my_theme() +
  theme(legend.position = "bottom",
        panel.grid.major = element_line()) +
  facet_grid(Measurement~Method) +
  ylim(c(0, 1)) +
  scale_colour_manual(values = wes_palette("Cavalcanti1")) +
  scale_x_continuous(breaks = seq(30, 150, 30)) + 
  labs(x = "Yield (Gbp)", y = "Precision", colour = "Tumor Purity (%)")


# p2 <- ggplot(D %>% filter(Tumor_Purity2 != "0"), 
#        aes(x = Yield, y = TP / (TP + FN), group = Tumor_Purity2, colour = Tumor_Purity2)) + 
#   geom_line() +
#   geom_point() +
#   my_theme() +
#   theme(panel.grid.major = element_line()) +
#   facet_grid(.~Method) +
#   ylim(c(0, 1)) +
#   scale_colour_manual(values = wes_palette("Cavalcanti1")) +
#   scale_x_continuous(breaks = seq(30, 150, 30)) +
#   labs(x = "Yield (Gbp)", y = "Recall", colour = "Tumor Purity (%)")

# plegend <- get_legend(p1 + theme(legend.position = "bottom") + guides(color = guide_legend(nrow = 1)))

# plot_grid(p1 + guides(color = FALSE), 
#           p2 + guides(color = FALSE), 
#           plegend, nrow = 3, rel_heights = c(4.7, 4.7, 0.6))

ggsave("../output/plot/simulation.pdf", width = 25, height = 8, units = "cm")



