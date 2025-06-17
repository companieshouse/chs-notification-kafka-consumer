package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
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

	// // Assert
	// assert := assert.New(t)

	routeTableID := terraform.Output(t, terraformOptions, "example_routetable_id")
	assert.NotEmpty(t, routeTableID)

	routeIDs := terraform.OutputList(t, terraformOptions, "example_route_ids")
	assert.NotEmpty(t, routeIDs)

	require.Equal(t, len(routeIDs), 4)
}
