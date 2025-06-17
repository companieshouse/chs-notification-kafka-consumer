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

// TestVPNGatewayExample tests for route table and route creation and checks for successful creation
func TestVPNGatewayExample(t *testing.T) {
	t.Parallel()

	regionsWithMultiAz := []string{"uksouth", "northeurope", "westeurope"}
	azureSubscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	azureRegion := azure.GetRandomStableRegion(t, regionsWithMultiAz, nil, azureSubscriptionID)

	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest%s", uniqueID)

	activeActive := true

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"resource_group_name":  name,
			"location":             azureRegion,
			"enable_active_active": activeActive,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

	publicIP := terraform.OutputListOfObjects(t, terraformOptions, "gateway_ip")
	assert.NotEmpty(t, publicIP)

	publicIPID := terraform.OutputList(t, terraformOptions, "gateway_ip_id")
	assert.NotEmpty(t, publicIPID)

	vpnGatewayIPs := terraform.OutputListOfObjects(t, terraformOptions, "vpn_gateway_ipconfig")
	assert.NotEmpty(t, vpnGatewayIPs)

	vpnGatewayIPs0 := vpnGatewayIPs[0]
	publicIP0 := publicIPID[0]

	assert.Equal(vpnGatewayIPs0["public_ip_address_id"], publicIP0)

	if activeActive == true {
		secondaryPublicIP := terraform.OutputListOfObjects(t, terraformOptions, "secondary_gateway_ip")
		assert.NotEmpty(t, secondaryPublicIP)

		secondaryPublicIPID := terraform.OutputList(t, terraformOptions, "secondary_gateway_ip_id")
		assert.NotEmpty(t, secondaryPublicIPID)

		vpnGatewayIPs1 := vpnGatewayIPs[1]
		secondaryPublicIP0 := secondaryPublicIPID[0]

		assert.Equal(vpnGatewayIPs1["public_ip_address_id"], secondaryPublicIP0)
	}
}
