package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

	unhealhtyHostCount := terraform.Output(t, terraformOptions, "alarm_unhealthy_host_count")
	targetHTTP4XXCount := terraform.Output(t, terraformOptions, "alarm_httpcode_target_4xx_count")
	loadbalancerHTTP4XXCount := terraform.Output(t, terraformOptions, "alarm_httpcode_lb_4xx_count")
	targetHTTP5XXCount := terraform.Output(t, terraformOptions, "alarm_httpcode_target_5xx_count")
	loadbalancerHTTP5XXCount := terraform.Output(t, terraformOptions, "alarm_httpcode_lb_5xx_count")
	averageResponseTime := terraform.Output(t, terraformOptions, "target_response_time_average")
	loadbalancerTLSErrors := terraform.Output(t, terraformOptions, "alarm_client_tls_neg_err_count")

	assert.NotEmpty(t, unhealhtyHostCount)
	assert.NotEmpty(t, targetHTTP4XXCount)
	assert.NotEmpty(t, loadbalancerHTTP4XXCount)
	assert.NotEmpty(t, targetHTTP5XXCount)
	assert.NotEmpty(t, loadbalancerHTTP5XXCount)
	assert.NotEmpty(t, averageResponseTime)
	assert.NotEmpty(t, loadbalancerTLSErrors)

}
