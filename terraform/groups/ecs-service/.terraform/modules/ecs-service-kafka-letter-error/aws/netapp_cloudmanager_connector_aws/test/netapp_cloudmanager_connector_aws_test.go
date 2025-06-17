package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, []string{"eu-west-2"}, nil)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest%s", uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, awsRegion, name)
	defer aws.DeleteEC2KeyPair(t, keyPair)
	refreshToken := os.Getenv("OCCM_REFRESH_TOKEN")

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",

		Vars: map[string]interface{}{
			"cloudmanager_name":          name,
			"key_pair_name":              keyPair.Name,
			"cloudmanager_refresh_token": refreshToken,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
			"AWS_REGION":         awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Act
	_, err := terraform.InitAndApplyE(t, terraformOptions)
	if err != nil {
		terraform.InitAndApply(t, terraformOptions)
	}
}
