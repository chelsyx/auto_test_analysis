# Parameterized A/B Test Report

The idea is to create an A/B test analysis/report template that allows data analysts and search engineers to specify a few parameters in a yaml file and then generate a report that fetches the appropriate data, cleans it up, and runs through the specified metrics. This will not replace the thorough analysis and report with interpretation provided by analysts. It will only serve as an initial peek for the team. The reports only use data from [TestSearchSatisfaction2](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2) currently. See [T131795](https://phabricator.wikimedia.org/T131795) for more details.

## Use

Install the dependencies in R:

```R
install.packages(c("tidyverse", "toOrdinal", "jsonlite", "yaml", "rmarkdown", "tools",
  "knitr", "RMySQL", "data.table", "lubridate", "binom", "survival", "survminer", "import"))
devtools::install_git("https://gerrit.wikimedia.org/r/p/wikimedia/discovery/wmf.git")
devtools::install_git("https://gerrit.wikimedia.org/r/p/wikimedia/discovery/polloi.git")
devtools::install_github("bearloga/BCDA")
```

The reports could be run on local machine and analytic clusters (stat1005). If you want to use it on local machine, check [here](https://people.wikimedia.org/~bearloga/notes/rnotebook-eventlogging.html) for MySQL configuration.

Specify parameters in a yaml file. By default, `parameters.yaml` will be used. And then in bash, run:
```
Rscript run.R --yaml_file=/path/to/your/file.yaml
```

For each test (assuming report title remains the same), a directory named `/data/report_title/` would be created to store the data fetched from MySQL database. The HTML reports could be found in the `/reports/` directory. With `--publish`, the report can be viewed at https://analytics.wikimedia.org/datasets/discovery/reports/your_report_title.html. If you want to publish the report from local machine, you have to provide your LDAP username by `--username=your_LDAP_username` (default to NULL).
