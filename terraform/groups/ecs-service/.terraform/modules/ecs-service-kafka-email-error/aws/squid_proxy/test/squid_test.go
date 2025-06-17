package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"

	awsSdk "github.com/aws/aws-sdk-go/aws"
	awsSdkSession "github.com/aws/aws-sdk-go/aws/session"
	ec2 "github.com/aws/aws-sdk-go/service/ec2"
)

func TestTerraformExample(t *testing.T) {

	awsRegion := aws.GetRandomStableRegion(t, []string{"eu-west-2"}, nil)
	availabilityZones := aws.GetAvailabilityZones(t, awsRegion)
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terratest-%s", uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, awsRegion, name)
	defer aws.DeleteEC2KeyPair(t, keyPair)

	amiFilters := map[string][]string{
		"name": {"squid-*"},
	}
	amiID := aws.GetMostRecentAmiId(t, awsRegion, "169942020521", amiFilters)

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
		Vars: map[string]interface{}{
			"name":          name,
			"ami_id":        amiID,
			"key_pair_name": keyPair.Name,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert := assert.New(t)

	autoscalingGroupNames := terraform.OutputList(t, terraformOptions, "autoscaling_group_names")
	assert.NotEmpty(autoscalingGroupNames)

	autoscalingGroupArns := terraform.Output(t, terraformOptions, "autoscaling_group_arns")
	assert.NotEmpty(autoscalingGroupArns)

	snsTopicArn := terraform.Output(t, terraformOptions, "sns_topic_arn")
	assert.NotEmpty(snsTopicArn)

	intraRouteTableIDs := terraform.OutputList(t, terraformOptions, "intra_route_table_ids")
	assert.NotEmpty(intraRouteTableIDs)
	assert.Equal(len(availabilityZones), len(intraRouteTableIDs))

	//Test routes created by Lambda after instance initialization are setup
	session, _ := awsSdkSession.NewSession(&awsSdk.Config{
		Region: awsSdk.String(awsRegion)},
	)
	ec2Client := ec2.New(session)

	describeRouteTablesInput := &ec2.DescribeRouteTablesInput{}
	describeRouteTablesInput.SetRouteTableIds(awsSdk.StringSlice(intraRouteTableIDs))

	defaultRouteCount := 0
	retryCount := 20
	retrySeconds := 15
	for i := 0; i < retryCount; i++ {
		// If not first loop, sleep before retry
		if i != 0 {
			fmt.Println(fmt.Sprintf("Not enough matching routes found, sleeping for %d seconds before retry (%d/%d)", retrySeconds, i, retryCount))
			time.Sleep(15 * time.Second)
		}

		//reset counter and retrieve route status
		defaultRouteCount = 0
		describeRouteTablesOutput, _ := ec2Client.DescribeRouteTables(describeRouteTablesInput)

		for _, routeTable := range describeRouteTablesOutput.RouteTables {
			for _, route := range routeTable.Routes {
				//If route is a default route, and the InstanceID pointer is set (route points to an instance ID), increment counter
				if awsSdk.StringValue(route.DestinationCidrBlock) == "0.0.0.0/0" && route.InstanceId != nil {
					defaultRouteCount++
				}
			}
		}

		if defaultRouteCount == len(intraRouteTableIDs) {
			//We have 3 default routes pointing to a NAT instance, exit loop early
			break
		}
	}
	//We have either exhausted our timeout leaving the count incorrect, or exited our loop as we detected the correct routes and set the counter correctly
	assert.Equal(len(intraRouteTableIDs), defaultRouteCount)
}
