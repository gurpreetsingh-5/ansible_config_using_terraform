resource "aws_instance" "myinst" {
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    key_name = aws_key_pair.myawskey.key_name
    tags =  {
        "Name" = "master" 
    } 
    depends_on = [ aws_key_pair.myawskey ]
    security_groups = [ "all-traffic" ] 
    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("/home/gur/.ssh/id_rsa")
    }
    provisioner "file" {
        source = "/home/gur/.ssh/id_rsa"
        destination = "/home/ubuntu/.ssh/id_rsa"   
    }

    provisioner "remote-exec" {
      inline = [ "sudo hostnamectl set-hostname master ",
      "chmod 400 /home/ubuntu/.ssh/id_rsa"  ]
    }
    user_data = <<-EOF
                            #!/bin/bash
                            apt update
                            apt install software-properties-common
                            add-apt-repository --yes --update ppa:ansible/ansible
                            apt install ansible -y
                            EOF
}
resource "aws_instance" "myinst1" {
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    key_name = aws_key_pair.myawskey.key_name
    tags =  {
        "Name" = "worker1" 
    } 
    depends_on = [ aws_key_pair.myawskey ]
    security_groups = [ "all-traffic" ] 
    user_data  = <<-EOF
                              #!/bin/bash
                              hostnamectl set-hostname worker1
                            EOF
}
resource "aws_instance" "myinst2" {
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    key_name = aws_key_pair.myawskey.key_name
    tags =  {
        "Name" = "worker2" 
    } 
    depends_on = [ aws_key_pair.myawskey ]
    security_groups = [ "all-traffic" ] 
       user_data  = <<-EOF
                              #!/bin/bash
                              hostnamectl set-hostname worker2
                            EOF
}
resource "aws_key_pair" "myawskey" {
  public_key = file("/home/gur/.ssh/id_rsa.pub")
  key_name = "myterrakey"
}
