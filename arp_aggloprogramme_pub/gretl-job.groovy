properties([
    // keep only the last 20 builds
    buildDiscarder(logRotator(numToKeepStr: '20')),
    // when to run job 
    pipelineTriggers([
        cron('H H(3-4) * * *')
    ])
])

def sogisDbUri = ''
def sogisDbCredentialName = ''
def pubDbUri = ''
def pubDbCredentialName = ''

node("master") {
    sogisDbUri = "${env.sogisDbUri}"
    sogisDbCredentialName = "${gretlDbCredential}"
    pubDbUri = "${env.pubDbUri}"
    pubDbCredentialName = "${gretlDbCredential}"
}

node ("gretl") {
    git 'https://github.com/sogis/gretljobs.git'
    sh 'ls -la /home/gradle/libs'
    dir(env.JOB_BASE_NAME) {
        // show current location and content
        sh 'pwd && ls -la'
        // run job
        withCredentials([usernamePassword(credentialsId: "${sogisDbCredentialName}", usernameVariable: 'sogisDbUser', passwordVariable: 'sogisDbPwd'), usernamePassword(credentialsId: "${pubDbCredentialName}", usernameVariable: 'pubDbUser', passwordVariable: 'pubDbPwd')]) {
            sh "gradle --init-script /home/gradle/init.gradle -PsogisDbUri=${sogisDbUri} -PsogisDbUser=${sogisDbUser} -PsogisDbPwd=${sogisDbPwd} -PpubDbUri=${pubDbUri} -PpubDbUser=${pubDbUser} -PpubDbPwd=${pubDbPwd}"
        }
    }
}

