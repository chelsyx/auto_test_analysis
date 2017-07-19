#!/usr/bin/env Rscript

if(Sys.info()["nodename"] == "stat1005"){
  .libPaths("/srv/home/chelsyx/R/x86_64-pc-linux-gnu-library/3.3")
}

# Check dependencies:
dependencies <- c(
  "tidyverse", "toOrdinal", "jsonlite", "yaml", "rmarkdown", "wmf", "tools",
  "knitr", "RMySQL", "data.table", "lubridate", "binom", "BCDA", "survival", 
  "survminer"
)

installed <- as.data.frame(installed.packages(), stringsAsFactors = FALSE)
if (any(!dependencies %in% unname(installed$Package))) {
  stop("The following R package(s) are required but are missing: ",
       paste0(dependencies[!dependencies %in% installed$Package], collapse = ", "))
}

# Get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults:
suppressPackageStartupMessages({library("optparse")})
option_list <- list(make_option("--yaml_file", default = "parameters.yaml", action = "store", type = "character",
                                help = "A yaml file with test parameters is needed to generate the report. Default to 'parameters.yaml'."))
opt <- parse_args(OptionParser(option_list = option_list))

report_params <- yaml::yaml.load_file(opt$yaml_file)
if (!dir.exists("reports")) {
  dir.create("reports")
}
output_report_name <- file.path("reports", paste0(gsub("[^a-zA-Z0-9]", "_", report_params$report_title),".html"))
rmarkdown::render("report.Rmd", output_file = output_report_name, params = report_params)
