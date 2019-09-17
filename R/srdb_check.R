# Run basic checks on SRDB data
# BBL 2019-09-14


# -----------------------------------------------------------------------------
# Logging function
printlog <- function(msg, ..., ts = TRUE, cr = TRUE) {
  if(ts) cat(date(), " ")
  cat(msg, ...)
  if(cr) cat("\n")
}

# -----------------------------------------------------------------------------
# Error checking

# Helper functions to check various field attributes
check_numeric <- function(d, dname = deparse(substitute(d))) { 
  printlog("Checking", dname, "is numeric")
  if(!is.numeric(d)) {
    message(paste(dname, "is not numeric"))
    d[ d == "" ] <- "0"	# don't want blanks to be listed below
    message(paste("- in records:", paste(which(is.na(as.numeric(d))), collapse = " ")))
  }
  invisible(is.numeric(d))
}
check_bounds <- function(d, lim, dname = deparse(substitute(d))) { 	# d should be within lim
  if(check_numeric(d, dname)) {
    printlog("Checking", dname, "in bounds (", lim[ 1 ], ",", lim[ 2 ], ")")
    oob <- d < lim[ 1 ] | d > lim[ 2 ]
    if(any(oob, na.rm = TRUE)) {
      message(paste(dname, "out of bounds (", lim[ 1 ], ",", lim[ 2 ], ")"))
      message(paste("- in records:", paste(which(oob), collapse = " ")))
    }
  }
}
check_lesseq <- function(d1, d2) { 	# d1 should be < =  d2
  greater <- d1 > d2
  if(any(greater, na.rm = TRUE)) {
    message(paste(deparse(substitute(d1)), "greater than", deparse(substitute(d2))))
    message(paste("- in records:", paste(which(greater), collapse = " ")))
  }
}
check_labels <- function(d, labs, dname = deparse(substitute(d))) {		# d should be ascending range
  printlog("Checking", dname, "in (", paste(labs, collapse = ", "), ")")
  inlabs <- d %in% labs
  if(any(!inlabs, na.rm = TRUE)) {
    message(paste(dname, "not in labels", paste(labs, collapse = " ")))
    message(paste("- in records:", paste(which(!inlabs), collapse = " ")))	
  }
}
check_fieldnames <- function(d, d_info) {
  fnames <- as.character(d_info[ d_info[, 2] !=  "", 2 ]) # Names in the srdb-data_fields.txt file
  ndb <- names(d)
  
  if(all(ndb == fnames)) {
    printlog("All names match between data and info files!")
  } else {
    printlog("Following names do not match between field descriptions file and database:")
    mismatch <- ndb !=  fnames
    warning(c(rownumber = which(mismatch), data = ndb[ which(mismatch) ],
              descrip = fnames[ which(mismatch) ]))
  }
}


# -----------------------------------------------------------------------------
# Main program

printlog("Welcome to srdb.R")

printlog("Reading data file...")
srdb <- read.csv("srdb-data.csv", stringsAsFactors = FALSE)
printlog("Rows =", nrow(srdb), "columns =", ncol(srdb))

printlog("Reading fields data file...")
srdb_info <- read.csv("srdb-data_fields.txt", sep = ",", comment.char = "#", stringsAsFactors = FALSE)
printlog("Rows =", nrow(srdb_info), "columns =", ncol(srdb_info))
srdb_info <- srdb_info[-3] # remove descriptions

printlog("Reading studies data file...")
srdb_studies <- read.csv("srdb-studies.csv", stringsAsFactors = FALSE)
printlog("Rows =", nrow(srdb_studies), "columns =", ncol(srdb_studies))


# -----------------------------------------------------------------------------
# `Record_number` links tables and provides reproducibility between versions.
 
printlog("Checking Record_number")
rn_nas <- which(is.na(srdb$Record_number))
if(length(rn_nas)) {
  warning("There are ", length(rn_nas), " empty (NA) Record_number fields")
}

rn_dupes <- which(duplicated(srdb$Record_number))
if(length(rn_dupes)) {
  warning("There are ", length(rn_dupes), " duplicated Record_number fields")
}

# Commented out for now--not sure if duplicated rows are allowed
#dupes <- which(duplicated(srdb[-1]))
#if(length(dupes)) {
#  warning("There are ", length(dupes), " duplicated rows")
#}

# -----------------------------------------------------------------------------
# The `Study_number` field links the data and studies files.

printlog("Checking Study_number")
sn_unknown <- which(! srdb$Study_number %in% srdb_studies$Study_number)
if(length(sn_unknown)) {
  warning("There are ", length(sn_unknown), " unknown Study_number values")
}


# -----------------------------------------------------------------------------
# The `srdb-info.txt` file should describe all fields.
check_fieldnames(srdb, srdb_info)
