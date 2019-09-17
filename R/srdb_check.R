# Run basic checks on SRDB data
# BBL 2019-09-14

srdb <- read.csv("srdb-data.csv", stringsAsFactors = FALSE)

# -------------------------------------------------------------------------
# The `Record_number` field is crucial, linking a variety of tables and
# providing reproducibility between versions.
 
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
