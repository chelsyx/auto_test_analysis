#!/usr/bin/env Rscript

# Check dependencies:
dependencies <- c(
  "tidyverse", "toOrdinal", "jsonlite", "yaml", "rmarkdown", "wmf", "tools",
  "knitr", "RMySQL", "data.table", "lubridate", "binom", "BCDA"
)

installed <- as.data.frame(installed.packages(), stringsAsFactors = FALSE)
if (any(!dependencies %in% unname(installed$Package))) {
  stop("The following R package(s) are required but are missing: ",
       paste0(dependencies[!dependencies %in% installed$Package], collapse = ", "))
}

report_params <- yaml::yaml.load_file("parameters.yaml")
if (!dir.exists("reports")) {
  dir.create("reports")
}
output_report_name <- file.path("reports", paste0(gsub("[^a-zA-Z0-9]", "_", report_params$report_title),".html"))
rmarkdown::render("report.Rmd", output_file = output_report_name, params = report_params)
