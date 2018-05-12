resource "aws_instance" "mbottini-webserver-1" {
  ami = "ami-43a15f3e"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  #availability_zone = "us-east-1"

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
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

resource "aws_subnet" "us-east-1-public" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "172.10.10.0/25"
  availability_zone = "us-east-1a"
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
