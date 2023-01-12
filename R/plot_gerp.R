library(tidyverse)
library(patchwork)
library(prismatic)
clr <- "gray40"

anno <- read_tsv("results/ref_sim.bed", col_names = c("seq", "start", "end", "type"))
gerp <- read_tsv("gerp/final_reference_seq.gerp.final.bed") |> 
  mutate(pos = (start+end)/2) |> 
  rename(gerp = "GERP_RejSubstScore")

phylop <-  read_tsv("gerp/final_reference_seq.phylop.final.bed") |> 
  mutate(pos = (start+end)/2) |> 
  rename(log_p = "phyloP_-log_pvalue")

w_size <- 15
gerp_w <- gerp |> 
  mutate(win = pos %/% w_size) |> 
  group_by(win) |> 
  summarise(gerp = mean(gerp),
            pos = mean(pos)) |> 
  ungroup()

phylop_w <- phylop |> 
  mutate(win = pos %/% w_size) |> 
  group_by(win) |> 
  summarise(log_p = mean(log_p),
            pos = mean(pos)) |> 
  ungroup()


p1 <- gerp_w |> 
  ggplot() +
   geom_point(aes(y = gerp,
                  x = pos),
              size = .2, alpha = .5) +
  geom_smooth(aes(y = gerp,
                     x = pos),
                 size = .2, 
              color = clr,
              fill = clr_lighten(clr, .7))  +
  labs(subtitle = "GERP")

p2 <- phylop_w |> 
  ggplot() +
  geom_point(aes(y = log_p,
                 x = pos),
             size = .2, alpha = .5) +
  geom_smooth(aes(y = log_p,
                  x = pos),
              size = .2, 
              color = clr,
              fill = clr_lighten(clr, .7)) +
  labs(subtitle = "phylo p")

p <- ((p1 + p2) &
  geom_linerange(data = anno,
                 aes(y = -Inf, xmin = start, xmax = end, color = type),
                 linewidth = 7, alpha = .6) &
  rcartocolor::scale_color_carto_d(palette = "SunsetDark",
                                   direction = -1) &
  theme_minimal() &
  theme(legend.position = "bottom",
        plot.subtitle = element_text(hjust = .5))) +
  plot_layout(guides = "collect")

ggsave("gerp_scores.svg", plot = p, width = 8, height = 4)
