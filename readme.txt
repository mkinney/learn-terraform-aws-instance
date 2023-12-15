# Note: Started from https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build

tf plan
tf apply

# depending on which ami, the user could be "ec2-user" or "ubuntu"
   ssh -i ~/.ssh/id_rsa ec2-user@52.36.175.130
or
   ssh -i ~/.ssh/id_rsa ubuntu@52.36.175.130

# TODO: there's gotta be a better way
 tf state show 'aws_instance.app_server' | grep public_dns
    public_dns                           = "ec2-34-222-139-228.us-west-2.compute.amazonaws.com"
# added an output, but would like to be able query this via the command line, too

ansible myhosts -m ping -i inventory.ini

tf destroy
