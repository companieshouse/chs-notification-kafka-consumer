package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	name := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
		Vars: map[string]interface{}{
			"name": name,
		},
		EnvVars: map[string]string{
			"AWS_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	assert := assert.New(t)

	bucketPolicyDocument := terraform.Output(t, terraformOptions, "s3_bucket_policy_document")
	assert.NotNil(bucketPolicyDocument)

	bucketName := terraform.Output(t, terraformOptions, "s3_bucket_name")

	aws.AssertS3BucketExists(t, awsRegion, bucketName)
	aws.AssertS3BucketPolicyExists(t, awsRegion, bucketName)
}
