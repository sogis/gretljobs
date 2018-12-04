def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriVerisoNplso = ''
def dbCredentialNameVerisoNplso = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriVerisoNplso = "${env.DB_URI_VERISO_NPLSO}"
    dbCredentialNameVerisoNplso = "${DB_CREDENTIAL_GRETL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    gitBranch = "${params.BRANCH ?: 'master'}"
    git url: "${gretljobsRepo}", branch: gitBranch
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${dbCredentialNameVerisoNplso}", usernameVariable: 'dbUserVerisoNplso', passwordVariable: 'dbPwdVerisoNplso')]) {
            sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriVerisoNplso='${dbUriVerisoNplso}' -PdbUserVerisoNplso='${dbUserVerisoNplso}' -PdbPwdVerisoNplso='${dbPwdVerisoNplso}'"
        }
    }
}

