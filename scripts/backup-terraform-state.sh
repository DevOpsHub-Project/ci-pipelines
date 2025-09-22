#!/bin/bash

# Terraform state backup script
BUCKET_NAME="devopshub-tf-state-$(aws sts get-caller-identity --query Account --output text)"
BACKUP_BUCKET="devopshub-tf-state-backup-$(aws sts get-caller-identity --query Account --output text)"
DATE=$(date +%Y%m%d-%H%M%S)

echo "Creating backup of Terraform state files..."

# Create backup bucket if it doesn't exist
aws s3api head-bucket --bucket $BACKUP_BUCKET 2>/dev/null || \
aws s3 mb s3://$BACKUP_BUCKET --region us-east-1

# Sync state files to backup bucket
aws s3 sync s3://$BUCKET_NAME s3://$BACKUP_BUCKET/$DATE/

echo "Backup completed: s3://$BACKUP_BUCKET/$DATE/"

# Clean up old backups (keep last 30 days)
aws s3api list-objects-v2 --bucket $BACKUP_BUCKET --query 'Contents[?LastModified<=`'$(date -d '30 days ago' --iso-8601)'`].Key' --output text | \
xargs -I {} aws s3 rm s3://$BACKUP_BUCKET/{}

echo "Old backups cleaned up"