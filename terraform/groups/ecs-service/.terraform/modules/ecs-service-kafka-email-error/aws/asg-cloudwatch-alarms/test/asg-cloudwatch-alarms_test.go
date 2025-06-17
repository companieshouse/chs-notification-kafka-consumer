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

	healthyInstances := terraform.Output(t, terraformOptions, "healthy_instances")
	pendingInstances := terraform.Output(t, terraformOptions, "pending_instances")
	standbyInstances := terraform.Output(t, terraformOptions, "standby_instances")
	terminatingInstances := terraform.Output(t, terraformOptions, "terminating_instances")
	totalInstancesLower := terraform.Output(t, terraformOptions, "total_instances_lower")
	totalInstancesGreater := terraform.Output(t, terraformOptions, "total_instances_greater")

	assert.NotEmpty(t, healthyInstances)
	assert.NotEmpty(t, pendingInstances)
	assert.NotEmpty(t, standbyInstances)
	assert.NotEmpty(t, terminatingInstances)
	assert.NotEmpty(t, totalInstancesLower)
	assert.NotEmpty(t, totalInstancesGreater)

}
