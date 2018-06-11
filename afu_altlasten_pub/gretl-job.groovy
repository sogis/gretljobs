def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriPub = ''
def dbCredentialNamePub = ''
def dbUriAltlast4web = ''
def dbCredentialNameAltlast4web = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    dbUriAltlast4web = "${env.DB_URI_ALTLAST4WEB}"
    dbCredentialNameAltlast4web = "${DB_CREDENTIAL_ALTLAST4WEB}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    git "${gretljobsRepo}"
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub'), usernamePassword(credentialsId: "${dbCredentialNameAltlast4web}", usernameVariable: 'dbUserAltlast4web', passwordVariable: 'dbPwdAltlast4web')]) {
            sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PdbUriAltlast4web='${dbUriAltlast4web}' -PdbUserAltlast4web='${dbUserAltlast4web}' -PdbPwdAltlast4web='${dbPwdAltlast4web}'"
        }
    }
}

