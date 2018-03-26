properties([
    // keep only the last 20 builds
    buildDiscarder(logRotator(numToKeepStr: '20')),
    // when to run job 
    pipelineTriggers([
        cron('H H(3-4) * * *')
    ])
])

def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriPub = ''
def dbCredentialNamePub = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
}

node ("gretl") {
    git 'https://github.com/sogis/gretljobs.git'
    sh 'ls -la /home/gradle/libs'
    dir(env.JOB_BASE_NAME) {
        // show current location and content
        sh 'pwd && ls -la'
        // run job
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub')]) {
            sh "gradle --init-script /home/gradle/init.gradle -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}'"
        }
    }
}

