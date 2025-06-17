package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestEAzureBastionExample tests for Azure Bastion creation
func TestEAzureBastionExample(t *testing.T) {
	t.Parallel()

	regionsWithMultiAz := []string{"uksouth", "northeurope", "westeurope", "francecentral"}
	azureSubscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	azureRegion := azure.GetRandomStableRegion(t, regionsWithMultiAz, nil, azureSubscriptionID)

	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest%s", uniqueID)

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"resource_group_name": name,
			"location":            azureRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

	bastion := terraform.OutputMap(t, terraformOptions, "bastion")
	assert.NotEmpty(t, bastion)

	bastionPublicIP := terraform.OutputMap(t, terraformOptions, "bastion_public_ip")
	assert.NotEmpty(t, bastionPublicIP)

	bastionNetworkSecurityGroup := terraform.OutputMap(t, terraformOptions, "bastion_network_security_group")
	assert.NotEmpty(t, bastionNetworkSecurityGroup)
}
