#!/bin/bash

#Install docker
# yum update -y
amazon-linux-extras install docker -y
systemctl start  docker
systemctl enable  docker
systemctl status docker
usermod -a -G docker ec2-user
useradd jenkins
usermod -a -G docker jenkins
#Install git
yum install git -y

#Install Java
yum install java-1.8.0-openjdk-devel -y 
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum makecache
#Install jenkins
yum install jenkins -y 
yum install nc -y 
systemctl daemon-reload
#change default port from 8080 to 9090
sed -i 's/JENKINS_PORT=\"8080\"/JENKINS_PORT=\"9090\"/g' /etc/sysconfig/jenkins
#Start jenkins
systemctl start jenkins && sleep 10
systemctl status jenkins
systemctl enable jenkins
#Check jenkins status
get_status () {
 not_ready=true
 nc -z 127.0.0.1 9090
 if [ $? -ne 0 ]
 then
   echo "waiting for jenkins to start"
else
   echo "Jenkins starts successfully"
   not_ready=false
fi
}

while $not_ready
do
  get_status
  sleep 5
done


while [ ! -f "/var/lib/jenkins/secrets/initialAdminPassword" ]
do
        echo "waiting for admin password"
        sleep 5
done

adminPass=`cat /var/lib/jenkins/secrets/initialAdminPassword`
echo "Enter ${adminPass} to activate jenkins"
