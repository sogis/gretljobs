properties([
        // keep only the last 20 builds
        buildDiscarder(logRotator(numToKeepStr: '20')),
        // when to run job 
        pipelineTriggers([
                cron('H H(3-4) * * *')
        ])
])

node ("gretl") {
    git 'https://github.com/sogis/gretljobs.git'
    dir(env.JOB_BASE_NAME) {
        sh 'gradle --init-script /home/gradle/init.gradle'
    }
}

