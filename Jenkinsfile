def readProperties()
{

	def properties_file_path = "${workspace}" + "@script/properties.yml"
	def property = readYaml file: properties_file_path
	env.APP_NAME = property.APP_NAME
    env.MS_NAME = property.MS_NAME
    env.BRANCH = property.BRANCH
    env.GIT_SOURCE_URL = property.GIT_SOURCE_URL
    env.SCR_CREDENTIALS = property.SCR_CREDENTIALS
    env.SONAR_HOST_URL = property.SONAR_HOST_URL
    env.CODE_QUALITY = property.CODE_QUALITY
    env.UNIT_TESTING = property.UNIT_TESTING
    env.CODE_COVERAGE = property.CODE_COVERAGE
    env.FUNCTIONAL_TESTING = property.FUNCTIONAL_TESTING
    env.SECURITY_TESTING = property.SECURITY_TESTING
	env.PERFORMANCE_TESTING = property.PERFORMANCE_TESTING
	env.TESTING = property.TESTING
	env.QA = property.QA
	env.PT = property.PT
	env.User = property.User
    env.DOCKER_REGISTRY = property.DOCKER_REGISTRY
    env.DOCKER_REPO=property.DOCKER_REPO
	
	
    
}


podTemplate(cloud:'kubernetes',label: 'dotnet',
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'manya97/jnlp-slave-dotnet:multi01',
      alwaysPullImage: true,
      privileged: true,
      envVars: [envVar(key:'http_proxy',value:''),envVar(key:'https_proxy',value:'')],
      args: '${computer.jnlpmac} ${computer.name}',
      ttyEnabled: true
    )])
{
def PROXY_URL
node 
{
   stage('Read properties')
   {
       readProperties()
       checkout([$class: 'GitSCM', branches: [[name: "*/${BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: "${SCR_CREDENTIALS}", url: "${GIT_SOURCE_URL}"]]])
   }
   
    node('dotnet') 
    {   
    
       stage('Checkout')
       {
           checkout([$class: 'GitSCM', branches: [[name: "*/${BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: "${SCR_CREDENTIALS}", url: "${GIT_SOURCE_URL}"]]])
       }
       withCredentials([usernamePassword(credentialsId: "${SCR_CREDENTIALS}", usernameVariable: 'username', passwordVariable: 'password')])
       {
            PROXY_URL="http://$username:$password@10.74.91.103:80"
        }
       
      
           withEnv(["http_proxy=${PROXY_URL}","https_proxy=${PROXY_URL}"]) 
           {
        	   stage('Initial Setup')
        	   {
        			//sh 'dotnet clean'
        			sh 'dotnet restore'
        			sh 'dotnet tool install --global dotnet-sonarscanner --version 4.8.0'          			
        	   }
        	
            }	
        	if(env.UNIT_TESTING == 'True')
           {
           	stage('Unit Testing')
           	{
                	sh 'dotnet test'
           	}
           }
   
        	/*if(env.CODE_COVERAGE == 'True')
           {
           	stage('Code Coverage')
           	{
           	    sh 'dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover'
           	}
           }*/
   
       if(env.CODE_QUALITY == 'True')
           { 	
          stage('Code Quality and Build')
            {

                //sh "/home/jenkins/.dotnet/tools/dotnet-sonarscanner begin  /d:sonar.host.url=${SONAR_HOST_URL} /d:sonar.login=admin /d:sonar.password=admin /key:${MS_NAME} /d:sonar.cs.opencover.reportsPaths='dir\coverage.opencover.xml\'"

              sh "/home/jenkins/.dotnet/tools/dotnet-sonarscanner begin  /d:sonar.host.url=${SONAR_HOST_URL} /d:sonar.login=admin /d:sonar.password=admin /key:${MS_NAME}"
                  sh 'dotnet build'
                sh "/home/jenkins/.dotnet/tools/dotnet-sonarscanner end /d:sonar.login=admin /d:sonar.password=admin"
            }		
    	    }
			
			stage('Build')
        	   {
        	        
            		sh 'dotnet build'
            			
        	   }

        	   
    	   stage('Publish')
    	   {
    	        sh 'dotnet publish --no-build -o ./PublishOutput'
    	        dir('./PublishOutput')
    	        {
    	            stash name : 'publishoutput' , includes : '**'
    	        }
    	        
    	   }

    }


       
    

   
   

}
}
}