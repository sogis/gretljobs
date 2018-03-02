node ("gretl") {
    git 'https://github.com/schmandr/gretljobs.git'
    dir('arp_aggloprogramme_pub') {
        sh 'gradle --init-script /home/gradle/init.gradle'
    }
}

