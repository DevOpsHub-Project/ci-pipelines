#!/bin/bash

# Terraform state recovery script
set -e

BUCKET_NAME="devopshub-tf-state2"
STATE_KEY="$1"
VERSION_ID="$2"

if [ -z "$STATE_KEY" ]; then
	echo "Usage: $0 <state-key> [version-id]"
	echo "Example: $0 dev/vpc/terraform.tfstate"
	exit 1
fi

echo "Recovering Terraform state: $STATE_KEY"

if [ -n "$VERSION_ID" ]; then
	echo "Recovering specific version: $VERSION_ID"
	aws s3api get-object --bucket $BUCKET_NAME --key $STATE_KEY --version-id $VERSION_ID terraform.tfstate.recovered
else
	echo "Recovering latest version"
	aws s3 cp s3://$BUCKET_NAME/$STATE_KEY terraform.tfstate.recovered
fi

echo "State file recovered as: terraform.tfstate.recovered"
echo "To restore, run: mv terraform.tfstate.recovered terraform.tfstate"

# List available versions
echo -e "\nAvailable versions:"
aws s3api list-object-versions --bucket $BUCKET_NAME --prefix $STATE_KEY --query 'Versions[*].{Version:VersionId,LastModified:LastModified,Size:Size}' --output table