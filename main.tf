# Provider
provider "aws" {
    region = var.aws_region
}

# Key Pair for EC2
resource "aws_key_pair" "deployer" {
    key_name    = "deployer-key"
    public_key  = file(var.public_key_path)
}

# Security Group
resource "aws_security_group" "web_sg" {
    name        = "web_sg"
    description = "Allow HTTP and SSH"


    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# EC2 Instance
resource "aws_instance" "web_server" {
    ami         = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI (adjust region-specific ID)
    instance_type = "t2.micro"
    key_name      = aws_key_pair.deployer.key_name
    security_groups = [aws_security_group.web_sg.name]

    user_data = <<-EOF
                #!bin/bash
                sudo yum update -yum
                sudo yum install python3 -y
                pip3 install flask
                echo '${file("app/app.py")}' > /home/ec2-user/app.py
                FLASK_APP=/home/ec2-user/app.py flask run --host=0.0.0.0 --port=80 &
            EOF
      tags = {
    Name = "WebServer"
  }
}