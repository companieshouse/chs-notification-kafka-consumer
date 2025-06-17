package test

import (
	"fmt"
	"testing"

	awssdk "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {
	t.Parallel()

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	//Get VPC ID from selected Region
	awsDefaultVpc := aws.GetDefaultVpc(t, awsRegion)
	vpcID := awsDefaultVpc.Id

	//Get Subnets for selected VPC
	subnets := aws.GetSubnetsForVpc(t, vpcID, awsRegion)
	subnetIds := []string{}
	for _, subnet := range subnets {
		subnetID := subnet.Id
		subnetIds = append(subnetIds, subnetID)
	}
	//Get Internet Gateway for selected VPC
	sess, err := session.NewSession(&awssdk.Config{Region: awssdk.String(awsRegion)})
	start := ec2.New(sess)
	input := &ec2.DescribeInternetGatewaysInput{
		Filters: []*ec2.Filter{
			{
				Name: awssdk.String("attachment.vpc-id"),
				Values: []*string{
					awssdk.String(vpcID),
				},
			},
		},
	}
	gateway, err := start.DescribeInternetGateways(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
		return
	}
	gateways := gateway.InternetGateways
	gatewayIds := []string{}
	for _, gateway := range gateways {
		gatewayID := gateway.InternetGatewayId
		gatewayIds = append(gatewayIds, *gatewayID)
	}

	// Arrange
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../example/",

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":        fmt.Sprintf("terratest-rtb-%s", random.UniqueId()),
			"vpcID":       vpcID,
			"subnet_list": subnetIds,
			"route_list": []interface{}{
				map[string]interface{}{
					"destination_cidr_block": "0.0.0.0/0",
					"gateway_id":             gatewayIds[0],
				},
			},
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` and ensure outputs are present and match the expected values
	routetableID := terraform.Output(t, terraformOptions, "route_table_id")

	// make sure output is not empty
	assert.NotEmpty(t, routetableID)
}
