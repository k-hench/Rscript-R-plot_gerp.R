library(tidyverse)
library(ggtree)

data <- ape::read.tree("alignment/alignment.fa.raxml.bestTree") |> ape::root.phylo(outgroup = "final_reference_seq")
p1 <- ggtree(data) +
  geom_tiplab()  +
  scale_x_continuous(expand = c(.001,.004))

ggsave(plot = p1, "phylo.svg")
