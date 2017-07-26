# PaulScore Calculation
query_score <- function(positions, F) { # 0-based positions
  if (length(positions) == 1 || all(is.na(positions))) {
    # no clicks were made
    return(0)
  } else {
    positions <- positions[!is.na(positions)] # when operating on 'events' dataset, searchResultPage events won't have positions
    return(sum(F ^ positions))
  }
}

# Bootstrapping
bootstrap_mean <- function(x, m, seed = NULL) {
  if (!is.null(seed)) {
    set.seed(seed)
  }
  n <- length(x)
  return(replicate(m, mean(x[sample.int(n, n, replace = TRUE)])))
}

# String utils
safe_ordinals <- function(x) {
  na_mask <- is.na(x)
  output <- rep(NA, length(x))
  output[!na_mask] <- vapply(x[!na_mask], toOrdinal::toOrdinal, "")
  return(output)
}
pluralize <- function(singular, n) {
  plural <- paste0(singular, "s") # TODO: logic for ending
  return(c(singular, plural)[(n != 1) + 1])
}
Pluralize <- function(n, singular) {
  return(paste(n, pluralize(singular, n)))
}

# Parse extraParams
parse_extraParams <- function(extraParams, action){
  if (extraParams == "{}") {
    if (all(action %in% c("hover-on", "hover-off"))) {
      return(list(hoverId = NA, section = NA, results = NA))
    } else if (all(action %in% c("esclick"))) {
      return(list(hoverId = NA, section = NA, result = NA))
    } else if (all(action %in% c("searchResultPage"))) {
      return(list(offset = NA, iw = list(source = NA, position = NA)))
    } else {
      return(NA)
    }
  } else {
    if (all(action %in% c("searchResultPage"))) {
      output <- jsonlite::fromJSON(txt = as.character(extraParams), simplifyVector = TRUE)
      offset <- polloi::data_select(is.null(output$offset), NA, output$offset)
      iw <- polloi::data_select(is.null(output$iw), list(source = NA, position = NA), output$iw)
      return(list(offset = offset, iw = iw))
    } else {
      # "hover-on", "hover-off", "esclick"
      return(jsonlite::fromJSON(txt = as.character(extraParams), simplifyVector = TRUE))
    }
  }
}

# ggplot themes
theme_min <- function(base_family = "", ...) {
  ggplot2::theme_minimal(base_size = 12, base_family = base_family) +
    ggplot2::theme(legend.position = "bottom", strip.placement = "outside", ...)
}
theme_facet <- function(base_family = "", border = TRUE, clean_xaxis = FALSE, ...) {
  theme <- theme_min(base_family = base_family, ...) +
    ggplot2::theme(strip.background = element_rect(fill = "gray90"))
  if (border) {
    theme <- theme + ggplot2::theme(panel.border = element_rect(color = "gray30", fill = NA))
  }
  if (clean_xaxis) {
    theme <- theme +
      ggplot2::theme(
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()
      )
  }
  return(theme)
}
