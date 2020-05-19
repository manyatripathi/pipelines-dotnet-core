def readProperties()
{

	def properties_file_path = "${workspace}" + "@script/properties.yml"
	def property = readYaml file: properties_file_path
    env.MS_NAME = property.MS_NAME
    env.BRANCH = property.BRANCH
    env.GIT_SOURCE_URL = property.GIT_SOURCE_URL
    env.SCR_CREDENTIALS = property.SCR_CREDENTIALS
    env.SONAR_HOST_URL = property.SONAR_HOST_URL
    env.CODE_QUALITY = property.CODE_QUALITY
    env.UNIT_TESTING = property.UNIT_TESTING
    env.CODE_COVERAGE = property.CODE_COVERAGE
   
    
}


podTemplate(cloud:'openshift',label: 'dotnet',
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'manya97/jnlp-slave-dotnet:multi',
      alwaysPullImage: false,
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
       
       	   stage('Initial Setup')
        	   {
        			//sh 'dotnet clean'
        			sh 'dotnet restore'
        			sh 'dotnet tool install --global dotnet-sonarscanner --version 4.8.0'          			
        	   }
        	
           
        	if(env.UNIT_TESTING == 'True')
           {
           	stage('Unit Testing')
           	{
                	sh 'dotnet test'
           	}
           }
   
           if(env.CODE_COVERAGE == 'True')
           {
           	stage('Code Coverage')
           	{
           	    sh 'dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover'
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

