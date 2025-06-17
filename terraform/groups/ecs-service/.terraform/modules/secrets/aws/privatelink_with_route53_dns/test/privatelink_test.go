package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestPrivateLinkExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest-%s", uniqueID)

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":         name,
			"service_name": "logs",
			"region":       awsRegion,
		},

		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

	endpoint := terraform.OutputMap(t, terraformOptions, "endpoint")
	assert.NotEmpty(t, endpoint)

	route53 := terraform.OutputMap(t, terraformOptions, "r53")
	assert.NotEmpty(t, route53)

	endpointDNS := terraform.OutputMap(t, terraformOptions, "r53_record")
	assert.NotEmpty(t, endpointDNS)
}
