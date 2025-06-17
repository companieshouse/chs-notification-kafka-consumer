package test

import (
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/directconnect"
	terratestaws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := terratestaws.GetRandomStableRegion(t, nil, nil)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../example/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"amazon_side_asn": 65200,
			"name":            "test",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` and ensure outputs are present and match the expected values
	dxGatewayID := terraform.Output(t, terraformOptions, "dx_gateway_id")
	assert.NotEmpty(t, dxGatewayID)
	assert.Regexp(t, "^\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}$", dxGatewayID)

	// Get AWS session and directconnect client
	sess, _ := session.NewSession(&aws.Config{
		Region: aws.String(awsRegion)},
	)
	directConnectSvc := directconnect.New(sess)

	// Describe DirectConnectGateways filtered by ID, assert there is only one match and that it is in 'available' state
	input := &directconnect.DescribeDirectConnectGatewaysInput{
		DirectConnectGatewayId: aws.String(dxGatewayID),
	}
	output, _ := directConnectSvc.DescribeDirectConnectGateways(input)
	assert.Equal(t, 1, len(output.DirectConnectGateways))
	for _, gateway := range output.DirectConnectGateways {
		assert.Equal(t, "available", aws.StringValue(gateway.DirectConnectGatewayState))
	}
}
