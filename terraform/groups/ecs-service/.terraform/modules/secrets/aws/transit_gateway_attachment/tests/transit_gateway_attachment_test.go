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

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../example",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":                            "my-tgw-attachment",
			"create_tgw":                      true,
			"share_tgw":                       true,
			"default_route_table_association": false,
			"default_route_table_propagation": false,
			"dns_support":                     true,
			"ipv6_support":                    false,
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
	vpcAttachmentIds := terraform.OutputList(t, terraformOptions, "this_ec2_transit_gateway_vpc_attachment_ids")
	vpcAttachments := terraform.OutputMap(t, terraformOptions, "this_ec2_transit_gateway_vpc_attachment")

	// check outputs are not empty
	assert.NotEmpty(t, vpcAttachmentIds)
	assert.NotEmpty(t, vpcAttachments)

	// Check lengths of routes and vpc attachments are correct
	require.Equal(t, len(vpcAttachmentIds), 1)
	require.Equal(t, len(vpcAttachments), 1)
}
