package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest-%s", uniqueID)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/asg_ec2/",

		Vars: map[string]interface{}{
			"name": name,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert := assert.New(t)

	launchConfigID := terraform.Output(t, terraformOptions, "this_launch_configuration_id")
	assert.NotEmpty(launchConfigID)

	autoScalingGroupID := terraform.Output(t, terraformOptions, "this_autoscaling_group_availability_zones")
	assert.NotEmpty(autoScalingGroupID)

	asgSubnets := terraform.OutputList(t, terraformOptions, "this_autoscaling_group_vpc_zone_identifier")
	assert.NotEmpty(asgSubnets)

	asgZones := terraform.OutputList(t, terraformOptions, "this_autoscaling_group_availability_zones")
	assert.NotEmpty(asgZones)

}
