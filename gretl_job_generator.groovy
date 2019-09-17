println "BUILD_NUMBER = ${BUILD_NUMBER}"

// set default values
def gretlJobFilePath = '**'
def gretlJobFileName = 'build.gradle'
def jenkinsfileName = 'Jenkinsfile'
def jobPropertiesFileName = 'job.properties'

// override default values if environment variables are set
if ("${GRETL_JOB_FILE_PATH}") {
  gretlJobFilePath = "${GRETL_JOB_FILE_PATH}"
  println 'gretlJobFilePath set to ' + gretlJobFilePath
}
if ("${GRETL_JOB_FILE_NAME}") {
  gretlJobFileName = "${GRETL_JOB_FILE_NAME}"
  println 'gretlJobFileName set to ' + gretlJobFileName
}


def baseDir = SEED_JOB.getWorkspace().toString()
println 'base dir: ' + baseDir

// search for GRETL-Job (Gradle) scripts (gretlJobFileName)
def jobFilePattern = "${gretlJobFilePath}/${gretlJobFileName}"
println 'job file pattern: ' + jobFilePattern

def jobFiles = new FileNameFinder().getFileNames(baseDir, jobFilePattern)


// generate the jobs
println 'generating the jobs...'
for (jobFile in jobFiles) {

  def relativeScriptPath = (jobFile - baseDir).substring(1)
  def _jobPath = relativeScriptPath.split('/')

  // take last folder for job name
  def namePosition = _jobPath.size() > 1 ? _jobPath.size() - 2 : 0
  def jobName = _jobPath[namePosition]
  println 'Job ' + jobName
  println 'script file: ' + relativeScriptPath

  def pipelineFilePath = "${baseDir}/${jenkinsfileName}"

  // check if job provides its own Jenkinsfile
  def customPipelineFilePath = "${jobName}/${jenkinsfileName}"
  if (new File(baseDir, customPipelineFilePath).exists()) {
    pipelineFilePath = customPipelineFilePath
    println 'custom pipeline file found: ' + customPipelineFilePath
  }
  def pipelineScript = readFileFromWorkspace(pipelineFilePath)

  // set defaults for job properties
  def properties = new Properties([
    'authorization.permissions':'nobody',
    'logRotator.numToKeep':'15',
    'parameters.fileParam':'none',
    'parameters.stringParam':'none',
    'triggers.upstream':'none',
    'triggers.cron':''
  ])
  def propertiesFilePath = "${jobName}/${jobPropertiesFileName}"
  def propertiesFile = new File(baseDir, propertiesFilePath)
  if (propertiesFile.exists()) {
    println 'properties file found: ' + propertiesFilePath
    properties.load(propertiesFile.newDataInputStream())
  }
  
  def productionEnv = ("${OPENSHIFT_BUILD_NAMESPACE}" == 'agi-gretl-production')

  pipelineJob(jobName) {
    if (!productionEnv) { // we don't want the BRANCH parameter in production environment
      parameters {
        stringParam('BRANCH', 'master', 'Name of branch to check out')
      }
    }
    if (properties.getProperty('parameters.fileParam') != 'none') {
      parameters {
        fileParam(properties.getProperty('parameters.fileParam'), 'Select file to upload')
      }
    }
    if (properties.getProperty('parameters.stringParam') != 'none') {
      def propertyValues = properties.getProperty('parameters.stringParam').split(';')
      if (propertyValues.length == 3) {
        parameters {
          stringParam(propertyValues[0], propertyValues[1], propertyValues[2])
        }
      }
    }
    authorization {
      permissions(properties.getProperty('authorization.permissions'), ['hudson.model.Item.Build', 'hudson.model.Item.Read'])
    }
    logRotator {
      numToKeep(properties.getProperty('logRotator.numToKeep') as Integer)
    }
    if (properties.getProperty('triggers.upstream') != 'none') {
      triggers {
        upstream(properties.getProperty('triggers.upstream'), 'SUCCESS')
      }
    }
    if (productionEnv) { // we want triggers only in production environment
      triggers {
        cron(properties.getProperty('triggers.cron'))
      }
    }
    definition {
      cps {
        script(pipelineScript)
        sandbox()
      }
    }
  }
}
