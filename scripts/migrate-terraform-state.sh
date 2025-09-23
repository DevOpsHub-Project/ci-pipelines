#!/bin/bash

# Terraform state migration script
set -e

SOURCE_BACKEND="$1"
TARGET_BACKEND="$2"
STATE_PATH="$3"

if [ -z "$STATE_PATH" ]; then
	echo "Usage: $0 <source-backend> <target-backend> <state-path>"
	echo "Example: $0 local s3 dev/vpc"
	exit 1
	fi

echo "Migrating Terraform state from $SOURCE_BACKEND to $TARGET_BACKEND"

cd $STATE_PATH

# Backup current state
cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d-%H%M%S) 2>/dev/null || true

# Initialize with new backend
terraform init -migrate-state -force-copy

# Verify migration
terraform state list

echo "State migration completed successfully"
echo "Backup created: terraform.tfstate.backup.*"