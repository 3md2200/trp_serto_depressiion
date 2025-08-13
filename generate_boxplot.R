#!/usr/bin/env Rscript

# R script to generate boxplot with dot overlay similar to Total_Nodes.png
# Author: Generated for trp_serto_depression analysis
# Requirements: ggplot2, ggbeeswarm packages

# Load required libraries
library(ggplot2)
library(ggbeeswarm)

# Read data
data <- read.csv("spinosin_before_claster250813.csv")

# Process group column (recode 1="control", 2="canser", 3="kampo")
data$group_labels <- factor(data$group, 
                           levels = c(1, 2, 3),
                           labels = c("control", "canser", "kampo"))

# Define colors
group_colors <- c("control" = "#999999",   # Grey
                  "canser" = "#D55E5E",    # Red/pink  
                  "kampo" = "#5E7BD5")     # Blue/purple

# Create the main plot using ggbeeswarm
create_ggbeeswarm_plot <- function() {
  p <- ggplot(data, aes(x = group_labels, y = Nodes, fill = group_labels, color = group_labels)) +
    # Add boxplot
    geom_boxplot(aes(fill = group_labels), 
                 color = "black",
                 linewidth = 2,
                 alpha = 0,  # Transparent fill for boxplot
                 outlier.shape = NA,  # Remove outliers from boxplot
                 width = 0.6) +
    # Add beeswarm dots
    ggbeeswarm::geom_beeswarm(aes(fill = group_labels),
                              color = "black",
                              size = 4,
                              alpha = 0.8,
                              stroke = 0.5,
                              shape = 21,  # Circle with both fill and color
                              cex = 2.5) +  # Adjust spacing
    # Set colors
    scale_fill_manual(values = group_colors) +
    scale_color_manual(values = group_colors) +
    # Set y-axis scale
    scale_y_continuous(limits = c(0, 120),
                       breaks = seq(0, 120, 30),
                       expand = c(0.02, 0)) +
    # Labels
    labs(x = "",
         y = "Number") +
    # Theme settings
    theme_classic() +
    theme(
      # Remove legend
      legend.position = "none",
      # Axis labels styling
      axis.title.y = element_text(size = 32, face = "bold", color = "black"),
      axis.text.x = element_text(size = 28, face = "bold", color = "black"),
      axis.text.y = element_text(size = 24, face = "bold", color = "black"),
      # Axis lines
      axis.line = element_line(color = "black", linewidth = 2),
      axis.ticks = element_line(color = "black", linewidth = 1.5),
      axis.ticks.length = unit(0.3, "cm"),
      # Panel settings
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      # Margins
      plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
    )
  
  return(p)
}

# Manual beeswarm implementation (alternative version)
create_manual_beeswarm_plot <- function() {
  # Calculate beeswarm positions manually
  calc_beeswarm_pos <- function(y_values, group_pos, width = 0.4) {
    n <- length(y_values)
    if (n == 0) return(numeric(0))
    
    # Sort y values to arrange dots systematically
    order_idx <- order(y_values)
    sorted_y <- y_values[order_idx]
    
    # Calculate x positions - simple column arrangement
    x_positions <- rep(group_pos, n)
    if (n > 1) {
      # Create multiple columns if needed
      cols <- ceiling(sqrt(n))
      col_width <- width / cols
      for (i in 1:n) {
        col <- ((i - 1) %% cols) + 1
        x_offset <- (col - (cols + 1) / 2) * col_width
        x_positions[order_idx[i]] <- group_pos + x_offset
      }
    }
    
    return(x_positions)
  }
  
  # Calculate positions for each group
  data$x_pos <- NA
  for (i in 1:3) {
    group_data <- data[data$group == i, ]
    if (nrow(group_data) > 0) {
      x_positions <- calc_beeswarm_pos(group_data$Nodes, i, width = 0.4)
      data[data$group == i, "x_pos"] <- x_positions
    }
  }
  
  p <- ggplot(data, aes(x = group_labels, y = Nodes)) +
    # Add boxplot
    geom_boxplot(aes(fill = group_labels), 
                 color = "black",
                 linewidth = 2,
                 alpha = 0,  # Transparent fill
                 outlier.shape = NA,
                 width = 0.6) +
    # Add manual beeswarm dots
    geom_point(aes(x = x_pos, y = Nodes, fill = group_labels),
               color = "black",
               size = 4,
               alpha = 0.8,
               stroke = 0.5,
               shape = 21) +
    # Set colors
    scale_fill_manual(values = group_colors) +
    # Set y-axis scale
    scale_y_continuous(limits = c(0, 120),
                       breaks = seq(0, 120, 30),
                       expand = c(0.02, 0)) +
    # Set x-axis
    scale_x_discrete(expand = c(0.1, 0)) +
    # Labels
    labs(x = "",
         y = "Number") +
    # Theme settings
    theme_classic() +
    theme(
      legend.position = "none",
      axis.title.y = element_text(size = 32, face = "bold", color = "black"),
      axis.text.x = element_text(size = 28, face = "bold", color = "black"),
      axis.text.y = element_text(size = 24, face = "bold", color = "black"),
      axis.line = element_line(color = "black", linewidth = 2),
      axis.ticks = element_line(color = "black", linewidth = 1.5),
      axis.ticks.length = unit(0.3, "cm"),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
    )
  
  return(p)
}

# Generate and save the plot using ggbeeswarm (primary version)
cat("Creating plot with ggbeeswarm package...\n")
plot_ggbeeswarm <- create_ggbeeswarm_plot()

# Save the plot
png("Total_Nodes.png", width = 8, height = 8, units = "in", res = 300)
print(plot_ggbeeswarm)
dev.off()

cat("Plot saved as Total_Nodes.png (8x8 inches, 300 DPI)\n")

# Also create manual version for comparison (optional)
cat("Creating plot with manual beeswarm implementation...\n")
plot_manual <- create_manual_beeswarm_plot()

# Save manual version with different name
png("Total_Nodes_manual.png", width = 8, height = 8, units = "in", res = 300)
print(plot_manual)
dev.off()

cat("Manual implementation saved as Total_Nodes_manual.png\n")

# Print summary statistics
cat("\nData summary:\n")
print(table(data$group_labels))
cat("\nNodes statistics by group:\n")
print(aggregate(Nodes ~ group_labels, data, summary))

cat("\nScript completed successfully!\n")