pipeline {
    agent {
      label {
        label 'python01'
        retries 2
        }
    }
    environment {
        GIT_VER_REQD = "2.43.0"
          def img = ("${env.JOB_NAME}:${env.BUILD_ID}").toLowerCase()
    }
  
    stages {
        stage('Set OS_SYSTEM') {
              steps {
                  script {
                      def osSystem
                    if (isUnix()) {
                        osSystem = sh(returnStdout: true, script: 'echo "ubuntu"').trim()
                    } else {
                        osSystem = sh(returnStdout: true, script: 'echo "windows"').trim()
                    }
                    env.OS_SYSTEM = osSystem
                      echo "OS_SYSTEM: ${env.OS_SYSTEM}"
                }
            }
        }
        // Other stages in your pipeline
        stage('Checkout Code') {
        steps {
          echo 'INFO Checkout'
          
          echo 'INFO OS ${env.OS_SYSTEM}'

          // echo 'Before Clean'
          // sh 'ls -l'
          // cleanWs()
          // echo 'After Clean'
          // sh 'ls -l'
          // checkout scmGit(branches: [[name: '*/freestyle_pytest_no_script']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/quy-nguyen-wdc/pytest_sample.git']])
          // git branch: 'pipeline_pytest_script_sh', url: 'https://github.com/quy-nguyen-wdc/pytest_sample.git'
          // git branch: '$your_branch', url: 'https://github.com/quy-nguyen-wdc/pytest_sample.git'
          checkout scmGit(branches: [[name: '*/freestyle_pytest_no_script']], extensions: [[$class: 'PreBuildMerge', options: [mergeRemote: 'origin', mergeTarget: 'pipeline_pytest_script_sh']]], userRemoteConfigs: [[url: 'https://github.com/quy-nguyen-wdc/pytest_sample.git']])
          // sh 'cat readme.md'
          script {
                    if (fileExists('.git')) {
              echo 'Repository cloned successfully'
                    } else {
              error 'Failed to clone repository'
                    }
                }
          script {
              def workspaceLocation = pwd()
              echo "Workspace Location: ${workspaceLocation}"

                    env.GIT_VER = sh(returnStdout: true, script: 'git --version | awk \'{print $3}\'').trim()
              echo "System Git Version ${env.GIT_VER}"
              // https://www.jenkins.io/doc/pipeline/steps/pipeline-utility-steps/
              zip archive: true, dir: '', glob: '', zipFile: 'stingray-sw.zip', overwrite: true
              }
            
            sh 'ls -l'
            ftpPublisher alwaysPublishFromMaster: true, 
                continueOnError: false, 
                failOnError: false, 
                masterNodeName: '',
                paramPublish: [parameterName:""],
                publishers: [
                	[
                	configName: 'GVP_Datashare',
                	transfers: [
                		[
                		asciiMode: false, 
                		cleanRemote: false, 
                		excludes: '', 
                		flatten: false,
                		makeEmptyDirs: false, 
                		noDefaultExcludes: false, 
                		patternSeparator: '[, ]+', 
                		remoteDirectory: "/TED/TARS", 
                		remoteDirectorySDF: false, 
                		removePrefix: '', 
                		// sourceFiles: '**.py, **.zip'
                		sourceFiles: 'stingray-sw.zip'
                		]
                	], 
                	usePromotionTimestamp: false, 
                	useWorkspaceInPromotion: false, 
                	verbose: true
                	]
                ]
            }
        }
        stage('Unit Tests') {
          when {
              expression { "${env.GIT_VER}" == "${env.GIT_VER_REQD}" }
            }
        steps {
          echo 'INFO Unit Tests'
          echo "Default python ${env.DEFAULT_PYTHON_VER}"
  
          echo 'Get all Python Versions: '
                sh(returnStatus: true, script: '. ~/.bashrc \n pyenv version')
          
          echo env.WORKSPACE
          echo "The workspace is: ${env.WORKSPACE}"
                sh('chmod +x ./tests/scripts/about_agent.sh')
                retry(3) {
                    sh("bash ./tests/scripts/about_agent.sh")
                }
                sh('chmod +x ./tests/scripts/pytest_script.sh')
                timeout(time: 3, unit: 'MINUTES') {
                    sh('bash ./tests/scripts/pytest_script.sh')
                }

            }
        }
        stage('Publish report') {
        steps {
          echo 'INFO Publish Junit'
          junit skipMarkingBuildUnstable: true, testResults: 'reports/xml/output.xml'
          
          echo 'INFO Publish Pytest HTML Reports'
                publishHTML(target : [allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports/html/',
                    reportFiles: 'summary.html',
                    reportName: 'Pytest HTML Reports',
                    reportTitles: 'Pytest HTML Reports'])
          echo "INFO Publish code coverage"
                recordCoverage(tools: [[parser: 'COBERTURA', pattern: 'reports/coverage/coverage.xml']])
          
          echo "INFO Publish code logParser"
                logParser([
                    projectRulePath: "tests/log-parse-config/log_parse_01.txt",
                    parsingRulesPath: "",
                    showGraphs: true,
                    unstableOnWarning: true,
                    useProjectRule: true
                ])
            }
        }
        stage('Build') {
        steps {
          echo "INFO Build our image"
                // script {
                //   dockerImg = docker.build("${img}")
                // }
            }
        }
        stage('Deploy Run') {
        steps {
          echo "INFO Deploy and Run"
          echo "INFO Invoke another job"
          build job: 'Freestyle Job Demo', parameters: [string(name: 'pyenv', value: '3.8.10')]
          echo "INFO CURRENT RESULT: ${currentBuild.currentResult}"
                // script {
                //   def docker_image = "httpd:2.4-alpine"
                //   cont = docker.image("${docker_image}").run('--rm -d -p 5000:5000')
                //   sleep(15)
                // }
                timeout(time: 3, unit: 'MINUTES') {
                    retry(5) {
                  // sh './flakey-deploy.sh'
                  sh "hostname"
                    }
                }
            }
        }
    }
    post {
      // tool: http://localhost:9000/me/my-views/view/all/job/CheckDockerPlugin/directive-generator/
      always {
        echo "INFO In POST stage - Stop Docker image"
            //   cleanWs(cleanWhenNotBuilt: false,
            //                     deleteDirs: true,
            //                     disableDeferredWipeout: true,
            //                     notFailBuild: true,
            //                     patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
            //                               [pattern: '.propsfile', type: 'EXCLUDE']])
        // script {
        //   if (cont) {
        //     echo "In Post - inside if condt"
        //     cont.stop()
        //   }
        // }

        }
      success {
          echo 'This will run only if successful'
        }
      failure {
          echo 'This will run only if failed'
        }
      unstable {
          echo 'This will run only if the run was marked as unstable'
        }
      changed {
          echo 'This will run only if the state of the Pipeline has changed'
          echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}