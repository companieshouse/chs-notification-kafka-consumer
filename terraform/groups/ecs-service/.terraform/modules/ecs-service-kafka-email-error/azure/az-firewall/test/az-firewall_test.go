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

// TestAzureFirewallExample. Tests for the creation of the Azure Firewall instance and policy
func TestAzureFirewallExample(t *testing.T) {
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

	azfirewall := terraform.Output(t, terraformOptions, "azfirewall")
	assert.NotEmpty(t, azfirewall)

	azFirewallPublicIP := terraform.Output(t, terraformOptions, "azfirewall_public_ip")
	assert.NotEmpty(t, azFirewallPublicIP)

	azFirewallPolicy := terraform.Output(t, terraformOptions, "azfirewall_policy")
	assert.NotEmpty(t, azFirewallPolicy)

	azFirewallPolicyID := terraform.Output(t, terraformOptions, "azfirewall_policy_id")
	assert.NotEmpty(t, azFirewallPolicyID)

}
