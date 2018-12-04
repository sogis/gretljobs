def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriPub = ''
def dbCredentialNamePub = ''
def dbUriCapitastra = ''
def dbCredentialNameCapitastra = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    dbUriCapitastra = "${env.DB_URI_CAPITASTRA}"
    dbCredentialNameCapitastra = "${DB_CREDENTIAL_CAPITASTRA}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    gitBranch = "${params.BRANCH ?: 'master'}"
    git url: "${gretljobsRepo}", branch: gitBranch
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub'), usernamePassword(credentialsId: "${dbCredentialNameCapitastra}", usernameVariable: 'dbUserCapitastra', passwordVariable: 'dbPwdCapitastra')]) {
            sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PdbUriCapitastra='${dbUriCapitastra}' -PdbUserCapitastra='${dbUserCapitastra}' -PdbPwdCapitastra='${dbPwdCapitastra}'"
        }
    }
}

