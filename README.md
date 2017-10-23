# gretljobs
Contains all job configuration files (\*.gradle, \*.sql, ...) of the jobs that are run by gretl and all files needed to set up a virtual gretl runtime environment

**Instructions to build the virtual gretl runtime environment**

As a requirement to run gretl virtual environment you have to define 4 environment variables in your .bashrc
To run the gretljobs you need a source DB and a target DB (possibly a virtual environment too).
Maybe you have to change pg_hba.conf of source DB or target DB
```
export sourceDbUser=username for source DB
export sourceDbPass=password for source DB 
export targetDbUrl=url to target DB (for example jdbc:postgresql://192.168.56.21/sogis (example for a virtual DB server))
export targetDbPass=password for gretl user in target DB
```
After defining the environment variables you can build the virtual server.
Please make a new branch for working with gretljobs.
```
git clone https://github.com/sogis/gretljobs.git
cd gretljobs
git checkout -b branchname
vagrant up
```
Login on the virtual server with
```
vagrant ssh
```

Example build command 
```
gradle -b /vagrant/ch.so.afu.gewaesserschutz_export/build.gradle
```
