properties([
        // keep only the last 20 builds
        buildDiscarder(logRotator(numToKeepStr: '20')),
        // when to run job 
        pipelineTriggers([
                cron('H H(3-4) * * *')
        ])
])

def sogisDbUri = ''
def pubDbUri = ''

node("master") {
    sogisDbUri = "${env.sogisDbUri}"
    pubDbUri = "${env.pubDbUri}"
}

node ("gretl") {
    git 'https://github.com/sogis/gretljobs.git'
    sh 'ls -la /home/gradle/libs'
    dir(env.JOB_BASE_NAME) {
        // show current location and content
        sh 'pwd && ls -la'
        // run job
        sh "gradle --init-script /home/gradle/init.gradle -PsogisDbUri=${sogisDbUri} -PpubDbUri=${pubDbUri}"
    }
}

