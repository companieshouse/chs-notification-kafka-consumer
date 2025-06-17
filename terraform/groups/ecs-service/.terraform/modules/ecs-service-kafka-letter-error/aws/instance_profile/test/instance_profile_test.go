package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// InstanceProfile test function
func TestInstaceProfile(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest-%s", uniqueID)

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
		Vars: map[string]interface{}{
			"name":   name,
			"region": awsRegion,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert := assert.New(t)

	iamPolicy := terraform.OutputMap(t, terraformOptions, "aws_iam_policy")
	assert.NotEmpty(iamPolicy)

	iamRole := terraform.OutputMap(t, terraformOptions, "aws_iam_role")
	assert.NotEmpty(iamRole)

	iamRoleAttachment := terraform.OutputMap(t, terraformOptions, "aws_iam_role_policy_attachment")
	assert.NotEmpty(iamRoleAttachment)

	iamProfile := terraform.OutputMap(t, terraformOptions, "aws_iam_instance_profile")
	assert.NotEmpty(iamProfile)
}
