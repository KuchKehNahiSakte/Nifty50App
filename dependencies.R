# dependencies.R

# List of required packages
required_packages <- c("shiny", "quantmod", "DT", "lubridate", "dplyr", "plotly", "ggplot2")

# Function to check and install missing packages
check_and_install <- function(package_name) {
  if (!requireNamespace(package_name, quietly = TRUE)) {
    install.packages(package_name)
  }
}

# Install missing packages
lapply(required_packages, check_and_install)

# Load required packages
lapply(required_packages, library, character.only = TRUE)
