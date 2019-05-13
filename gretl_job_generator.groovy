println "BUILD_NUMBER = ${BUILD_NUMBER}"

def base = SEED_JOB.getWorkspace().toString()
println 'job base dir: ' + base

def jobFileDefinition = "${GRETL_JOB_FILE_PATH}/${GRETL_JOB_FILE_NAME}"
println 'job file definition: ' + jobFileDefinition

def pipelineFiles = new FileNameFinder().getFileNames(base, jobFileDefinition)

for (pipelineFil in pipelineFiles) {

  def relativeScriptPath = (pipelineFil - base).substring(1)
  def _jobPath = relativeScriptPath.split('/')

  // take last folder for job name
  def namePosition = _jobPath.size() > 1 ? _jobPath.size() - 2 : 0
  def realJobName = _jobPath[namePosition]

  println 'job name: ' + realJobName

  def releaseScript = readFileFromWorkspace(pipelineFil)

  // set defaults for job properties
  def properties = new Properties([
    'authorization.permissions':'nobody',
    'logRotator.numToKeep':'15',
    'parameters.fileParam':'none',
    'triggers.upstream':'none',
    'triggers.cron':''
  ])
  def propertiesFile = new File(base + '/' + realJobName + '/job.properties')
  if (propertiesFile.exists()) {
    properties.load(propertiesFile.newDataInputStream())
  }
  
  def productionEnv = ("${OPENSHIFT_BUILD_NAMESPACE}" == 'agi-gretl-production')

  pipelineJob(realJobName) {
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
        script(releaseScript)
        sandbox()
      }
    }
  }
}
