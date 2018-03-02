node ("gretl") {
    git 'https://github.com/sogis/gretljobs.git'
    dir(env.JOB_BASE_NAME) {
        sh 'gradle --init-script /home/gradle/init.gradle'
    }
}

