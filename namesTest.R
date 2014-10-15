#This is a test to check if column names in database correspond to field descriptions.

txt=read.table("~/Documents/Data/Global/srdb/srdb-data_fields.txt",sep=",")

txt=as.character(txt[txt[,2]!="",2]) #Names in the srdb-data_fields.txt file
ndb=names(srdb) #Column names in database

#Test correspondance between names in database and in description file
ndb==txt

#Compare both
cbind(ndb,txt)

#Show names that do not match
c(rownumber=which(ndb!=txt),data=ndb[which(ndb!=txt)],descrip=txt[which(ndb!=txt)])
