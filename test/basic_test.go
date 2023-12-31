package test

import (
	"fmt"
	"net"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestTerraformBasicExample(t *testing.T) {
	t.Parallel()

	planFilePath := filepath.Join(".", "plan.out")
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "..",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,

		// Configure a plan file path so we can introspect the plan and make assertions about it.
		PlanFilePath: planFilePath,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	// terraform.InitAndApply(t, terraformOptions)

	// Run `terraform init`, `terraform plan`, and `terraform show` and fail the test if there are any errors
	plan := terraform.InitAndPlanAndShow(t, terraformOptions)

	// Idempotency check
	terraform.ApplyAndIdempotent(t, terraformOptions)

	// Ensure resources exist
	assert.Equal(t, true, strings.Contains(plan, "aws_key_pair.ssh_key"))
	assert.Equal(t, true, strings.Contains(plan, "aws_security_group.mike_ssh"))
	assert.Equal(t, true, strings.Contains(plan, "aws_security_group.web_instance"))
	assert.Equal(t, true, strings.Contains(plan, "aws_instance.web_server"))

	// Run `terraform output` to get the values of output variables

	// ensure this is output
	instancePublicIp := terraform.Output(t, terraformOptions, "instance_public_ip")
	// ensure valid ip address
	assert.NotEqual(t, nil, net.ParseIP(instancePublicIp))

	instancePublicDns := terraform.Output(t, terraformOptions, "instance_public_dns")

	// Make an HTTP request to the IP and make sure we get back a 200 OK with the body "Hello, World"
	url := fmt.Sprintf("http://%s:8080", instancePublicIp)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, World", 30, 5*time.Second)

	// Make an HTTP request to the DNS name and make sure we get back a 200 OK with the body "Hello, World"
	url = fmt.Sprintf("http://%s:8080", instancePublicDns)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, World", 30, 5*time.Second)

	// Make sure we can run ansible ping (probably a better way to do this), which also
	// validates that you can ssh to this instance.
	// Note that the inventory file has to reference the directory above
	cmd := exec.Command("ansible", "myhosts", "-m", "ping", "-i", "../inventory.ini")
	fmt.Println("cmd:", cmd)
	out, err := cmd.CombinedOutput()
	assert.Equal(t, nil, err)
	fmt.Println("out:", string(out))
	assert.Equal(t, true, strings.Contains(string(out), "pong"))

}
