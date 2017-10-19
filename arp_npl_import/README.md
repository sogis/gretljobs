# Import and transformation of Nutzungsplanung

This job uses a non-production-ready gretl version! A seperate init.gradle has to be used. 

You can import a dataset (= one municipality) and do the conversion into the publication model:

* `gretl -I init.gradle replaceDataset -Pxtf=path/to/XXXX_fubar.xtf` where `XXXX` is the fos number (=BfS-Nummer) and will be checked if it's in a specific range. 
* `gretl -I init.gradle transformArpNpl`
* Or combine the two tasks.

Not sure how we will use this exactly with our gretl-jenkins.
