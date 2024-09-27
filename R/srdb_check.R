# Checks SRDB data for consistency, columns types, out of bounds, etc.,
# BBL 2019-09-17; updated 2024-09-27

if(basename(getwd()) != "srdb") stop("Working directory must be srdb/")

# Helper functions ---------------------------------------------------------

contiguous <- function(x) all(diff(x) == 1)

check_numeric <- function(d, dname = deparse(substitute(d))) { 
  message("Checking ", dname, " is numeric")
  if(!is.numeric(d)) {
    d[ d == "" ] <- "0"	# don't want blanks to be listed below
    stop(paste(dname, " is not numeric", 
               paste("- in rows: ", paste(which(is.na(as.numeric(d))), collapse = " "))))
  }
  invisible(is.numeric(d))
}
check_bounds <- function(d, lim, dname = deparse(substitute(d))) { 	# d should be within lim
  if(check_numeric(d, dname)) {
    message("Checking ", dname, " in bounds (", lim[ 1 ], ",", lim[ 2 ], ")")
    oob <- d < lim[ 1 ] | d > lim[ 2 ]
    if(any(oob, na.rm = TRUE)) {
      message(paste(dname, " out of bounds (", lim[ 1 ], ",", lim[ 2 ], ")"))
      message(paste("- in rows: ", paste(which(oob), collapse = " ")))
    }
  }
}
check_lesseq <- function(d1, d2) { 	# d1 should be < =  d2
  greater <- d1 > d2
  if(any(greater, na.rm = TRUE)) {
    message(paste(deparse(substitute(d1)), " greater than ", deparse(substitute(d2))))
    message(paste("- in rows: ", paste(which(greater), collapse = " ")))
  }
}
check_labels <- function(d, labs, dname = deparse(substitute(d))) {		# d should be ascending range
  message("Checking ", dname, " in (", paste(labs, collapse = ", "), ")")
  inlabs <- d %in% labs
  if(any(!inlabs, na.rm = TRUE)) {
    message(paste(dname, " not in labels ", paste(labs, collapse = " ")))
    message(paste("- in rows: ", paste(which(!inlabs), collapse = " ")))	
  }
}
check_fieldnames <- function(d, d_info) {
  fnames <- as.character(d_info[ d_info[, 2] !=  "", 2 ]) # Names in the srdb-data_fields.txt file
  ndb <- names(d)
  
  if(identical(sort(ndb), sort(fnames))) {
    message("All names match between data and info files!")
  } else {
    diffs <- union(setdiff(ndb, fnames), setdiff(fnames, ndb))
    stop("Following names do not match between field descriptions file and database:", paste(diffs, collapse = ", "))
  }
}


# Main --------------------------------------------------------------------

message("Welcome to srdb.R")

message("Reading data file...")
srdb <- read.csv("srdb-data.csv", stringsAsFactors = FALSE)
message("Rows = ", nrow(srdb), ", columns = ", ncol(srdb))

message("Reading fields data file...")
srdb_info <- read.csv("srdb-data_fields.txt", sep = ",", comment.char = "#", stringsAsFactors = FALSE)
message("Rows = ", nrow(srdb_info), ", columns = ", ncol(srdb_info))
srdb_info <- srdb_info[-3] # remove descriptions

message("Reading studies data file...")
srdb_studies <- read.csv("srdb-studies.csv", stringsAsFactors = FALSE)
message("Rows = ", nrow(srdb_studies), ", columns = ", ncol(srdb_studies))

message("Reading studies info file...")
srdb_studies_info <- read.csv("srdb-studies_fields.txt", sep = ",", comment.char = "#", stringsAsFactors = FALSE)
message("Rows = ", nrow(srdb_studies), ", columns = ", ncol(srdb_studies))

# Commented out for now--not sure if duplicated rows are allowed
#dupes <- which(duplicated(srdb[c(-1, -2)]))
#if(length(dupes)) {
#  warning("There are ", length(dupes), " duplicated rows")
#}

# Every study number in srdb-data should be in srdb-studies
present <- srdb$Study_number %in% srdb_studies$Study_number
if(any(!present)) {
stop("Study_number values in srdb-data not found in srdb_studies: ",
     paste(unique(srdb$Study_number[!present]), collapse = ", "))
}

# Every study number should be contiguous in the data file
contig_problem <- FALSE
for(st in unique(srdb$Study_number)) {
  x <- which(srdb$Study_number == st)
  if(!contiguous(x)) {
    message("\tStudy ", st, " is not contiguous")
    contig_problem <- TRUE
  }
}
if(contig_problem) stop("Non-contiguous study numbers are probably duplicates")

# srdb-info.txt ---------------------------------------------------------

# The `srdb-info.txt` file should describe all fields.
message("------------------------------------------------------ srdb-info.txt")
check_fieldnames(srdb, srdb_info)


# Field checks ----------------------------------------------------------

with(srdb, {
  message("------------------------------------------------------ srdb-data.csv")

  # `Record_number` links tables and provides reproducibility between versions.
  check_numeric(Record_number)
  rn_nas <- which(is.na(srdb$Record_number))
  if(length(rn_nas)) {
    stop("There are ", length(rn_nas), " empty (NA) Record_number fields")
  }
  rn_dupes <- which(duplicated(srdb$Record_number))
  if(length(rn_dupes)) {
    stop("There are ", length(rn_dupes), " duplicated Record_number fields")
  }
  
  # The `Study_number` field links the data and studies files.
  check_numeric(Study_number)
  study_number_matches <- srdb$Study_number %in% srdb_studies$Study_number
  if(any(!study_number_matches)) {
    stop("There are unknown Study_number values")
  }
  
  check_bounds(Study_midyear, c(1960, 2020))
	check_bounds(YearsOfData, c(1, 99))
	check_bounds(Latitude, c(-90, 90))
	check_bounds(Longitude, c(-180, 180))
	
	# Special check for U.S. studies with mis-entered longitude
	bad_USA <- srdb$Country == "USA" & srdb$Longitude > 0 & srdb$Region != "Guam"
	bad_USA[is.na(bad_USA)] <- FALSE
	if(any(bad_USA)) {
	  stop("'USA' entries with positive longitude: ", 
	       paste(which(bad_USA), collapse = " "))    
	}
	
	check_bounds(Elevation, c(-10, 7999))
	
	# Manipulation is a mess, unfortunately
	controls <- srdb$Manipulation == "Control" | srdb$Manipulation == "CK"
	if(any(controls)) {
	  stop("'Control' or 'CK' entries in Manipulation; should be 'None': ", 
	       paste(which(controls), collapse = " "))    
	}
	
	check_bounds(Age_ecosystem, c(0, 999))
	check_bounds(Age_disturbance, c(0, 999))
	check_labels(Ecosystem_state, c("Managed", "Unmanaged", "Natural", ""))
	
	# Ecosystem_type is also varied
	unmanaged_ag <- srdb$Ecosystem_type == "Agriculture" & srdb$Ecosystem_state != "Managed"
	if(any(unmanaged_ag)) {
		stop("Non-managed agriculture in rows: ", paste(which(unmanaged_ag), collapse = " "))    
	}
	plantation <- srdb$Ecosystem_type == "Plantation"
	if(any(plantation)) {
	  stop("Plantation (should be managed forest) in rows: ", paste(which(plantation), collapse = " "))    
	}
	pasture <- srdb$Ecosystem_type == "Pasture"
	if(any(pasture)) {
	  stop("Pasture (should be managed grassland) in rows: ", paste(which(pasture), collapse = " "))    
	}
	grassland <- srdb$Ecosystem_type %in% c("Steppe", "Meadow")
	if(any(grassland)) {
	  stop("Grassland synonym (should be grassland) in rows: ", paste(which(grassland), collapse = " "))    
	}
	wetland <- srdb$Ecosystem_type %in% c("Swamp", "Marsh", "Bog")
	if(any(wetland)) {
	  stop("Wetland synonym (should be wetland) in rows: ", paste(which(wetland), collapse = " "))    
	}

	check_labels(Soil_drainage, c("Dry", "Wet", "Medium", "Mixed", ""))
	check_bounds(Soil_BD, c(0.01, 99.9))
	check_bounds(Soil_CN, c(0.01, 99.9))
	check_bounds(Soil_sand, c(0.0, 999.9))
	check_bounds(Soil_silt, c(0.0, 999.9))
	check_bounds(Soil_clay, c(0.0, 999.9))
	check_bounds(MAT, c(-30, 55))
	check_bounds(MAP, c(0, 9999))
	check_bounds(PET, c(0, 9999))
	check_bounds(Study_temp, c(-30, 46))
	check_bounds(Study_precip, c(0, 9999))
	# TODO: meas_method one of a few values
	check_bounds(Meas_interval, c(0.01, 365))
	check_bounds(Annual_coverage, c(0.01, 1))
	check_bounds(Collar_height, c(0, 100))
	check_bounds(Collar_depth, c(0, 100))
	check_bounds(Chamber_area, c(1, 10000))
	
	# TODO: Partition_method one of a few values

	check_bounds(Rs_annual, c(-200, 25000))
	check_bounds(Rs_annual_err, c(0, 5500))
	check_bounds(Rs_interann_err, c(0, 5500))
	# TODO: check following don't exceed Rs_annual
	check_bounds(Rlitter_annual, c(0, 5000))
	check_bounds(Ra_annual, c(-16, 5000))
	check_bounds(Rh_annual, c(-120, 5000))
	check_lesseq(Rlitter_annual, Rs_annual)
	# TODO: following two checks fail because some studies do have such values
	# check_lesseq(Ra_annual, Rs_annual)
	# check_lesseq(Rh_annual, Rs_annual)
	check_bounds(RC_annual, c(-0.05, 1.15))
	check_bounds(Rs_spring, c(0, 100))
	check_bounds(Rs_summer, c(0, 100))
	check_bounds(Rs_autumn, c(0, 100))
	check_bounds(Rs_winter, c(0, 100))
	check_bounds(Rs_growingseason, c(0, 100))
	check_bounds(Rs_wet, c(0, 100))
	check_bounds(Rs_dry, c(0, 100))
	check_bounds(RC_seasonal, c(0, 1))
	# TODO: RC_season one of a few values
 
 	# TODO: equation, Q10 checks
 
	check_bounds(GPP, c(0, 9999))
	check_bounds(ER, c(0, 9999))
	check_bounds(NEP, c(-9999, 9999))
	check_bounds(NPP, c(0, 9999))
	check_bounds(ANPP, c(0, 9999))
	check_bounds(BNPP, c(0, 9999))
	check_bounds(NPP_FR, c(0, 9999))
	check_lesseq(ANPP, NPP)
	check_lesseq(BNPP, NPP)
	check_lesseq(NPP_FR, BNPP)

	check_bounds(TBCA, c(0, 9999))
	check_bounds(Litter_flux, c(0, 9999))
	check_bounds(Rootlitter_flux, c(0, 9999))
	check_bounds(TotDet_flux, c(0, 9999))
	# TODO: trips
	# check_lesseq(Litter_flux + Rootlitter_flux, TotDet_flux)

	check_bounds(Ndep, c(0, 999))
	check_bounds(LAI, c(0, 99))
	check_bounds(BA, c(0, 999))
	check_bounds(C_veg_total, c(0, 99999))
	check_bounds(C_AG, c(0, 999999))
	check_bounds(C_BG, c(0, 99999))
	check_bounds(C_CR, c(0, 99999))
	check_bounds(C_FR, c(0, 99999))
	check_lesseq(C_CR + C_FR, C_BG)
	# TODO: trips
	# check_lesseq(C_AG + C_BG, C_veg_total)	
	check_bounds(C_litter, c(0, 99999))
	check_bounds(C_soilmineral, c(0, 999999))
	check_bounds(C_soildepth, c(0, 200))

})


message("------------------------------------------------------ land check")
# Check whether studies are all on land or not

# TODO: having trouble installing ncdf4 on Travis, will deal with it later
# Commenting out the following for now

# library(raster)
# srdb_spatial <- subset(srdb, !is.na(Latitude) & !is.na(Longitude))
# sp <- SpatialPoints(cbind(srdb_spatial$Longitude, srdb_spatial$Latitude))
# landmask <- brick("R/fractional_land.0.5-deg.nc")
# srdb_spatial$landfrac <- extract(rotate(raster(landmask, 1)), sp)
# srdb_spatial$landfrac_cut <- cut(srdb_spatial$land, 4)
# 
# message("Checking points fall on land...")
# if(sum(srdb_spatial$landfrac <= 0.1, na.rm = TRUE)) {
#   notonland <- srdb_spatial$Record_number[srdb_spatial$landfrac < 0.05]
#   message(paste("- low-land records:", paste(notonland, collapse = " ")))
# }

message("All done.")
