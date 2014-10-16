# This is a test to check if column names in database correspond to field descriptions.
# Good idea by Carlos Sierra 10/2014

srdb <- read.csv("srdb-data.csv")
txt <- read.table("srdb-data_fields.txt", sep=",")

txt <- as.character(txt[txt[,2]!="",2]) # Names in the srdb-data_fields.txt file
ndb <- names(srdb) # Column names in database

if(all(ndb==txt)) {
	print("All names match!")
} else {
	print("Following names do not match between field descriptions file and database:")

	# Test correspondance between names in database and in description file
	print(ndb==txt)

	# Compare both
	print(cbind(ndb,txt))

	# Show names that do not match
	print(c(rownumber=which(ndb!=txt),data=ndb[which(ndb!=txt)],descrip=txt[which(ndb!=txt)]))
}
