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

	awsDefaultRegion := aws.GetRandomStableRegion(t, nil, nil)
	awsSecondRegion := aws.GetRandomStableRegion(t, nil, nil)
	accountID := aws.GetAccountId(t)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest-%s", uniqueID)

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":              name,
			"provider_1_region": awsDefaultRegion,
			"provider_2_region": awsSecondRegion,
		},

		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsDefaultRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Act
	assert := assert.New(t)

	_, err := terraform.InitAndApplyE(t, terraformOptions)

	configBucket := terraform.Output(t, terraformOptions, "s3_bucket_name")

	assert.NotNil(t, aws.GetS3ObjectContents(t, awsDefaultRegion, configBucket, awsDefaultRegion+"/AWSLogs/"+accountID+"/Config/ConfigWritabilityCheckFile"))
	assert.NotNil(t, aws.GetS3ObjectContents(t, awsDefaultRegion, configBucket, awsSecondRegion+"/AWSLogs/"+accountID+"/Config/ConfigWritabilityCheckFile"))

	// Cleanup bucket to enable delete
	aws.EmptyS3Bucket(t, awsDefaultRegion, configBucket)

	if err != nil {
		//Force fail if apply errored, needs to be after bucket empty operation to ensure resources are cleaned up
		assert.FailNow(err.Error())
	}
}
