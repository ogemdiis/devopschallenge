

resource "aws_instance" "web" {
  for_each = aws_subnet.public_subnet 
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = aws_security_group.webserver_sg.id
  user_data = <<EOF
    #!/bin/bash
    echo "Copying the SSH Key to the remote server"
    echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDvhXuMn9FwsrcK/DkgOlZdQFbY9e0+InX2sdHm8ZF7hGOQvg3CTMdBtMHlALnzqsYlS0aN0puzNF7fWAvUawdGjcSYxKEMlO1CaKPYxEgLTPDdiuYm3DNUutNMOLB0KHSJDk1Vb83UEpXm4vZjAWwHQTgoSsyXA57GcV4+IiTOy+iIIiiB7XzTDjt7ePVOW237HJAENlB/txh0qEl4Gn0eNGykg2E00jN8cOfIf/sKuY2kXBRgSjTjr6HArB4an6+aJpNJMWFFLyk47+NOIepaZhJNuXL39y0kGp/KzTlQw45g+ct92CSoCvySGqSUGN85ofPeYfzwB45yVJ9bMrZpY88TG4kLGAFeAg4DHVxUmJQhbjQOBRL8FDadOZuHmawlBUNeqFFtQ1EAad9Z2FWAZ80htaPysE9coA2VXC559VapIs9fsx2nPStKoB8bPP91rArS4Q9tt077+BgPE3d4IK2GRTYsC1TXzrF6hvGGk9zk+nWpZMqDtW5sQxdxl0k=" >> /home/ubuntu/.ssh/authorized_keys
EOF
  subnet_id = each.value.subnet_id

}
output "instances" {
  value       = aws_instance.web
  description = "All Machine details"
}


resource "aws_instance" "internal" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet.id
  tags = {
    Name = "Internal"
  }
}