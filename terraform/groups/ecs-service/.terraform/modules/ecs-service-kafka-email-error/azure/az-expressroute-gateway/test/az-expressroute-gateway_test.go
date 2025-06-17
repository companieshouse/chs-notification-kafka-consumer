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

// TestExpressRouteExample tests for route table and route creation and checks for successful creation
func TestExpressRouteExample(t *testing.T) {
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

	publicIP := terraform.OutputListOfObjects(t, terraformOptions, "gateway_ip")
	assert.NotEmpty(t, publicIP)

	publicIPID := terraform.OutputList(t, terraformOptions, "gateway_ip_id")
	assert.NotEmpty(t, publicIPID)

	expressRouteGateway := terraform.OutputListOfObjects(t, terraformOptions, "expressroute_gateway")
	assert.NotEmpty(t, expressRouteGateway)

	expressRouteGatewayIPs := terraform.OutputListOfObjects(t, terraformOptions, "expressroute_gateway_ipconfig")
	assert.NotEmpty(t, expressRouteGatewayIPs)

	expressRouteGatewayIPs0 := expressRouteGatewayIPs[0]
	publicIP0 := publicIPID[0]

	assert.Equal(expressRouteGatewayIPs0["public_ip_address_id"], publicIP0)
}
