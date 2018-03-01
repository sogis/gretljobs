node ("gretl") {
    echo 'Hello World'
    git 'https://github.com/schmandr/greteljobs.git'

    sh 'ls -la /home/gradle/libs'

    dir('arp_aggloprogramme_pub') {
    // dir('/home/gradle/project') {
    // some block
        sh 'ls -la'
        sh 'pwd'

        // sh 'gradle --offline --init-script /home/gradle/init.gradle validate'
        // sh 'gradle --init-script /home/gradle/init.gradle validate'
        sh 'gradle --init-script /home/gradle/init.gradle'
    }
}

