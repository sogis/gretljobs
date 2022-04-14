// set default values
def gretlJobFilePath = '*'
def gretlJobFileName = '*.gradle' // includes also settings.gradle, for projects with subprojects
def jenkinsfileName = 'Jenkinsfile'
def jobPropertiesFileName = 'job.properties'

def jobNamePrefix = ''


// search for files (gretlJobFileName) that are causing the creation of a GRETL-Job
def jobFilePattern = "${gretlJobFilePath}/${gretlJobFileName}"
println 'job file pattern: ' + jobFilePattern
def jobFiles = new FileNameFinder().getFileNames(WORKSPACE, jobFilePattern)


// generate the jobs
println 'generating the jobs...'
for (jobFile in jobFiles) {
  // get the folder name (is at position 2 from the end of the jobFile path)
  def folderName = jobFile.split('/').getAt(-2)

  // define the job name
  def jobName = "${jobNamePrefix}${folderName}"
  println 'Job ' + jobName

  // set the path to the default Jenkinsfile
  def pipelineFilePath = "${WORKSPACE}/${jenkinsfileName}"
  // check if job provides its own Jenkinsfile
  def customPipelineFilePath = "${folderName}/${jenkinsfileName}"
  if (new File(WORKSPACE, customPipelineFilePath).exists()) {
    pipelineFilePath = customPipelineFilePath
    println '    custom pipeline file found: ' + customPipelineFilePath
  }
  // read Jenkinsfile content
  def pipelineScript = readFileFromWorkspace(pipelineFilePath)


  // set defaults for job properties
  def properties = new Properties([
    'authorization.permissions':'nobody',
    'logRotator.numToKeep':'15',
    'parameters.fileParam':'none',
    'parameters.stringParam':'none',
    'parameters.stringParams':'none',
    'triggers.upstream':'none',
    'triggers.cron':''
  ])
  def propertiesFilePath = "${folderName}/${jobPropertiesFileName}"
  def propertiesFile = new File(WORKSPACE, propertiesFilePath)
  if (propertiesFile.exists()) {
    println '    properties file found: ' + propertiesFilePath
    properties.load(new FileReader(propertiesFile))
  }

  def productionEnv = ("${PROJECT_NAME}" == 'agi-gretl-production')

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
    if (properties.getProperty('parameters.stringParams') != 'none') {
      def stringParams = properties.getProperty('parameters.stringParams').split('@')
      for ( sp in stringParams ) {
        def spValues = sp.split(';')
        if (spValues.length == 3) {
          parameters {
            stringParam(spValues[0], spValues[1], spValues[2])
          }
        } else {
          println '    WARNING: Invalid stringParam definiton: ' + spValues
        }
      }
    }
    authorization {
      permissions(properties.getProperty('authorization.permissions'), ['hudson.model.Item.Build', 'hudson.model.Item.Read'])
    }
    if (properties.getProperty('logRotator.numToKeep') != 'unlimited') {
      logRotator {
        numToKeep(properties.getProperty('logRotator.numToKeep') as Integer)
      }
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
    if (properties.getProperty('nodeLabel') != null) {
      parameters {
        choiceParam('nodeLabel', [properties.getProperty('nodeLabel')], 'Label of the node that must run the job')
      }
    }

    environmentVariables {
      // make the Git repository URL available on the Jenkins agent
      env('GIT_REPO_URL', GRETL_JOB_REPO_URL)
    }

    definition {
      cps {
        script(pipelineScript)
        sandbox()
      }
    }
  }
}

// add a view (tab) for these jobs
listView('GRETL-Jobs') {
  jobs {
    regex(/^(?!(schema_|oereb_|gretl-job-generator-schema|gretl-job-generator-oereb)).*/)
  }
  columns {
    status()
    weather()
    name()
    lastSuccess()
    lastFailure()
    lastDuration()
    buildButton()
    favoriteColumn()
  }
}
