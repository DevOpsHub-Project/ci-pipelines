#!/bin/bash

# Terraform validation script
set -e

echo "Running Terraform validation..."

# Find all Terraform directories
TERRAFORM_DIRS=$(find . -name "*.tf" -exec dirname {} \; | sort -u)

for dir in $TERRAFORM_DIRS; do
	echo "Validating $dir..."
				    
	cd $dir
				    
	# Format check
	if ! terraform fmt -check -diff; then
		echo "❌ Format check failed in $dir"
		exit 1
	fi
				    
	# Initialize without backend
	terraform init -backend=false -input=false
				    
	# Validate
	if ! terraform validate; then
		echo "❌ Validation failed in $dir"
		exit 1
	fi
				    
	echo "✅ $dir validated successfully"
	cd - > /dev/null
done

echo "✅ All Terraform configurations validated successfully"