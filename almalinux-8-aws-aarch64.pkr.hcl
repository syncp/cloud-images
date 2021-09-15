/*
 * AlmaLinux OS 8 Packer template for building aarch64 AWS images.
 */

source "amazon-ebssurrogate" "almalinux-8-aws-aarch64" {
  region                  = "us-east-1"
  ssh_username            = "ec2-user"
  instance_type           = "t4g.micro"
  source_ami              = "ami-05410363fe9edf191"
  ami_name                = var.aws_ami_name_aarch64
  ami_description         = var.aws_ami_description_aarch64
  ami_architecture        = "arm64"
  ami_virtualization_type = "hvm"
  ami_regions             = ["us-east-1"]
  tags = {
    Name         = "${var.aws_ami_name_aarch64}",
    Version      = "${var.aws_ami_version}",
    Architecture = "aarch64"
  }
  ena_support = true


  launch_block_device_mappings {
    device_name           = "/dev/sdb"
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }
  ami_root_device {
    source_device_name    = "/dev/sdb"
    device_name           = "/dev/sda1"
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }
}


build {
  sources = [
    "sources.amazon-ebssurrogate.almalinux-8-aws-aarch64"
  ]
  provisioner "shell" {
    inline = ["sudo dnf -y install tree python39-pip && sudo python3 -m pip install ansible"]
  }
  provisioner "ansible-local" {
    playbook_dir   = "./ansible"
    playbook_file  = "./ansible/aws-ami-aarch64.yml"
    galaxy_file    = "./ansible/requirements.yml"
    galaxy_command = "ansible-galaxy collection install -r"
  }

}
