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

Now, something like this:
    curl http://ec2-18-237-103-32.us-west-2.compute.amazonaws.com:8080
Should return:
    Hello, World

terraform plan -var "web_server_port=8080"
or
export TF_VAR_web_server_port=8080

mkdir test
go mod init github.com/mkinney/learn-terraform-aws-instance
go mod tidy
create test/basic_test.go

go test test/basic_test.go
ok  	command-line-arguments	96.216s

# to see output
go test -v test/basic_test.go

Tip: If you temporarily comment out the "defer terraform.Destroy..." line,
you can quickly iterate on the validations.

tf destroy
