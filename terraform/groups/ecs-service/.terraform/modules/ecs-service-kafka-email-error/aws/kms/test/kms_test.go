package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest-%s", uniqueID)

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name": name,
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

	keyArn := terraform.Output(t, terraformOptions, "key_arn")
	assert.NotEmpty(t, keyArn)

	keyID := terraform.Output(t, terraformOptions, "key_id")
	assert.NotEmpty(t, keyID)

	keyAliasArn := terraform.Output(t, terraformOptions, "key_alias_arn")
	assert.NotEmpty(t, keyAliasArn)

	keyAliasName := terraform.Output(t, terraformOptions, "key_alias_name")
	assert.NotEmpty(t, keyAliasName)
}
