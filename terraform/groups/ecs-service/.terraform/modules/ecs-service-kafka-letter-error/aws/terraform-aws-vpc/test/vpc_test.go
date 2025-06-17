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
	exampleDir := "../examples/intra-routing/"

	testIntraRouteTables(t, exampleDir, name, awsRegion, true)
	testIntraRouteTables(t, exampleDir, name, awsRegion, false)
}

func testIntraRouteTables(t *testing.T, dir string, name string, awsRegion string, singleTable bool) {

	terraformOptions := &terraform.Options{
		TerraformDir: dir,
		Vars: map[string]interface{}{
			"name":                     name,
			"single_intra_route_table": singleTable,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert := assert.New(t)

	intraRouteTableIDs := terraform.OutputList(t, terraformOptions, "intra_route_table_ids")
	assert.NotEmpty(intraRouteTableIDs)

	intraSubnets := terraform.OutputList(t, terraformOptions, "intra_subnets")
	assert.NotEmpty(intraSubnets)

	if singleTable {
		assert.Equal(1, len(intraRouteTableIDs))
	} else {
		assert.Equal(len(intraSubnets), len(intraRouteTableIDs))
	}
}
