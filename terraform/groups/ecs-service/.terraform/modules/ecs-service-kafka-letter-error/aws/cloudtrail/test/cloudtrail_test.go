package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	awssdk "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/cloudtrail"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

const awsRegion = "eu-west-2"

func NewCloudTrailClientE(t *testing.T, region string) (*cloudtrail.CloudTrail, error) {
	sess, err := aws.NewAuthenticatedSession(region)
	if err != nil {
		return nil, err
	}
	return cloudtrail.New(sess), nil
}

func IsLogging(t *testing.T, region string, trailName string) (bool, error) {
	cloudTrailClient, err := NewCloudTrailClientE(t, region)
	if err != nil {
		return false, err
	}
	params := &cloudtrail.GetTrailStatusInput{
		Name: awssdk.String(trailName),
	}

	trailStatus, err := cloudTrailClient.GetTrailStatus(params)
	if err != nil {
		return false, err
	}
	return *trailStatus.IsLogging, nil
}

func TestTerraformAwsCloudtrailEncryption(t *testing.T) {

	testName := fmt.Sprintf("terratest-aws-cloudtrail-%s", strings.ToLower(random.UniqueId()))
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "example")

	terraformOptions := &terraform.Options{
		TerraformDir: tempTestFolder,
		Vars: map[string]interface{}{
			"trail_name":                testName,
			"cloudwatch_log_group_name": testName,
			"logs_bucket":               testName,
			"region":                    awsRegion,
			"s3_key_prefix":             "testName",
			"kms_name":                  testName,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	cloudtrailArn := terraform.Output(t, terraformOptions, "cloudtrail_arn")
	isLogging, err := IsLogging(t, awsRegion, cloudtrailArn)
	assert.NoError(t, err)
	assert.True(t, isLogging)
	time.Sleep(1 * time.Minute)
}
