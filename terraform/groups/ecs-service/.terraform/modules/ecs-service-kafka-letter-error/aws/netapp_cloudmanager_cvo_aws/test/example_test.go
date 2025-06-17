package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/sethvargo/go-password/password"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, []string{"eu-west-2"}, nil)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest%s", uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, awsRegion, name)
	defer aws.DeleteEC2KeyPair(t, keyPair)
	password, _ := password.Generate(20, 5, 5, false, false)
	refreshToken := os.Getenv("OCCM_REFRESH_TOKEN")

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
		Vars: map[string]interface{}{
			"name":                       name,
			"key_name":                   keyPair.Name,
			"cloudmanager_refresh_token": refreshToken,
			"svm_password":               password,
			"cluster_floating_ips":       []string{"192.168.255.1", "192.168.255.2", "192.168.255.3", "192.168.255.4"},
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
