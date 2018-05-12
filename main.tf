resource "aws_instance" "mbottini-webserver-1" {
  ami = "ami-43a15f3e"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  availability_zone = "us-east-1a"
  subnet_id = "${aws_subnet.us-east-1a.id}"
  associate_public_ip_address = true
  
 
  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  
   connection {
    type     = "ssh"
    user     = "ubuntu"
    host_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMbc7y3zWYSvY0JxUnSL6Yf9jFvMhMSdAb3vx0O4//L6TNNOr/LIyGqEK3WjJ4/uqyE/jfKoQ2gexjm4h0MJDRaQAKbJYnEa2WVhlhn+M//URBtof7p7OmrCby9lgwDCf06RTPdvw349H64bEwFTZIG6oJo2kI/8SvCj2DdhrAIkL7cgQo6AHTOkmBofSNg/pt5BvtgGIxnwsKO6C/GXghHUfQUqQcGCpDZNoJAlnPGF1uavpIWnmaw9NGWelyj0+6SBrKM9cQNfq1WA3fNv18I2MaMclb2ND7BzkRQMEQGwFa0GPq+7MU/0VyCqylRleYodq+MubyVB0tiORLxXLemRrhUEbzNc3wco8sQDsPUEX3XrDvPzzLqfW+SKiHNbQxYklVmWsZGxKgID3u2Wt20A0Kz3SRbWBWB8UnAgnXkH7YDHnOse+k2byh+qP/k7h9l2q/6/TevfZbw+fkRV4++tRhDyaXarmj15TNBbK76DtN0j3ocFDtxKMKfC3f2LB1FEJ+xZga9yhjbRWMZ7R+vPUDycL2MuxQiJKdoV3b5ettycaD05QT+kPj1VfVTuQ2nah44dMByWCH6zZvDqoeGfMOrCDbSDNWWweXeglfKun2KN7ipXIGpwSM4FdZDRaDLfL8F0ock/TQ9C6IvcMKKu66X5cwxLjUIYmdzYk96w== mbottini@ballooning"
    
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }

  tags {
    Name = "mbottini-webserver-1"
  }

  # the public SSH key
  key_name = "mbottini-softtek"

}

resource "aws_vpc" "main" {
  cidr_block = "172.10.10.0/24"
}

resource "aws_subnet" "us-east-1a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "172.10.10.0/25"
  availability_zone = "us-east-1a"
}


resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
        Name = "InternetGateway"
    }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}



resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = "${aws_instance.mbottini-webserver-1.public_ip}"
}
