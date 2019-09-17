def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriEdit = ''
def dbCredentialNameEdit = ''
def dbUriPub = ''
def dbCredentialNamePub = ''
def dbUriVerisoNplso = ''
def dbCredentialNameVerisoNplso = ''
def dbUriAltlast4web = ''
def dbCredentialNameAltlast4web = ''
def dbUriKaso = ''
def dbCredentialNameKaso = ''
def dbUriCapitastra = ''
def dbCredentialNameCapitastra = ''
def ftpServerZivilschutz = ''
def ftpCredentialNameZivilschutz = ''
def aiServer = ''
def aiCredentialName = ''
def infofloraCredentialName = ''
def solrIndexupdaterBaseUrl = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriEdit = "${env.DB_URI_EDIT}"
    dbCredentialNameEdit = "${DB_CREDENTIAL_GRETL}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    dbUriVerisoNplso = "${env.DB_URI_VERISO_NPLSO}"
    dbCredentialNameVerisoNplso = "${DB_CREDENTIAL_GRETL}"
    dbUriAltlast4web = "${env.DB_URI_ALTLAST4WEB}"
    dbCredentialNameAltlast4web = "${DB_CREDENTIAL_ALTLAST4WEB}"
    dbUriKaso = "${env.DB_URI_KASO}"
    dbCredentialNameKaso = "${DB_CREDENTIAL_KASO}"
    dbUriCapitastra = "${env.DB_URI_CAPITASTRA}"
    dbCredentialNameCapitastra = "${DB_CREDENTIAL_CAPITASTRA}"
    ftpServerZivilschutz = "${env.FTP_SERVER_ZIVILSCHUTZ}"
    ftpCredentialNameZivilschutz = "${FTP_CREDENTIAL_ZIVILSCHUTZ}"
    aiServer = "${env.AI_SERVER}"
    aiCredentialName = "${AI_CREDENTIAL}"
    infofloraCredentialName = "${INFOFLORA_CREDENTIAL}"
    solrIndexupdaterBaseUrl = "${env.SOLR_INDEXUPDATER_BASE_URL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    try {
        gitBranch = "${params.BRANCH ?: 'master'}"
        git url: "${gretljobsRepo}", branch: gitBranch, changelog: false
        dir(env.JOB_BASE_NAME) {
            credentials = [
                usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'),
                usernamePassword(credentialsId: "${dbCredentialNameEdit}", usernameVariable: 'dbUserEdit', passwordVariable: 'dbPwdEdit'),
                usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub'),
                usernamePassword(credentialsId: "${dbCredentialNameVerisoNplso}", usernameVariable: 'dbUserVerisoNplso', passwordVariable: 'dbPwdVerisoNplso'),
                usernamePassword(credentialsId: "${dbCredentialNameAltlast4web}", usernameVariable: 'dbUserAltlast4web', passwordVariable: 'dbPwdAltlast4web'),
                usernamePassword(credentialsId: "${dbCredentialNameKaso}", usernameVariable: 'dbUserKaso', passwordVariable: 'dbPwdKaso'),
                usernamePassword(credentialsId: "${dbCredentialNameCapitastra}", usernameVariable: 'dbUserCapitastra', passwordVariable: 'dbPwdCapitastra'),
                usernamePassword(credentialsId: "${ftpCredentialNameZivilschutz}", usernameVariable: 'ftpUserZivilschutz', passwordVariable: 'ftpPwdZivilschutz'),
                usernamePassword(credentialsId: "${aiCredentialName}", usernameVariable: 'aiUser', passwordVariable: 'aiPwd'),
                usernamePassword(credentialsId: "${infofloraCredentialName}", usernameVariable: 'infofloraUser', passwordVariable: 'infofloraPwd')
            ]
            withCredentials(credentials) {
                sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriEdit='${dbUriEdit}' -PdbUserEdit='${dbUserEdit}' -PdbPwdEdit='${dbPwdEdit}' \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PdbUriVerisoNplso='${dbUriVerisoNplso}' -PdbUserVerisoNplso='${dbUserVerisoNplso}' -PdbPwdVerisoNplso='${dbPwdVerisoNplso}' \
                -PdbUriAltlast4web='${dbUriAltlast4web}' -PdbUserAltlast4web='${dbUserAltlast4web}' -PdbPwdAltlast4web='${dbPwdAltlast4web}' \
                -PdbUriKaso='${dbUriKaso}' -PdbUserKaso='${dbUserKaso}' -PdbPwdKaso='${dbPwdKaso}' \
                -PdbUriCapitastra='${dbUriCapitastra}' -PdbUserCapitastra='${dbUserCapitastra}' -PdbPwdCapitastra='${dbPwdCapitastra}' \
                -PftpServerZivilschutz='${ftpServerZivilschutz}' -PftpUserZivilschutz='${ftpUserZivilschutz}' -PftpPwdZivilschutz='${ftpPwdZivilschutz}' \
                -PaiServer='${aiServer}' -PaiUser='${aiUser}' -PaiPwd='${aiPwd}' \
                -PinfofloraUser='${infofloraUser}' -PaiPwd='${infofloraPwd}' \
                -PsolrIndexupdaterBaseUrl='${solrIndexupdaterBaseUrl}'"
            }
        }
    }
    catch (e) {
        echo 'Job failed'
        emailext (
                to: '${DEFAULT_RECIPIENTS}',
                recipientProviders: [requestor()],
                subject: "GRETL-Job ${env.JOB_NAME} (${env.BUILD_DISPLAY_NAME}) ist fehlgeschlagen",
                body: "Der GRETL-Job ${env.JOB_NAME} (${env.BUILD_DISPLAY_NAME}) war leider nicht erfolgreich. Details dazu finden Sie in den Log-Meldungen unter ${env.BUILD_URL}."
        )
        throw e
    }
}
