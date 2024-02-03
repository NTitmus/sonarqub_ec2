# Declaring the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "Sonarqube" {
  ami                    = "ami-0aaa5410833273cfe" # free tier AMI image
  instance_type          = "t2.medium"
  user_data              = file("sonar_script.sh")
  vpc_security_group_ids = [aws_security_group.ec2.id]
  #key_name               = "new-eks" # Existing ssh key 

  tags = {
    Name = "Sonarqube_Instance"
  }
}


#data "aws_route53_zone" "selected" {
#  name         = "robofarming.link"
#  private_zone = false
#}

#resource "aws_route53_record" "domainName" {
#  name    = "sonar"
#  type    = "A"
#  zone_id = data.aws_route53_zone.selected.zone_id
#  records = [aws_instance.Sonarqube.public_ip]
#  ttl     = 300
#  depends_on = [
#    aws_instance.Sonarqube
#  ]
#}