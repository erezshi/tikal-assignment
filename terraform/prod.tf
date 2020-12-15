variable "jenkins_port" {
  type = string
}
variable "tomcat_port" {
  type = string
}
variable "public_key" {
  type = string
}
variable "whitelist"  {
  type = list(string)
}
variable "web_ami" {
  type = string
}   
variable "web_instance_type" {
  type = string
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_key_pair" "admin" {
  key_name   = "admin-key"
  public_key = var.public_key
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-central-1a"
  tags = {
    "Terrafom" : "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-central-1b"
  tags = {
    "Terrafom" : "true"
  }
}


resource "aws_security_group" "prod_web" {
  name = "prod_web"
  description = "Allow standard http and 9090 ports inbound and everything outbound and ssh"

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
   ingress {
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
    ingress {
    from_port   = var.tomcat_port
    to_port     = var.tomcat_port
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terrafom" : "true"
  }
}

resource "aws_instance" "prod_web" {
  count = 1

  ami           = var.web_ami
  instance_type = var.web_instance_type 
  key_name = aws_key_pair.admin.key_name
  
    provisioner "file" {
    source      = "files/install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host     = aws_instance.prod_web.0.public_ip
    }

  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sudo /tmp/install_jenkins.sh",
    ]
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host     = aws_instance.prod_web.0.public_ip
    }

    # depends_on = [aws_instance.prod_web.file]
  }
  provisioner "local-exec" {
    command    = "echo The server's IP address is ${self.private_ip}"
    on_failure = continue
  }


  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]
  
  tags = {
    "Terrafom" : "true"
  }
}

resource "aws_eip_association" "prod_web"{
  instance_id   = aws_instance.prod_web.0.id
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
  tags = {
    "Terrafom" : "true"
  }
}
 
resource "aws_elb" "prod_web" {
  name            = "prod-web"
  instances       = aws_instance.prod_web.*.id
  subnets         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.prod_web.id]

  listener {
    instance_port     = var.default_port
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags = {
    "Terrafom" : "true"
  }

}
