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

// TestVirtualMachineExample tests the creation of different virtual machine types
func TestVirtualMachineExample(t *testing.T) {
	t.Parallel()

	regionsWithMultiAz := []string{"uksouth", "northeurope", "westeurope"}
	azureSubscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	azureRegion := azure.GetRandomStableRegion(t, regionsWithMultiAz, nil, azureSubscriptionID)

	uniqueID := random.UniqueId()
	name := fmt.Sprintf("Terratest%s", uniqueID)

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"resource_group_name": name,
			"location":            azureRegion,
			"win_vm_name":         name + "win",
			"lin_vm_name":         name + "lin",
			"admin_pass":          "!ASecurePass12",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

	windowsNIC := terraform.OutputMap(t, terraformOptions, "windows_vm_nic")
	assert.NotEmpty(t, windowsNIC)

	linuxNIC := terraform.OutputMap(t, terraformOptions, "linux_vm_nic")
	assert.NotEmpty(t, linuxNIC)

	windowsVM := terraform.OutputMap(t, terraformOptions, "windows_vm")
	assert.NotEmpty(t, windowsVM)

	linuxVM := terraform.OutputMap(t, terraformOptions, "linux_vm")
	assert.NotEmpty(t, linuxVM)

	assert.Equal(windowsVM["admin_password"], "!ASecurePass12")
	assert.Equal(linuxVM["admin_username"], "terratest")
	assert.Equal(linuxNIC["private_ip_address"], "10.10.1.10")

}
