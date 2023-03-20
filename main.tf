# Declaring the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-focal-20.04-amd64-server-*"]
  }

}

resource "aws_instance" "Sonarqube" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  user_data              = file("sonar_script.sh")
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "Sonarqube_Instance"
  }
}


data "aws_route53_zone" "selected" {
  name         = "robofarming.link"
  private_zone = false
}

resource "aws_route53_record" "domainName" {
  name    = "sonar"
  type    = "A"
  zone_id = data.aws_route53_zone.selected.zone_id
  records = [aws_instance.Sonarqube.public_ip]
  ttl     = 300
}