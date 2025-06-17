package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// Tests for module route53_zones that tests public and private zones
func TestTerraformAwsNetworkExample(t *testing.T) {
	t.Parallel()

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	// awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	awsAzs := aws.GetAvailabilityZones(t, awsRegion)
	awsAzsLetters := []string{}

	for _, az := range awsAzs {
		letter := string(az[len(az)-1])
		awsAzsLetters = append(awsAzsLetters, letter)
	}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../example/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"region":             awsRegion,
			"availability_zones": awsAzsLetters,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	networkACL := terraform.Output(t, terraformOptions, "network_acl")
	routeTable := terraform.OutputMap(t, terraformOptions, "route_table")
	securityGroup := terraform.OutputMap(t, terraformOptions, "security_group")
	subnets := terraform.OutputListOfObjects(t, terraformOptions, "subnets")
	vpc := terraform.Output(t, terraformOptions, "vpc")

	// check outputs are not empty
	assert.NotEmpty(t, networkACL)
	assert.NotEmpty(t, routeTable)
	assert.NotEmpty(t, securityGroup)
	assert.NotEmpty(t, subnets)
	assert.NotEmpty(t, vpc)

	require.Equal(t, len(awsAzs), len(subnets))

	// Verify if the network that is supposed to be private is really private
	assert.False(t, aws.IsPublicSubnet(t, securityGroup["id"], awsRegion))
	assert.NotContains(t, routeTable["route"], "0.0.0.0")

}
