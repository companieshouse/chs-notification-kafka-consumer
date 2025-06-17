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

// TestLogAnalyticsExample tests for route table and route creation and checks for successful creation
func TestLogAnalyticsExample(t *testing.T) {
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

	workspaceAzureID := terraform.Output(t, terraformOptions, "la_workspace_id")
	assert.NotEmpty(t, workspaceAzureID)

	workspaceKeyPrimary := terraform.Output(t, terraformOptions, "la_workspace_primary_key")
	assert.NotEmpty(t, workspaceKeyPrimary)

	workspaceKeySecondary := terraform.Output(t, terraformOptions, "la_workspace_secondary_key")
	assert.NotEmpty(t, workspaceKeySecondary)

	workspaceAgentID := terraform.Output(t, terraformOptions, "la_workspace_workspace_id")
	assert.NotEmpty(t, workspaceAgentID)

	assert.NotEqualValues(t, workspaceKeyPrimary, workspaceKeySecondary)

}
