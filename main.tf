provider "aws" {
  region     = "eu-west-1"  # Ireland region
  access_key = "AKIA6G75DQ33PRQDQVOF"  # Your AWS access key
  secret_key = "fhUikRsZTy20a1emy6EFfvOtXSAC5LogbLL7nhtu"  # Your AWS secret key
}

# Generate a new private key for the EC2 instance
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create the key pair within Terraform (without needing an existing public key)
resource "aws_key_pair" "example" {
  key_name   = "my-key-pair"  # The key pair name
  public_key = tls_private_key.example.public_key_openssh  # Use the generated key
}

# Create an EC2 instance using the key pair
resource "aws_instance" "example" {
  ami           = "ami-09b5145b08259b3ac"  # The AMI ID you've provided
  instance_type = "t2.micro"               # Instance type
  key_name      = aws_key_pair.example.key_name  # Reference the key pair
  associate_public_ip_address = true        # Ensure a public IP is assigned

  # Enable CloudWatch logs for the instance
  monitoring = true  # Enable detailed monitoring for CloudWatch

  tags = {
    Name = "example-instance"
  }

  # Log EC2 instance creation success
  lifecycle {
    create_before_destroy = true
  }
}

# Output the private key for use
output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

# Log the public IP of the instance after creation
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

# Log the private IP of the instance after creation
output "instance_private_ip" {
  value = aws_instance.example.private_ip
}
