 **If you want a simple download**, click on the "Releases" tab above. 
 There's also a version on the [ORNL DAAC](https://doi.org/10.3334/ORNLDAAC/1235).

srdb
====

Global soil respiration database

Last data update: 22 May 2021

About srdb
-----------------------
This project is **not code**. Rather, it's a database of published studies
about soil surface CO2 flux (soil respiration) in the field, intended to
serve as a resource for scientific analysis.

List of files in this repository
-----------------------

File						|	Description
----------------------------|------------------------------------------------
calculations				|	Directory of spreadsheets (generally data estimated from figures)
corrections-additions.xls	|	Excel workbook for corrections/additions 
expanded_field_notes.txt	|	More info on some fields and their uses 
LICENSE | The SRDB uses the MIT license, which is short, simple, and permissive
R							|	R check script directory
README.md					|	Generates this README
srdb-data_fields.txt		|	Metadata for the srdb-data file
srdb-data.csv				|	Main database
srdb-equations_fields.csv	|	Metadata for the srdb-equations file_
srdb-equations.csv			|	Temperature and moisture sensitivity equations
srdb-studies_fields.txt		|	Metadata for the srdb-studies file
srdb-studies.csv			|	Studies database

Major changelog
-----------------------

Date	   	|	Change
-------- | ------------------------------------------------------------
20210522 | Many new 2017 data entered by Shoshi Hornum and Hope Ng
20200424 | A variety of new data from the Russian-language literature; thanks to Nazar Kholod.
20200409 | Ingest of LOTS of new data (through PY2017; `srdb-data.csv` goes from 7318 to 10311 rows) entered by [@jmanzon](https://github.com/jmanzon), [@darlinp](https://github.com/darlinp), and [@jinshijian](https://github.com/jinshijian).
20200220 | Removed fields `Rs_max`, `Rs_maxday`, `Rs_min`, and `Rs_minday` from database; they haven't been used and are very inconsistent. Added `Collar_height` and merged a bunch of new data for that fields as well as `Collar_depth`, `Chamber_area`, and `Time_of_day`.
20191103 | New fields (`Collar_depth`, `Chamber_area`, `Time_of_day`); first data from interns Darlin P. and  Jason M.; data corrections by [@jinshijian](https://github.com/jinshijian)
20190915 | Added lots of new data entered by [@rbcmrchs](https://github.com/rbcmrchs) and [@jinshijian](https://github.com/jinshijian); corrections to older data; broke equations columns into separate, new `srdb-equations.csv` file.
20190306 | Many corrections to longitude and latitude data; see issue #22. Thanks to [@jinshijian](https://github.com/jinshijian).
20181101 | Fixed a number of bad sand:silt:clay values, duplicate records, and other problems. Thanks to [@ValentineHerr](https://github.com/ValentineHerr) of SI, and Shafer Powell and Debjani Deb of [ORNL DAAC](https://daac.ornl.gov).
20180724 | Fixed a number of lat/lon problems, and reverted to purely decimal format for those fields. Thanks to Debjani Deb.
20180216 | Updated the R QC script so it works correctly with new dataset.
20180215 | All data through 2013 along with some 2014 and 2015. Fixes to partitioning (`Rh_annual`, `Ra_annual`) in some previous records (studies 2037, 5545, 5727, 6010, 6219). `Study_midyear` field changed so that X.5 is consistently middle of year X. `Latitude` and `Longitude` fields may now be either decimal or d-m-s format. Thanks to Mercedes Horn.
20150826 | Fixes to faulty `Longitude` and `Latitude` values and site names; thanks to Yaxing Wei of ORNL. Some 2013 data added.
20140827 | Shifted from Google Code (svn) to Github (git). No data changes.
20131218 | Pubs from 2012 added (466 new records).	Two new fields (measurement interval and annual coverage); renamed `CO2_method` to `Meas_method`; many corrections to older data; new R script for error-checking and mapping; removed kmz file.
20120510 | Pubs from 2011 added, many other corrections to temp models. Figshare doi: 10.6084/m9.figshare.868954.
20110524 | A few late-breaking studies added, and kmz file updated.
20110513 | Many missing 2010 studies added, and a number of errors fixed. Thanks to Dan Metcalfe and Les Hook.
20110224 | More 2010 pubs added; three fields deleted: `Chamber_method`, `CH4_flux`, `N2O_flux`. These were all inconsistent or almost never used.
20101029 | Pubs from first half of 2010 added.
20100825 | A number of `Age_disturbance` fields corrected and filled in.
20100517 | PY2009 data added. Field reordered to match Biogeosciences ms.
20100222 | `Partition_method` field fixed for many records. Thanks to Myroslava Khomik.

How to use these data
-----------------------
Read the documentation! There are a few fields to be especially careful of, especially "Quality_flag", 
"CO2_method" (e.g. many analyses will want to exclude soda lime measurements), "Manipulation" (you may
want to filter to "None" to look at un-manipulated systems), "Ecosystem_state", and "Ecosystem_type".

How to get a publication
-----------------------
If you'd like to obtain a PDF of one of the database studies, open an issue or email 
Ben Bond-Lamberty, the maintainer. In either case please specify the study number.                                  

How to cite these data
-----------------------
This data set is **open**, and no co-authorship is required if you make use of it. The relevant citation is:
* Bond-Lamberty and Thomson (2010). A global database of soil respiration measurements, *Biogeosciences* 7:1321-1344, doi:[10.5194/bgd-7-1321-2010](http://dx.doi.org/10.5194/bgd-7-1321-2010).

Analyses using these data should include the database version (i.e. the tag, such as "v20131218a", and ideally the git commit), download date, and URL. (At some point in the future, releases will include a DOI, too.)

Mailing list
-----------------------
If you'd like to know when these data are updated, a mailing list is available at http://groups.google.com/group/srdb-project-announce.

How to contribute
-----------------------
The goal is for this to be a dynamic, community database, not just an
archived blob. Why? Well, these data undoubtedly have mistakes and
omissions; the database could be structured more usefully for new
analyses; and the dataset should be extended as new studies are
published. Internet-based hosting services like give us the ability to build a 21st-century data set that is
modified by, and grows with, the needs of the scientific community.
There are at least ways to contribute. The **first**, and preferred, way is
to fork out (using git) a copy of the data, just as if this were
an open-source software project. You can then modify or add data and
send me a pull request. The **second** way
is to use the Excel workbook provided for data entry
and then email the file back to one of the project administrators. The
**third** way to help is to file a bug report on the Issues tab or via email
to one of the admins. For all cases, instructions can be found with the
downloaded material.

