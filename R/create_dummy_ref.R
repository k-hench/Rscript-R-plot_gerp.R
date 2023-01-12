library(tidyverse)

n <- 20820

seqs <- tibble(pos = 1:n,
       base = sample(c("A", "T", "G", "C"),
                     replace = TRUE,
                     size = n)) |> 
  mutate(line = (row_number() - 1) %/% 80) |> 
  group_by(line) |> 
  summarise(seq = str_c(base, collapse = ""))

write_lines(">head_dummy_1", file = "data/ref_dummy.fa")
seqs$seq |> 
  walk(.f = \(s){ write_lines(s, file = "data/ref_dummy.fa", append = TRUE) })
