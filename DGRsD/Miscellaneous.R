

# using join get SiteID from srdb_bahn
left_join(srdbv4[,-2], srdb_bahn[,c(1,2)], by = "Record_number", name = NULL) -> srdbv4
write.csv(srdbv4, paste0(SRDB_DIR, '/srdb-data-JJ.csv'), row.names = FALSE)
srdbv4 %>% filter(!is.na(SiteID) & SiteID != "") %>% select (Record_number, Study_number, SiteID)


# When studies in srdbv4 only have 1 row, and if DGRsD also has SiteID information, then update SiteID information of srdb
# 320 studies has only 1 row 
srdbv4 %>% count(Study_number) %>% filter (n==1) %>% select (Study_number) -> var_study
DGRsD %>% filter(StudyNumber %in% var_study$Study_number) %>% select(StudyNumber, SiteID) %>% distinct() -> sub_DGRsD

srdbv4 <- read.csv( paste0("srdb-master/","srdb-data.csv"), header = TRUE)
class (srdbv4$SiteID)
srdbv4$SiteID <- as.factor(srdbv4$SiteID)

left_join(srdbv4, sub_DGRsD, by = c("Study_number" = "StudyNumber")) -> srdbv4
write.csv(srdbv4, paste0(SRDB_DIR, '/srdb-data-JJ.csv'), row.names = FALSE)


# Find studies have more than 5 years Rs data
srdbv4 %>% select (Study_number, Study_midyear) %>% unique() %>% count(Study_number, sort = TRUE) 

# check lower case character for the Site_ID of srdb and dgrsd
"a" %in% letters
"a" %in% LETTERS

DGRsD %>% select (Study_number, SiteID) %>% filter (SiteID %in% letters )
srdbv4 %>% select (Study_number, SiteID) %>% filter (SiteID %in% letters )
