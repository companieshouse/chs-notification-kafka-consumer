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

// TestRouteTableExample tests for route table and route creation and checks for successful creation
func TestRouteTableExample(t *testing.T) {
	t.Parallel()

	azureSubscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	azureRegion := azure.GetRandomStableRegion(t, nil, nil, azureSubscriptionID)

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

	localPeerDetails := terraform.OutputMap(t, terraformOptions, "vnet_peering_local")
	assert.NotEmpty(localPeerDetails)

	remotePeerDetails := terraform.OutputMap(t, terraformOptions, "vnet_peering_remote")
	assert.NotEmpty(remotePeerDetails)

	assert.Equal(localPeerDetails["name"], "local-to-remote-vnet-peer-local")
	assert.Equal(remotePeerDetails["name"], "local-to-remote-vnet-peer-remote")

	localVnetName := fmt.Sprintf("%s-local-vnet", name)
	assert.Equal(localPeerDetails["virtual_network_name"], localVnetName)

	remoteVnetName := fmt.Sprintf("%s-remote-vnet", name)
	assert.Equal(remotePeerDetails["virtual_network_name"], remoteVnetName)
}
