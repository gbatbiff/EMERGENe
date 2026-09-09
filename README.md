# EMERGENe - estimating emergence rate of bacterial traits of epidemiological interest

## Introduction
This package estimates the emergence rate of traits of epidemiological interest pairing ancestral state reconstruction and phyletic patterns of phylogenetic tree shape

## Pipeline description

- An ancestral state reconstruction is performed through stochastic character mapping using the ”make.simmap” function from the R package ”phytools” (Revell L, 2024).        Internal phylogenetic tree nodes that experienced a shift between the states i.e. when a trait is gained are spotted.
- Once that the history of a trait is reconstructed, the number of introductions of the trait across the population are detected, intended as Phyletic event
- Once a parent node is detected, its children node with opposite state become the MRCA and a sub-tree is generated. Then, the Entry rate is calculated based on
  the branch distance between the parent node and its child with opposite state i.e. branch duration associated with the trait introduction, where a transition between       demes occurs
- Finally, the Emergence Rate is computed, indicating the propagation time of the trait in the population that descend from the initial node that experienced a shift         between the states. (See methods section for details) 

EMERGENe is intended to estimate emergence of gained trait only, where their prevalence in the population is high i.e. the trait is ≥50% proportional presence. 
It doesn't account for loss events. 

## Installation
### Requirements
- Linux-based OS
- conda 

### Installation command

```bash
git clone https://github.com/gbatbiff/Emergene.git
cd EMERGENe/
conda env create -f environment.yml
conda activate EMERGENe
```
## Quick guide
The standard inputs are a time scaled phylogenetic tree (Bacdating, BEAST...), and the output from AMRFinder

The command with default settings is:
```bash
Rscript EMERGENe.R -t [treefile] -amr [AMRFinderPlus_output_table]
```
## Filtering options

The following options can be used to filter phyletic events and AMR genes during the analysis.

| Option | Type | Default | Description |
|---|---|---:|---|
| `-min_node_state_prob <numeric>` | Numeric | `0.8` | Minimum node state probability of the parent node where a phyletic event is detected. |
| `-min_clade_tips <integer>` | Integer | `2` | Minimum number of tips in the clade descending from the parent node. |
| `-amr_coverage <numeric>` | Numeric | `100` | Minimum percentage coverage threshold for AMR genes reported by AMRFinderPlus. |
| `-amr_identity <numeric>` | Numeric | `99` | Minimum percentage identity threshold for AMR genes reported by AMRFinderPlus. |
| `-nsim <integer>` | Integer | `100` | Number of simulations used for ancestral state reconstruction. |

Increasing `nsim` can affect significantly the computational time when performing the ancestral state reconstruction

### Notes

The tree labels need to match the strain names of AMRFinder output table!!!

### Test run
```bash
Rscript emergene_test_run.R -t test/phylo/tree.nex -amr test/metadata/amr.csv
```

## EMERGENe output summary
The main `summary.csv` output is a table summarising all the events (e.g. multiple rates for each trait) detected across the phylogenetic tree, with the following informations:

- `amr` - resistance/virulence genes identified by AMRFinder
- `node_lineages` - number of internal nodes descendants that gained the trait
- `tip_lineages` - number of terminal tips descendants that gained the trait
- `poly_parent` - internal node that experienced a phyletic event i.e. a shift between states where a trait is gained
- `polyphyly` - number of phyletic events
- `coalescent_interval` - branching distance calculated from phyletic parent node and its descendants
- `poly_parent_nodeheight` - node height (age) of the phyletic node
- `entry_rate` - trait introduction (see method section for details)
- `R_vs_S_prop` - percentage of descendants of the phyletic node that carry the trait
- `poly_parent_state_prob` - ancestral state probability of character assignment (Default >0.8)
- `emergence_rate` - post-introduction trait propagation (see method section for details)

###
An additional output `aggregated_rates.csv` is provided, showing the cumulative indexes (Phyletic events, Entry rate and Emergence rate) calculated for each trait:

The analysis produces a table summarizing the detected phyletic events, entry rates, and emergence rates for each trait.

| trait | phyletic_events | entry_rate | emergence_rate |
|---|---:|---:|---:|
| `blaCTX-M-15` | 3 | 21.2 | 143.76 |
| `blaTEM-1` | 1 | 8.6 | 600.54 |
| `qnrS` | 2 | 1.8 | 38.08 |

### Citation

