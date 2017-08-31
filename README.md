# gretljobs
Contains all job configuration files (*.gradle, *.sql, ...) of the jobs that are run by gretl

In addition to the Gradle build file a global init script is needed. It must not be checked in the repository. An example init script looks like this:
```
allprojects {
    buildscript {
        repositories {
            mavenCentral()
            maven {
                name 'Repository name here'
                url 'https://agi.jfrog.io/agi/libs-release'
                credentials {
                    username 'myusername'
                    password 'mypassword'
                }
            }   
        }
        dependencies {
            classpath group: 'ch.so.agi', name: 'gretl',  version: '1.0.+'
        }
        ext {
            dbUrl = System.env.dbUrl
            dbUser = 'mydbusername'
            dbPass = 'mydbpassword'
        }
    }
}
```
Example build command (when you have placed init.gradle directly in your home directory):
```
export dbUrl=jdbc:postgresql://mydbservername/mydbname
gradle -I ~/init.gradle -b ch.so.afu.gewaesserschutz_export/build.gradle
```
