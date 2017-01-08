 **If you want a simple download**, click on the "Releases" tab above.
 
 srdb
====

Global soil respiration database

Last data update: 7 January 2016

About srdb
-----------------------
This project is **not code**. Rather, it's a database of published studies
about soil surface CO2 flux (soil respiration) in the field, intended to
serve as a resource for scientific analysis.

List of files in this repository
-----------------------

File						|	Description
----------------------------|------------------------------------------------
calculations				|	Directory of spreadsheets (figure estimates)
corrections-additions.xls	|	Excel workbook for corrections/additions 
expanded_field_notes.txt	|	More info on some fields and their uses 
READ_ME.md					|	Generates this README
srdb-data_fields.txt		|	Metadata for the srdb-data file
srdb-data.csv				|	Main database
srdb-studies_fields.txt		|	Metadata for the srdb-studies file
srdb-studies.csv			|	Studies database

Changelog
-----------------------

Date		|	Change
----------- | ------------------------------------------------------------
20150826    |   Fixes to faulty lon/lat values and site names; thanks to Yaxing Wei of ORNL. Some 2013 data added.
20140827	|	Shifted from Google Code (svn) to Github (git). No data changes.
20131218	|	Pubs from 2012 added (466 new records).	Two new fields (measurement interval and annual coverage); renamed CO2_method to Meas_method; many corrections to older data; new R script for error-checking and mapping; removed kmz file.
20120510	|	Pubs from 2011 added, many other corrections to temp models. Figshare doi: 10.6084/m9.figshare.868954.
20110524	|	A few late-breaking studies added, and kmz file updated
20110513	|	Many missing 2010 studies added, and a number of errors fixed. Thanks to Dan Metcalfe and Les Hook.
20110224	|	More 2010 pubs added; three fields deleted: Chamber_method, CH4_flux, N2O_flux. These were all inconsistent or almost never used.
20101029	|	Pubs from first half of 2010 added.
20100825	|	A number of Age_disturbance fields corrected and filled in.
20100517	|	PY2009 data added. Field reordered to match Biogeosciences ms.
20100222	|	Partition_method field fixed for many records. Thanks to Myroslava Khomik.

How to use these data
-----------------------
Read the documentation! There are a few fields to be especially careful of, especially "CO2_method" (many analyses will want to exclude soda lime measurements, e.g.), "Manipulation" (you may want to filter to "None" to look at natural systems), "Ecosystem_state" (ditto), and "Ecosystem_type" (agriculture is guaranteed to be disturbed).

How to get a publication
-----------------------
If you'd like to obtain a PDF of one of the database studies, open an issue or email Ben Bond-Lamberty, the maintainer. In either case please specify the four-digit study number.                                  

How to cite these data
-----------------------
This data set is **open**, and no co-authorship is required (or wanted) if you make use of it. The relevant citation is:
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
is to use the Excel workbook provided (under Downloads) for data entry
and then email the file back to one of the project administrators. The
**third** way to help is to file a bug report on the Issues tab or via email
to one of the admins. For all cases, instructions can be found with the
downloaded material.

