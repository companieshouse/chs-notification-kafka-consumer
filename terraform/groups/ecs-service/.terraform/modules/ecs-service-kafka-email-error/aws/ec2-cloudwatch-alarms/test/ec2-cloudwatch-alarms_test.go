package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	testName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
		Vars: map[string]interface{}{
			"name": testName,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

	ec2CPU := terraform.Output(t, terraformOptions, "ec2_cpuutilization")
	ec2Status := terraform.Output(t, terraformOptions, "ec2_overallstatus_check")
	ec2Systemstatus := terraform.Output(t, terraformOptions, "ec2_systemstatus_check")
	ec2InstanceStatus := terraform.Output(t, terraformOptions, "ec2_systemstatus_check")
	ec2AvailableMemory := terraform.Output(t, terraformOptions, "ec2_instance_availablememory_low")
	ec2UsedMemory := terraform.Output(t, terraformOptions, "ec2_instance_usedmemory_high")
	ec2SwapMemory := terraform.Output(t, terraformOptions, "ec2_instance_swapmemory_low")
	ec2ILowDiskSpace := terraform.Output(t, terraformOptions, "ec2_instancedisks_low_space")

	assert.NotEmpty(t, ec2CPU)
	assert.NotEmpty(t, ec2Status)
	assert.NotEmpty(t, ec2Systemstatus)
	assert.NotEmpty(t, ec2InstanceStatus)
	assert.NotEmpty(t, ec2AvailableMemory)
	assert.NotEmpty(t, ec2UsedMemory)
	assert.NotEmpty(t, ec2SwapMemory)
	assert.NotEmpty(t, ec2ILowDiskSpace)

}
