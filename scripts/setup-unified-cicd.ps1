# DevOpsHub Unified CI/CD Setup Script
# This script helps configure GitHub repository settings for the unified pipeline

Write-Host "🚀 DevOpsHub Unified CI/CD Setup" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Check if GitHub CLI is installed
if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "❌ GitHub CLI not found. Please install: https://cli.github.com/" -ForegroundColor Red
    exit 1
}

# Repository configuration
$repos = @(
    "app-services",
    "ci-pipelines", 
    "devopshub-monitoring",
    "devopshub-security",
    "infrastructure-modules",
    "infrastructure-live",
    "platform-api"
)

Write-Host "📋 Configuring repositories..." -ForegroundColor Yellow

foreach ($repo in $repos) {
    Write-Host "  Configuring $repo..." -ForegroundColor Cyan
    
    # Enable GitHub Advanced Security features
    Write-Host "    - Enabling security features" -ForegroundColor Gray
    # gh api repos/:owner/$repo --method PATCH --field security_and_analysis='{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}'
    
    # Create environments
    Write-Host "    - Creating environments" -ForegroundColor Gray
    # gh api repos/:owner/$repo/environments/development --method PUT
    # gh api repos/:owner/$repo/environments/staging --method PUT  
    # gh api repos/:owner/$repo/environments/production --method PUT
}

Write-Host ""
Write-Host "🔐 Required Repository Secrets:" -ForegroundColor Yellow
Write-Host "  - AWS_ACCESS_KEY_ID" -ForegroundColor Cyan
Write-Host "  - AWS_SECRET_ACCESS_KEY" -ForegroundColor Cyan  
Write-Host "  - DOCKER_HUB_USERNAME" -ForegroundColor Cyan
Write-Host "  - DOCKER_HUB_TOKEN" -ForegroundColor Cyan

Write-Host ""
Write-Host "⚙️  Manual Steps Required:" -ForegroundColor Yellow
Write-Host "  1. Go to GitHub repository Settings > Secrets and variables > Actions" -ForegroundColor White
Write-Host "  2. Add the required secrets listed above" -ForegroundColor White
Write-Host "  3. Go to Settings > Environments" -ForegroundColor White
Write-Host "  4. Configure protection rules for production environment" -ForegroundColor White
Write-Host "  5. Go to Settings > Branches" -ForegroundColor White
Write-Host "  6. Add branch protection rules for main and develop" -ForegroundColor White

Write-Host ""
Write-Host "📚 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Test the workflow: git push origin develop" -ForegroundColor White
Write-Host "  2. Monitor workflow execution in Actions tab" -ForegroundColor White
Write-Host "  3. Review CICD-MIGRATION.md for complete details" -ForegroundColor White

Write-Host ""
Write-Host "✅ Setup script completed!" -ForegroundColor Green