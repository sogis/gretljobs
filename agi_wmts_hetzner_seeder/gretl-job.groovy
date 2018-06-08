def dbUriPub = ''
def dbCredentialNamePub = ''
def dbUriSodbUriHetznerWmtsgis = ''
def dbCredentialNameHetznerWmts = ''
def hetznerWmtsServerIp = ''
def gretljobsRepo = ''

node("master") {
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    dbUriHetznerWmts = "${env.DB_URI_HETZNER_WMTS}"
    dbCredentialNameHetznerWmts = "${DB_CREDENTIAL_HETZNER_WMTS}" // TODO: user name? ssh-key?
    hetznerWmtsServerIp = "${env.HETZNER_WMTS_SERVER_IP}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    git "${gretljobsRepo}"
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub'), usernamePassword(credentialsId: "${dbCredentialNameHetznerWmts}", usernameVariable: 'dbUserHetznerWmts', passwordVariable: 'dbPwdHetznerWmts')]) {
            sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PdbUriHetznerWmts='${dbUriHetznerWmts}' -PdbUserHetznerWmts='${dbUserHetznerWmts}' -PdbPwdHetznerWmts='${dbPwdHetznerWmts}' -PhetznerWmtsServerIp='${hetznerWmtsServerIp}'"
        }
    }
}
