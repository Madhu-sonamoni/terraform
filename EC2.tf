resource "aws_key_pair" "kp" {
  key_name = "testkey"
  public_key = file("./testkey.pub")
}

resource "aws_instance" "VM1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.kp.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.pub_sns.*.id[0]
  user_data = <<EOF
    #! /bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "<h1>Deployed via Terraform<h1>" | sudo tee /var/www/html/index.html
  EOF
  tags = {
    "Name" = "Terraform"
  }
}