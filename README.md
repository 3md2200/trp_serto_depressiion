# Boxplot with Dot Overlay Generator

This repository contains an R script that generates a boxplot with overlaid dot plot (beeswarm-style arrangement) for analyzing node data across three groups: control, canser, and kampo.

## Files

- `generate_boxplot.R` - Main R script that creates the boxplot visualization
- `spinosin_before_claster250813.csv` - Sample data file with group and Nodes columns
- `Total_Nodes.png` - Primary output plot (ggbeeswarm version)
- `Total_Nodes_manual.png` - Alternative output plot (manual beeswarm implementation)

## Requirements

The script requires the following R packages:
- `ggplot2` - For creating the base plot
- `ggbeeswarm` - For the beeswarm dot arrangement

## Data Format

The CSV file should contain:
- `group` column: Integer values (1=control, 2=canser, 3=kampo)
- `Nodes` column: Numeric values for the y-axis

## Usage

1. Ensure R is installed with required packages:
   ```bash
   sudo apt install r-base r-cran-ggplot2 r-cran-ggbeeswarm
   ```

2. Run the script:
   ```bash
   Rscript generate_boxplot.R
   ```

## Plot Specifications

The generated plot includes:
- **Groups**: control (grey #999999), canser (red/pink #D55E5E), kampo (blue/purple #5E7BD5)
- **Style**: Thick black boxplot lines with white fill, overlaid circular dots with black borders
- **Axes**: Y-axis from 0-120 with breaks every 30, large bold labels
- **Output**: 8x8 inches at 300 DPI resolution

## Output

The script generates two versions:
1. **Primary version** using ggbeeswarm package for optimal dot arrangement
2. **Manual version** with custom beeswarm implementation for flexibility

Both files are saved as high-resolution PNG images suitable for publication.