# Tikal-demo
In this demo we will provistion jenkins in aws following the setup ci env steps, then we will configure a pipeline maven job finially we will run it

# SETUP CI ENV
1. Clone the project 
2. Initialzed terraform terrafom init
3. terraform apply
2. Save the adminPasswrod from the terrafom apply output:
   “aws_instance.prod_web[0] (remote-exec): Enter <SOME HASH> to activate jenkins”
3. get the instance public ip to access jenkins
  terraform show | grep public_dns 
4. Put the public-ip:9090
5. Enter the adminPassword see item 2
6. Install suggested plugins
7. Set admin credentials 
8. Manage Jenkins —> Manage plugin —> available --> Global configuration add maven
9. Create new pipeline job using this project as git utl and use the jenkinsfile in this repo as pipeline file

# Mave Project:

1. build a war (helloworld.war)
2. Create a docker image and copy the helloworld.war (docker-maven-plugin)
3. Start a container from this docker image (docker-maven-plugin)
4. Validate that the container is live - ping using (docker-maven-plugin)
5. Stop the continer (docker-maven-plugin)
