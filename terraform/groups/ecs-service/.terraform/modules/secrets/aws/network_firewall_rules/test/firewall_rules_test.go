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

	awsRegion := aws.GetRandomStableRegion(t, []string{"eu-west-2"}, nil)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest-%s", uniqueID)

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
		Vars: map[string]interface{}{
			"name":          name,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert := assert.New(t)
	
	csvStatelessRuleGroups := terraform.OutputList(t, terraformOptions, "aws_networkfirewall_csv_stateless_rule_groups")
	assert.NotEmpty(csvStatelessRuleGroups)

	csvDomainRuleGroups := terraform.OutputList(t, terraformOptions, "aws_networkfirewall_csv_domain_rule_groups")
	assert.NotEmpty(csvDomainRuleGroups)
}
