Global soil respiration database
Updated: 18-December-2013

List of files in this package
-----------------------
calculations					Directory of spreadsheets (figure estimates)
corrections-additions.xls		Excel workbook for corrections/additions 
expanded_field_notes.txt		More info on some fields and their uses 
READ_ME.txt						This file
srdb-data_fields.txt			Metadata for the srdb-data file
srdb-data.csv					Main database
srdb-studies_fields.txt			Metadata for the srdb-studies file
srdb-studies.csv				Studies database

-------------------------------------------------------------------
-- If you'd like to know when these data are updated:            --
-- http://groups.google.com/group/srdb-project-announce          --
-------------------------------------------------------------------

-------------------------------------------------------------------
-- If you'd like to obtain a PDF of one of the database studies: --
-- email Ben Bond-Lamberty (bondlamberty@pnnl.gov) with           --
-- the four-digit study number                                   --
-------------------------------------------------------------------

Changelog
-----------------------
20131218	Pubs from 2012 added (466 new records)
			Two new fields (measurement interval and annual coverage)
			Renamed CO2_method to Meas_method
			Many corrections to older data
			New R script for error-checking and mapping
			Removed kmz file
20120510	(figshare doi: 10.6084/m9.figshare.868954)
			Pubs from 2011 added, many other corrections to temp models
20110524	A few late-breaking studies added, and kmz file updated
20110513	Many missing 2010 studies added, and a number of errors fixed
				Thanks to Dan Metcalfe and Les Hook
20110224	More 2010 pubs added; three fields deleted:
				Chamber_method, CH4_flux, N2O_flux
				These were all inconsistent or almost never used
20101029	Pubs from first half of 2010 added
20100825	A number of Age_disturbance fields corrected and filled in
20100517	PY2009 data added. Field reordered to match Biogeosciences ms
20100222	Partition_method field fixed for many records
				Thanks to Myroslava Khomik

About srdb
-----------------------
This project is not code. Rather, it's a database of published studies
about soil surface CO2 flux (soil respiration) in the field, intended to
serve as a resource for scientific analysis.

How to get the data
-----------------------
See http://code.google.com/p/srdb
If you'd like to know when these data are updated, use the project feeds or subscribe to the announcement list.

How to use these data
-----------------------
Read the documentation! There are a few fields to be especially careful of, especially "CO2_method" (many analyses will want to exclude soda lime measurements, e.g.), "Manipulation" (you may want to filter to "None" to look at natural systems), "Ecosystem_state" (ditto), and "Ecosystem_type" (agriculture is guaranteed to be disturbed).

How to cite these data
-----------------------
Bond-Lamberty and Thomson (2010). A global database of soil respiration measurements, Biogeosciences 7:1321-1344, doi:10.5194/bgd-7-1321-2010.

Analyses using these data should include the database version (e.g., "20100517a"), download date, and URL.

How to contribute 
-----------------------
The goal is for this to be a dynamic, community database, not just an
archived blob. Why? Well, these data undoubtedly have mistakes and
omissions; the database could be structured more usefully for new
analyses; and the dataset should be extended as new studies are
published. Internet-based hosting services like Google Code give us, for
the first time, the ability to build a 21st-century data set that is
modified by, and grows with, the needs of the scientific community.
There are at least ways to contribute. The first, and preferred, way is
to check out (using Subversion) a copy of the data, just as if this were
an open-source software project. You can then modify or add data and
commit your modified copy back to the repository; a Google account (and
membership in the project) is needed for this last step . The second way
is to use the Excel workbook provided (under Downloads) for data entry
and then email the file back to one of the project administrators. The
third way to help is to file a bug report on the Issues tab or via email
to one of the admins. For all cases, instructions can be found with the
downloaded material, or in the online wiki.
