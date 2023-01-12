# creating folder structure
mkdir -p data results alignment

# creating random reference sequence
Rscript --vanilla R/create_dummy_ref.R

# simulate some drift
slim -s 42 sequence_vcf_output.slim

# fold and align the haplotypes
# (not really aligning here - more pasting them one below the other)
# cat data/ref_dummy.fa > alignment/alignment.fa
for k in $(ls results/*.fa); do 
 fold -w 80 ${k} > ${k%.fa}_f.fa
 sleep .1
 rm ${k}
 cat ${k%.fa}_f.fa >> alignment/alignment.fa
 sleep .1;
done

# create the phylogeny for the selected samples
conda activate popgen 
raxml-ng --msa alignment/alignment.fa --msa-format FASTA --seed 42 --model JC+G 
conda deactivate

# creating random reference sequence
Rscript --vanilla R/plot_phylo.R

# for cleaning
# rm -r data/ results/ alignment/