#!/bin/bash

# Container vulnerability scanning script
IMAGE_NAME=$1

if [ -z "$IMAGE_NAME" ]; then
	echo "Usage: $0 <image-name>"
	exit 1
fi

echo "Scanning image: $IMAGE_NAME"

# Run Trivy scan
trivy image --severity HIGH,CRITICAL --format table $IMAGE_NAME

# Generate JSON report
trivy image --severity HIGH,CRITICAL --format json --output scan-report.json $IMAGE_NAME

echo "Scan completed. Report saved to scan-report.json"