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

safe_ordinals <- function(x) {
  na_mask <- is.na(x)
  output <- rep(NA, length(x))
  output[!na_mask] <- vapply(x[!na_mask], toOrdinal::toOrdinal, "")
  return(output)
}

# Parse extraParams
parse_extraParams <- function(extraParams, action){
  if (extraParams == "{}") {
    if (all(action %in% c("hover-on", "hover-off"))){
      return(list(hoverId = NA, section = NA, results = NA))
    } else if (all(action %in% c("esclick"))){
      return(list(hoverId = NA, section = NA, result = NA))
    } else if (all(action %in% c("searchResultPage"))){
      return(list(offset = NA, iw = list(source = NA, position = NA)))
    } else{
      return(NA)
    }
  } else{
    if (all(action %in% c("searchResultPage"))) {
      output <- jsonlite::fromJSON(txt = as.character(extraParams))
      offset <- if (is.null(output$offset)) NA else output$offset
      iw <- if (is.null(output$iw)) list(source = NA, position = NA) else output$iw
      return(list(offset = offset, iw = iw))
    } else{ # "hover-on", "hover-off", "esclick"
      return(jsonlite::fromJSON(txt = as.character(extraParams)))
    }
  }
}
