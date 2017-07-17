# Parameterized A/B Test Report

The idea is to create an A/B test analysis/report template that allows data analysts and search engineers to specify a few parameters in a yaml file and then generate a report that fetches the appropriate data, cleans it up, and runs through the specified metrics. This will not replace the thorough analysis and report with interpretation provided by analysts. It will only serve as an initial peek for the team. The reports only use data from [TestSearchSatisfaction2](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2) currently. See [T131795](https://phabricator.wikimedia.org/T131795) for more details.

## Use

Install the dependencies in R:

```R
install.packages(c("tidyverse", "toOrdinal", "jsonlite", "yaml", "rmarkdown", "tools",
  "knitr", "RMySQL", "data.table", "lubridate", "binom"))
devtools::install_git("https://gerrit.wikimedia.org/r/p/wikimedia/discovery/wmf.git")
devtools::install_github("bearloga/BCDA")
```

Specify parameters in `parameters.yaml`. And then in bash, run:
```
Rscript run.R
```

For each test(assuming the same title would be used in `parameters.yaml`), directory `/data/report_title/` would be created to store the data fetched from MySQL database. The html reports could be found in the `/reports/` directory.

