package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Contains checks if the Networks Objects list contains Ids from the Subnet Ids list
func Contains(networks []map[string]interface{}, ids []string) bool {
	for _, net := range networks {
		for _, item := range net {
			for _, id := range ids {
				if id == item {
					return true
				}
			}
		}
	}
	return false
}

// Tests for module route53_zones that tests public and private zones
func TestTerraformAwsNetworkExample(t *testing.T) {
	t.Parallel()

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	totalAzZones := len(aws.GetAvailabilityZones(t, awsRegion))

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../example/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"networks": []interface{}{
				map[string]interface{}{
					"name":     "web",
					"new_bits": 8,
				},
				map[string]interface{}{
					"name":     "db",
					"new_bits": 8,
				},
			},
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

	vpc := terraform.OutputMap(t, terraformOptions, "vpc")
	vpcID := vpc["id"]
	networks := terraform.OutputListOfObjects(t, terraformOptions, "networks")
	subnetIds := terraform.OutputList(t, terraformOptions, "subnet_ids")
	namedSubnets := terraform.OutputMap(t, terraformOptions, "named_subnet_ids")
	subnets := aws.GetSubnetsForVpc(t, vpcID, awsRegion)

	// check outputs are not empty
	assert.NotEmpty(t, networks)
	assert.NotEmpty(t, subnetIds)
	assert.NotEmpty(t, namedSubnets)

	assert.Len(t, networks, (totalAzZones * 2))
	assert.Len(t, subnets, (totalAzZones * 2))
	assert.Len(t, subnetIds, (totalAzZones * 2))
	assert.Len(t, namedSubnets, (totalAzZones * 2))

	Contains(networks, subnetIds)
}
