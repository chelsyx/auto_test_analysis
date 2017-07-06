# PaulScore Calculation
query_score <- function(positions, F) { # 0-based positions
  if (length(positions) == 1 || all(is.na(positions))) {
    # no clicks were made
    return(0)
  } else {
    positions <- positions[!is.na(positions)] # when operating on 'events' dataset, searchResultPage events won't have positions
    return(sum(F^positions))
  }
}

safe_ordinals <- function(x) {
  return(vapply(x, toOrdinal::toOrdinal, ""))
}
