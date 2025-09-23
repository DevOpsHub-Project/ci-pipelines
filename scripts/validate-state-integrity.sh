#!/bin/bash

# Terraform state integrity validation
set -e

BUCKET_NAME="devopshub-tf-state2"

echo "Validating Terraform state file integrity..."

# List all state files
STATE_FILES=$(aws s3 ls s3://$BUCKET_NAME --recursive | grep "terraform.tfstate$" | awk '{print $4}')

for state_file in $STATE_FILES; do
	echo "Checking: $state_file"
				    
	# Download state file
	aws s3 cp s3://$BUCKET_NAME/$state_file temp_state.json
				    
	# Validate JSON format
	if jq empty temp_state.json 2>/dev/null; then
		echo "✅ $state_file - Valid JSON format"
	else
		echo "❌ $state_file - Invalid JSON format"
		continue
	fi
				    
	# Check Terraform version
	TF_VERSION=$(jq -r '.terraform_version // "unknown"' temp_state.json)
	echo "   Terraform version: $TF_VERSION"
				    
	# Check resource count
	RESOURCE_COUNT=$(jq '.resources | length' temp_state.json)
	echo "   Resource count: $RESOURCE_COUNT"
				    
	# Check for sensitive data (basic check)
	if jq -r '.resources[].instances[].attributes | to_entries[] | select(.value | type == "string") | .value' temp_state.json | grep -i "password\|secret\|key" > /dev/null 2>&1; then
		echo "⚠️  $state_file - Potential sensitive data detected"
	fi
				    
	rm temp_state.json
	echo ""
done

echo "State file validation completed"