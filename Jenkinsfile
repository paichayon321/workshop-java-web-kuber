import java.text.SimpleDateFormat
def version, mvnCmd = "mvn -s configuration/cicd-settings-nexus3.xml"
//Deployment Env Initial
def containerURL="https://console.45.116.216.140.xip.io:8443"
def ocCredId="ocadmin_openshift"
def gitCredId="gitlab-pocws"
def SonarQubeURL="http://devops.poc.gabledemo.com:9000/sonar"
def sonarCredId="sonar-scan-token"
def subDomain ="apps.pocws.gabledemo.com"
//# If use image from private registry --> Set as below
def dockerRepoURL="https://harbor.pocws.gabledemo.com"
def dockerRepoHost="harbor.pocws.gabledemo.com"
def dockerRepo="demo"
def dockerCredId="paichayon-harbor-pocws"

//# If use image from docker hub --> Set as below
// def dockerRepoURL="docker.io"
// def dockerRepo="paichayon"
// def credId="paichayon_docker"
//################################################

def devenv="dev"
def uatenv="uat"
def prodenv="prod"

//Notify Initial
def maildevteam='paichayon.t@g-able.com'
def mailappsecteam='paichayon.t@g-able.com'
def mailtestteam='paichayon.t@g-able.com'
def mailopsteam='paichayon.t@g-able.com'
def mailinfrasecteam='paichayon.t@g-able.com'
//## Backup
// def linemicroservice='84yF0i4UySrvuYyi5Pbe3BiEzsjycsozmOJnGZn5N1v'
// def linecicdnotify='P83FqsGYM5rrqvsrkRFK0DTjtKqIQyk8KK03cPTdvjq'
// def linedev='ZlJDUkyCdPiu1AaP9MvM4Is25gjwcdxcui1qhfK5h2l'
// def linesec='eQJrm82llRfZOKAKX8pREOalVkcNv5PbFkxedyeH9ZX'
// def linetester='BrbGsmgX1VX9HCZyauz7eSRsKTOoUxoHNNo2Jt5wac2'
// def lineoper='W4i7nyPT4IG81IbY68gwr3v4Zbb1iFH8FDBk9GwbdU6'
//## TEST
def linemicroservice='84yF0i4UySrvuYyi5Pbe3BiEzsjycsozmOJnGZn5N1v'
def linecicdnotify='P83FqsGYM5rrqvsrkRFK0DTjtKqIQyk8KK03cPTdvjq'
def linedev='P83FqsGYM5rrqvsrkRFK0DTjtKqIQyk8KK03cPTdvjq'
def linesec='P83FqsGYM5rrqvsrkRFK0DTjtKqIQyk8KK03cPTdvjq'
def linetester='P83FqsGYM5rrqvsrkRFK0DTjtKqIQyk8KK03cPTdvjq'
def lineoper='P83FqsGYM5rrqvsrkRFK0DTjtKqIQyk8KK03cPTdvjq'

// Line Notify function
def notifyLINE(token, message) {
    def url = 'https://notify-api.line.me/api/notify'
    sh "curl ${url} -H 'Authorization: Bearer ${token}' -F 'message=${message}'"
}



def releaseDate
def releaseTag
node {
    def dateFormat = new SimpleDateFormat("yyyyMMdd")
    def date = new Date()
    def commitId

    releaseDate = (dateFormat.format(date))
    releaseTag = releaseDate + "-" + env.BUILD_NUMBER
    }
    
void publishTestResults() {
    step([
            $class           : 'hudson.plugins.robot.RobotPublisher',
            outputPath       : '\\',
            passThreshold    : 100,
            unstableThreshold: 100,
            otherFiles       : '**\\*selenium-screenshot*.png',
            reportFileName   : '**\\report*.html',
            logFileName      : '**\\log*.html',
            outputFileName   : '**\\output*.xml'
    ])
}
pipeline {
//   agent {
//       //label 'slave01'
//   }
  agent any
  stages{
    stage('BuildApp') {
      steps {
        script {
          echo "Now Perform Build Steps"
          git branch: 'master', credentialsId: "${gitCredId}", url: 'https://gitlab.poc.gabledemo.com/paichayon/workshop-java-web.git'
          commitId = sh(returnStdout: true, script: 'git rev-parse HEAD')
          script {
            def pom = readMavenPom file: 'pom.xml'
            version = pom.version
          }
          sh "chmod +x ./mvnw"
          sh "./mvnw clean package -DskipTests"
          message = "\nJob: ${env.JOB_NAME} \nStage BuildApp is Success.\nSee more detail at \n${env.BUILD_URL}console"
          notifyLINE("${linecicdnotify}", "${message}")
          notifyLINE("${linedev}", "${message}")
        }
      }
    }
    stage('UniTest') {
      steps {
        script {
          echo "Now Perform UniTest Steps"
          sh "./mvnw test"
          step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
          message = "\nJob: ${env.JOB_NAME} \nStage UniTest is Success. \nSee Report at \n${env.BUILD_URL}testReport/"
          notifyLINE("${linecicdnotify}", "${message}")
          notifyLINE("${linedev}", "${message}")
          //build 'archive'
        }    
      }
    }
    stage('CheckMarx') {
      steps {
        script {
          echo "Now Perform CheckMarx Steps"
          step([$class: 'CxScanBuilder', comment: '', credentialsId: '', excludeFolders: '', excludeOpenSourceFolders: '', exclusionsSetting: 'global', failBuildOnNewResults: false, failBuildOnNewSeverity: 'HIGH', filterPattern: '''!**/_cvs/**/*, !**/.svn/**/*,   !**/.hg/**/*,   !**/.git/**/*,  !**/.bzr/**/*, !**/bin/**/*,
!**/obj/**/*,  !**/backup/**/*, !**/.idea/**/*, !**/*.DS_Store, !**/*.ipr,     !**/*.iws,
!**/*.bak,     !**/*.tmp,       !**/*.aac,      !**/*.aif,      !**/*.iff,     !**/*.m3u, !**/*.mid, !**/*.mp3,
!**/*.mpa,     !**/*.ra,        !**/*.wav,      !**/*.wma,      !**/*.3g2,     !**/*.3gp, !**/*.asf, !**/*.asx,
!**/*.avi,     !**/*.flv,       !**/*.mov,      !**/*.mp4,      !**/*.mpg,     !**/*.rm,  !**/*.swf, !**/*.vob,
!**/*.wmv,     !**/*.bmp,       !**/*.gif,      !**/*.jpg,      !**/*.png,     !**/*.psd, !**/*.tif, !**/*.swf,
!**/*.jar,     !**/*.zip,       !**/*.rar,      !**/*.exe,      !**/*.dll,     !**/*.pdb, !**/*.7z,  !**/*.gz,
!**/*.tar.gz,  !**/*.tar,       !**/*.gz,       !**/*.ahtm,     !**/*.ahtml,   !**/*.fhtml, !**/*.hdm,
!**/*.hdml,    !**/*.hsql,      !**/*.ht,       !**/*.hta,      !**/*.htc,     !**/*.htd, !**/*.war, !**/*.ear,
!**/*.htmls,   !**/*.ihtml,     !**/*.mht,      !**/*.mhtm,     !**/*.mhtml,   !**/*.ssi, !**/*.stm,
!**/*.stml,    !**/*.ttml,      !**/*.txn,      !**/*.xhtm,     !**/*.xhtml,   !**/*.class, !**/*.iml, !Checkmarx/Reports/*.*''', fullScanCycle: 10, generateXmlReport: true, groupId: '00000000-1111-1111-b111-989c9070eb11', includeOpenSourceFolders: '', osaArchiveIncludePatterns: '*.zip, *.war, *.ear, *.tgz', osaEnabled: true, osaInstallBeforeScan: false, password: '{AQAAABAAAAAQ2fU/TC0tqbHpQ9jKY1RJeB+kieFINsHrF1Wnm+K9T6k=}', preset: '7', projectName: 'devsecops', sastEnabled: true, serverUrl: 'http://vsoc.mooo.com:1971', sourceEncoding: '1', username: '', vulnerabilityThresholdResult: 'FAILURE', waitForResultsEnabled: true])
          message = "\nJob: ${env.JOB_NAME} \nStage Checkmarx is Success. \nSee Report at \n${env.BUILD_URL}"
          notifyLINE("${linecicdnotify}", "${message}")
          notifyLINE("${linedev}", "${message}")
          //build 'archive'
        }    
      }
    }
    stage('CodeAnalysis') {
      steps {
        script {
          echo "Now Perform Code Analysis Steps"
          withCredentials([string(credentialsId: "${sonarCredId}", variable: 'TOKEN')]) {
            //sh 'echo $TOKEN'
            sh "./mvnw sonar:sonar -Dsonar.host.url=${SonarQubeURL}  -Dsonar.login=$TOKEN  -DskipTests=true"
          }
          message = "\nJob: ${env.JOB_NAME} \nStage CodeAnalysis is Success. \nSee Report at \n${SonarQubeURL}/dashboard?id=demo.web:demo.web"
          notifyLINE("${linecicdnotify}", "${message}")
          notifyLINE("${linesec}", "${message}")
        }
      }
    }
    stage('Build Image') {
      steps {
        script {
          echo "Now Perform Build Docker Image Steps" 
          withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${dockerCredId}",
            usernameVariable: 'Docker_User', passwordVariable: 'Docker_Password']]) {
            sh "set +x && echo Username=$Docker_User UserPwd=$Docker_Password URL=${dockerRepoURL}"
            sh "set +x && echo $Docker_Password | sudo docker login ${dockerRepoURL} -u $Docker_User --password-stdin"
          }
          sh "sudo docker build -t ${dockerRepoHost}/${dockerRepo}/demoapp:devlatest ."
          sh "sudo docker push ${dockerRepoHost}/${dockerRepo}/demoapp:devlatest"
          message = "\nJob: ${env.JOB_NAME} \nStage Build Image is Success. \nSee Image and Scan Result at \n${dockerRepoURL}/harbor/projects/2/repositories/demo%2Fdemoapp"
          notifyLINE("${linecicdnotify}", "${message}")
          notifyLINE("${linesec}", "${message}")
        }
      }
    }
    stage('Deploy DEV') {
      steps {
        script {
          echo "Now Perform Deploy DEV Steps"  
          sh "chmod +x ./kubernetes/buildyaml.sh"
          sh "export IMAGE_NAME=${dockerRepoHost}/${dockerRepo}/demoapp   && export BUILD_NUMBER='devlatest'  && ./kubernetes/buildyaml.sh"
          sh "sudo kubectl -n ${devenv} delete -f deployapp.yaml"
          sleep 3
          sh "sudo kubectl -n ${devenv} apply -f deployapp.yaml"
          //**************Wait for replica up *********
          repset=0
          repava=1
          while (repset != repava) {
            sleep 10
            repset=sh (returnStdout: true, script: """sudo kubectl get deployment demoapp -n ${devenv} -o jsonpath='{..replicas}'""")
            repava=sh (returnStdout: true, script: """sudo kubectl get deployment demoapp -n ${devenv} -o jsonpath='{..availableReplicas}'""")
            repset=repset.substring(0,1)
            echo "replicas = ***${repset}***"
            echo "availableReplicas = ***${repava}***"  
          }
          // ## Enable ingress
          sh "chmod +x ./kubernetes/buildingress.sh"
          sh "export ACCESS_URL='demoapp-${devenv}.${subDomain}'  && ./kubernetes/buildingress.sh" 
          sh "sudo kubectl -n ${devenv} apply -f deployingress.yaml" 
          //*******************************************
          message = "\nJob: ${env.JOB_NAME} \nStage Deploy DEV is Success. \nSee Try to test your app at \nhttp://demoapp-${devenv}.${subDomain}/"
          notifyLINE("${linecicdnotify}", "${message}")
          notifyLINE("${linedev}", "${message}")
          notifyLINE("${linetester}", "${message}")
        }
      }
    }
//    stage('IntegrationTest') {
//      steps {
//        script {
//          echo "Now Perform Integration Test Steps" 
//          // build 'build-docker-harbor'
//          //build 'build-docker-harbor-101'
//          sleep 10
//          sh "rm selenium-screenshot*.png"
//          sh "robot ./atdd/login.success.robot.grid.robot"
//          publishTestResults()
//          message = "\nJob: ${env.JOB_NAME} \nStage Integration test is done. \nSee test result at // \n${env.BUILD_URL}robot/"
//          notifyLINE("${linecicdnotify}", "${message}")
//          notifyLINE("${linetester}", "${message}")
//        }
//      }
//    }
    stage('Deploy UAT') {
      steps {
        timeout(time:600, unit:'MINUTES') {
            //input message: "Release version ${releaseTag} to UAT?", ok: "Approve"
            script {
              commitId = "${commitId}".substring(0,7)
			  releaseTag = "$releaseTag-$commitId"
              message = "\nJob: ${env.JOB_NAME} \nWait for Approve Deploy release version ${releaseTag} to UAT. \nDo action at \n${env.BUILD_URL}input/"
              notifyLINE("${linecicdnotify}", "${message}")
              notifyLINE("${linetester}", "${message}")
              notifyLINE("${lineoper}", "${message}")
              env.Reason = input message: "Release version ${releaseTag} to UAT?", ok: 'OK',
              submitterParameter: 'submitter',
              parameters: [choice(name: 'Reason', choices: ['Approve','Abort with Security concren', 'Abort with Unit test fail','Abort with Integration test fail','Abort with UAT environment not Ready','Pipeline testing'], description: 'What is the reason?'),booleanParam(name: 'approve', defaultValue: false, description: 'Check for Approve')]
            }
            echo '***' + env.Reason.indexOf('true')
            script {
              if (env.Reason.indexOf('true')==-1){
                  echo "Not Approve"
                  message = "\nJob: ${env.JOB_NAME} \nStage Deploy UAT Release version ${releaseTag} is NOT APPROVE by ${env.Reason}. \nSee more detail at\n${env.BUILD_URL}"
                  notifyLINE("${linecicdnotify}", "${message}")
                  notifyLINE("${linetester}", "${message}")
                  notifyLINE("${lineoper}", "${message}")
              } else {
                  echo "Approve Release version ${releaseTag} and Do deploy"
                  sh "sudo docker pull ${dockerRepoHost}/${dockerRepo}/demoapp:devlatest"
                  sh "sudo docker tag ${dockerRepoHost}/${dockerRepo}/demoapp:devlatest ${dockerRepoHost}/${dockerRepo}/demoapp:${releaseTag}"
                  sh "sudo docker push ${dockerRepoHost}/${dockerRepo}/demoapp:${releaseTag}"
                  sleep 3
                  sh "export IMAGE_NAME=${dockerRepoHost}/${dockerRepo}/demoapp   && export BUILD_NUMBER='${releaseTag}'  && ./kubernetes/buildyaml.sh"
                  sh "sudo kubectl -n ${uatenv} apply -f deployapp.yaml"

                  //**************Wait for replica up *********
                  repset=0
                  repava=1
                  while (repset != repava) {
                    sleep 10
                    repset=sh (returnStdout: true, script: """sudo kubectl get deployment demoapp -n ${uatenv} -o jsonpath='{..replicas}'""")
                    repava=sh (returnStdout: true, script: """sudo kubectl get deployment demoapp -n ${uatenv} -o jsonpath='{..availableReplicas}'""")
                    repset=repset.substring(0,1)
                    echo "replicas = ***${repset}***"
                    echo "availableReplicas = ***${repava}***"  
                  }
                  //*******************************************
                  sh "chmod +x ./kubernetes/buildingress.sh"
                  sh "export ACCESS_URL='demoapp-${uatenv}.${subDomain}'  && ./kubernetes/buildingress.sh" 
                  sh "sudo kubectl -n ${uatenv} apply -f deployingress.yaml" 
                  message = "\nJob: ${env.JOB_NAME} \nStage Deploy UAT Release version ${releaseTag} is APPROVE by ${env.Reason} and deploy success \nSee Try to test your app at \nhttp://demoapp-${uatenv}.${subDomain}/"
                  notifyLINE("${linecicdnotify}", "${message}")
                  notifyLINE("${linetester}", "${message}")
                  notifyLINE("${lineoper}", "${message}")
              }
            }
        }
      }
    }
  }
  post {
    failure {
        script {
          message = "\nJob: ${env.JOB_NAME} \nRESULT: FAILURE \nSee more at ${env.BUILD_URL}console"
          notifyLINE("${linecicdnotify}", "${message}")  
          notifyLINE("${linetester}", "${message}")
          notifyLINE("${lineoper}", "${message}")
          notifyLINE("${linedev}", "${message}")
        }
    }
    aborted {
        script {
          message = "\nJob: ${env.JOB_NAME} \nRESULT: ABORTED \nSee more at ${env.BUILD_URL}console"
          notifyLINE("${linecicdnotify}", "${message}")  
          notifyLINE("${linetester}", "${message}")
          notifyLINE("${lineoper}", "${message}")
          notifyLINE("${linedev}", "${message}")
        }
    }
    success {
        script {
          message = "\nJob: ${env.JOB_NAME} \nRESULT: SUCCESS \nReason is ${env.Reason} \nSee more at ${env.BUILD_URL}console"
          notifyLINE("${linecicdnotify}", "${message}")  
          notifyLINE("${linetester}", "${message}")
          notifyLINE("${lineoper}", "${message}")
          notifyLINE("${linedev}", "${message}")
        }
    }
  }
}
