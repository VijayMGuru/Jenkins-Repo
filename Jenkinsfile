pipeline{
    agent any
    stages{
        stage("Clean Reports"){
            steps{
                echo "========Cleaning Workspace Stage Started========"
                sh 'rmdir /s /q test-reports'
                echo "========Cleaning Workspace Stage Finished========"
            }
            }
        stage("Build Stage"){
            steps{
                echo "========Build Stage Started========"
                sh 'pip install -r requirements.txt'
                sh 'pyinstaller --onefile app.py'
                echo "========Build Stage Finished========"
            }
            }
        stage("Testing Stage"){
            steps{
                echo "========Testing Stage Started========"
                sh 'python test.py'
                echo "========Testing Stage Finished========"
            }
            }
        stage('Configure Artifactory'){
            steps{
                script {
          
                    echo '********* Configure Artifactory Started **********'
                    def userInput = input(
                    id: 'userInput', message: 'Enter password for Artifactory', parameters: [
             
                    [$class: 'TextParameterDefinition', defaultValue: 'password', description: 'Artifactory Password', name: 'password']])
             
                    sh 'jfrog rt c artifactory-demo --url=http://20.239.48.149:8081/artifactory --user=admin --P@ssw0rd@123='+userInput
             
                    echo '********* Configure Artifactory Finished **********'
                    }
                }
            }
        stage("Sanity check"){
            steps{
                input "Does the staging environment looks ok?"        
                }
            }
        stage("Deployment Stage"){
            steps{
                input "Do you want to Deploy the application?"
                echo '********* Deploy Stage Started **********'
                timeout(time : 1, unit : 'MINUTES')
                {
                sh 'python app.py'
                }
                echo '********* Deploy Stage Finished **********'
                }
            }   
        }    
    post{
        always{
                echo "we came to an end"
                archiveArtifacts artifacts: 'dist/*.exe', fingerprint: true
                junit 'test-reports/*.xml'
                script{
                    if(currentBuild.currentResult=='SUCCESS')
                {
                    echo '********* Uploading to Artifactory is Started **********'
                    /*sh 'jfrog rt u "dist/*.exe" generic-local'*/
                    sh 'Powershell.exe -executionpolicy remotesigned -File build_script.ps1'
                    echo '********* Uploading Finished **********'
                }
                    }
                    deleteDir()
                }
        success{
            echo "Build completed successfully"
        }
        failure{
            echo 'Sorry mate! build is Failed'
        }
        unstable {
            echo 'Run was marked as unstable'
        }
        changed {
            echo 'Hey look at this, Pipeline state is changed.'
        }
    }
}