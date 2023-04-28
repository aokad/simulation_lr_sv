library(tidyverse)
library(cowplot)
library("wesanderson")

source("./plot_conf.R")

D <- read_tsv("../../output/plot/simulation_count_svtype.txt")

D$Method <- factor(D$Method, levels = c("nanomonsv" , "sniffles2", "cuteSV", "delly", "CAMPHORsomatic", "SVIM", "SAVANA"),
    labels = c("nanomonsv", "Sniffles2-based method", "cuteSV-based method", "Delly-based method", "CAMPHORsomatic", "SVIM-based method", "SAVANA"))
#D$Method <- factor(D$Method, levels = c("nanomonsv" , "sniffles2", "cuteSV", "delly", "CAMPHORsomatic", "SVIM"),
#    labels = c("nanomonsv", "Sniffles2-based method", "cuteSV-based method", "Delly-based method", "CAMPHORsomatic", "SVIM-based method"))
D$Yield <- D$Depth * 3

D$Tumor_Purity2 <- factor(as.character(D$Tumor_Purity), 
                          levels = c("0", "20", "40", "60", "80", "100"))

D2 <- D %>% filter(Tumor_Purity != "0") %>% 
  mutate(Precision = TP / (TP + FP + 1), Recall = TP / (TP + FN + 1))

ggplot(D2, 
       aes(x = Yield, y = Precision, group = Tumor_Purity2, colour = Tumor_Purity2)) + 
  geom_line() +
  geom_point() +
  my_theme() +
  theme(legend.position = "bottom",
        panel.grid.major = element_line()) +
  facet_grid(SV_Type~Method) +
  ylim(c(0, 1)) +
  scale_colour_manual(values = wes_palette("Cavalcanti1")) +
  scale_x_continuous(breaks = seq(30, 150, 30)) + 
  labs(x = "Yield (Gbp)", y = "Precision", colour = "Tumor Purity (%)")

ggsave("../../output/plot/simulation_svtype_Precision.pdf", width = 21, height = 20, units = "cm")

ggplot(D2, 
       aes(x = Yield, y = Recall, group = Tumor_Purity2, colour = Tumor_Purity2)) + 
  geom_line() +
  geom_point() +
  my_theme() +
  theme(legend.position = "bottom",
        panel.grid.major = element_line()) +
  facet_grid(SV_Type~Method) +
  ylim(c(0, 1)) +
  scale_colour_manual(values = wes_palette("Cavalcanti1")) +
  scale_x_continuous(breaks = seq(30, 150, 30)) + 
  labs(x = "Yield (Gbp)", y = "Recall", colour = "Tumor Purity (%)")

ggsave("../../output/plot/simulation_svtype_Recall.pdf", width = 21, height = 20, units = "cm")
