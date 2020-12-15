# Tikal-demo
In this demo we will provistion jenkins in aws following the setup ci env steps, then we will configure a pipeline maven job finially we will run it

# Prerequisite 
1. aws account 
2. setup progrematic aws ec2 user and create ~/.aws/credentials file with aws_access_key_id aws_secret_access_key
3. Make sure you have terrafom install locally

# SETUP CI ENV
1. Clone the project to workdir
2. cd terraform/ && terraform init
2. Edit terraform.tfvars and set your ~/.ssh/id_rsa.pub as the value for public_key also set whitelist var I.E ["172.31.0.0/16", "your public ip/32"]
3. terraform apply (or first plan :-) and wait for the job to finish.
2. Save the adminPasswrod from the terrafom apply output:
   “aws_instance.prod_web[0] (remote-exec): Enter <SOME HASH> to activate jenkins”
3. get the instance public ip to access jenkins
  terraform show | grep public_dns 
4. Put the public-ip:9090
5. Enter the adminPassword see item 2
6. Install suggested plugins
7. Set admin credentials 
8. Manage Jenkins —> Manage plugin —> available --> Global Tool configuration and add maven
9. Create new pipeline job "script from scm" using this project as git utl and use the jenkinsfile in this repo as pipeline file and run the job

# Mave Project:

1. build a war (helloworld.war)
2. Create a docker image and copy the helloworld.war (docker-maven-plugin)
3. Start a container from this docker image (docker-maven-plugin)
4. Validate that the container is live - ping using (docker-maven-plugin)
5. Stop the continer (docker-maven-plugin)
