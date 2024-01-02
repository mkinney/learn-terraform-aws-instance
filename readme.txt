Experiment with terraform and ansible.

# Note: Started from https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build

terraform init
terraform plan
terraform apply

# depending on which ami, the user could be "ec2-user" or "ubuntu"
   ssh -i ~/.ssh/id_rsa ec2-user@52.36.175.130
or
   ssh -i ~/.ssh/id_rsa ubuntu@52.36.175.130

# TODO: Is there a better way to get a specific attribute?
 terraform state show 'aws_instance.app_server' | grep public_dns
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

# Using terratest
mkdir test
go mod init github.com/mkinney/learn-terraform-aws-instance
go mod tidy
create test/basic_test.go

go test test/basic_test.go
ok  	command-line-arguments	96.216s

# to see verbose output
go test -v test/basic_test.go

Tip: If you temporarily comment out the "defer terraform.Destroy..." line,
you can quickly iterate on the validations.

# for some analysis
brew install golangci-lint
brew install tflint
brew install yamllint

# using Ansible playbooks against the instance(s)
ansible-galaxy collection install datadog.dd
be sure to export DD_API_KEY
go into Data Dog and create an Application Key and export it as DD_APP_KEY
  be sure to edit scope to have events_read
Note: Can create an event via script, but it is not visible in the dashboard nor can I get it from curl. Not sure why yet.
  {"errors":["Forbidden"]}

Be sure to take a look at the Makefile targets.

terraform destroy
