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
			"name":   name,
			"region": azureRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

	inboundRules := terraform.Output(t, terraformOptions, "inbound_rules")
	assert.NotEmpty(t, inboundRules)

	outboundRules := terraform.Output(t, terraformOptions, "outbound_rules")
	assert.NotEmpty(t, outboundRules)

}
