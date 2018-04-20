def dbUriSogis = ''
def dbCredentialNameSogis = ''
def ftpServerZivilschutz = ''
def ftpCredentialNameZivilschutz = ''
def gretljobsRepo = ''
def emailRecipients = 'andreas.schmid@bd.so.ch, andreas.schmid@bd.so.ch'

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    ftpServerZivilschutz = "${env.FTP_SERVER_ZIVILSCHUTZ}"
    ftpCredentialNameZivilschutz = "${FTP_CREDENTIAL_ZIVILSCHUTZ}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    git "${gretljobsRepo}"
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${ftpCredentialNameZivilschutz}", usernameVariable: 'ftpUserZivilschutz', passwordVariable: 'ftpPwdZivilschutz')]) {
            sh "gradle --init-script /home/gradle/init.gradle -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' -PftpServerZivilschutz='${ftpServerZivilschutz}' -PftpUserZivilschutz='${ftpUserZivilschutz}' -PftpPwdZivilschutz='${ftpPwdZivilschutz}'"
        }
    }
	// emailext attachLog: true, to: "${emailRecipients}", subject: "Ausführung des GRETL-Job ${env.JOB_BASE_NAME} abgeschlossen", body: "Die Ausführung des GRETL-Job ${env.JOB_BASE_NAME} ist abgeschlossen. Ob sie erfolgreich war, entnehmen Sie bitte dem anghängten Log."
}
