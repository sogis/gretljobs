def gretlShareMountpoint = 'none'
def dbUriPub = ''
def dbCredentialNamePub = ''
def dbUriSodbUriHetznerWmtsgis = ''
def dbCredentialNameHetznerWmts = ''
def hetznerWmtsServerIp = ''
def gretljobsRepo = ''

node("master") {
    gretlShareMountpoint = "${env.GRETL_SHARE_MOUNTPOINT}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    dbUriHetznerWmts = "${env.DB_URI_HETZNER_WMTS}"
    dbCredentialNameHetznerWmts = "${DB_CREDENTIAL_HETZNER_WMTS}"
    hetznerWmtsServerIp = "${env.HETZNER_WMTS_SERVER_IP}"
    hetznerWmtsServerCredential = "${env.HETZNER_WMTS_SERVER_CREDENTIAL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    git branch: gitBranch, url: "${gretljobsRepo}"
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub'), usernamePassword(credentialsId: "${dbCredentialNameHetznerWmts}", usernameVariable: 'dbUserHetznerWmts', passwordVariable: 'dbPwdHetznerWmts'), sshUserPrivateKey(credentialsId: "${hetznerWmtsServerCredential}", keyFileVariable: 'sshKeyFilePathHetznerWmts')]) {
            sh "gradle --init-script /home/gradle/init.gradle \
                -PgretlShareMountpoint='${gretlShareMountpoint}' \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PdbUriHetznerWmts='${dbUriHetznerWmts}' -PdbUserHetznerWmts='${dbUserHetznerWmts}' -PdbPwdHetznerWmts='${dbPwdHetznerWmts}' -PhetznerWmtsServerIp='${hetznerWmtsServerIp}' -PsshKeyFilePathHetznerWmts='${sshKeyFilePathHetznerWmts}'"
        }
    }
}
