# PowerShell script to clone the Online Shop project and replace strings for Potion Shop

$sourceRoot = "c:\Users\krist\Downloads\Online_shop_project-master\Online_shop_project-master\Online_shop_project"
$targetRoot = "c:\Users\krist\Downloads\Potion_Shop_Project\Andrej_Projekat"

# Define all replacement pairs
$replacements = @(
    @{ old = "cafeshop"; new = "potionshop" },
    @{ old = "CafeShop"; new = "PotionShop" },
    @{ old = "cafeShop"; new = "potionShop" },
    @{ old = "Cafe"; new = "Potion" },
    @{ old = "cafe"; new = "potion" },
    @{ old = "mina"; new = "andrej" },
    @{ old = "Mina"; new = "Andrej" },
    @{ old = "MINA"; new = "ANDREJ" }
)

# Function to replace content in file
function Replace-FileContent {
    param(
        [string]$filePath,
        [array]$replacements
    )
    
    $content = Get-Content -Path $filePath -Raw
    
    foreach ($replacement in $replacements) {
        $content = $content -replace [regex]::Escape($replacement.old), $replacement.new
    }
    
    # Ensure UTF-8 encoding without BOM for text files
    if ($filePath -match '\.(java|properties|xml|yml|yaml|sql|sh)$') {
        $utf8NoBOM = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBOM)
    } else {
        Set-Content -Path $filePath -Value $content -Encoding UTF8
    }
}

# Function to copy directory recursively
function Copy-DirectoryWithReplacements {
    param(
        [string]$source,
        [string]$destination,
        [array]$replacements,
        [string[]]$excludePatterns = @("target", ".git", ".gitignore", "__MACOSX", "*.class", ".DS_Store")
    )
    
    if (-not (Test-Path $destination)) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
    }
    
    Get-ChildItem -Path $source -Force | ForEach-Object {
        $itemName = $_.Name
        
        # Check if item matches exclude patterns
        $exclude = $false
        foreach ($pattern in $excludePatterns) {
            if ($itemName -like $pattern) {
                $exclude = $true
                break
            }
        }
        
        if ($exclude) {
            return
        }
        
        $srcPath = $_.FullName
        $destPath = Join-Path -Path $destination -ChildPath $itemName
        
        if ($_.PSIsContainer) {
            Copy-DirectoryWithReplacements -source $srcPath -destination $destPath -replacements $replacements -excludePatterns $excludePatterns
        } else {
            # Copy file
            Copy-Item -Path $srcPath -Destination $destPath -Force
            
            # If it's a text file, replace content
            if ($srcPath -match '\.(java|properties|xml|yml|yaml|sql|sh|gradle|md|json)$') {
                Replace-FileContent -filePath $destPath -replacements $replacements
            }
        }
    }
}

Write-Host "Starting clone and replacement..." -ForegroundColor Green

# Copy all service directories
$services = @("user-service", "order-service", "payment-service", "catalog-service", "api-gateway", "eureka-server", "config-server", "web-app")

foreach ($service in $services) {
    $src = Join-Path $sourceRoot $service
    $dest = Join-Path $targetRoot $service
    
    Write-Host "Processing $service..." -ForegroundColor Yellow
    Copy-DirectoryWithReplacements -source $src -destination $dest -replacements $replacements
}

# Copy Dockerfiles
$services | ForEach-Object {
    $src = Join-Path -Path $sourceRoot -ChildPath $_ | Join-Path -ChildPath "Dockerfile"
    $dest = Join-Path -Path $targetRoot -ChildPath $_ | Join-Path -ChildPath "Dockerfile"
    
    if (Test-Path $src) {
        Write-Host "Copying Dockerfile from $_..." -ForegroundColor Cyan
        Copy-Item -Path $src -Destination $dest -Force
        Replace-FileContent -filePath $dest -replacements $replacements
    }
}

# Copy CafeShop.postman_collection.json and rename it
$postmanSrc = Join-Path $sourceRoot "CafeShop.postman_collection.json"
$postmanDest = Join-Path $targetRoot "PotionShop.postman_collection.json"
if (Test-Path $postmanSrc) {
    Write-Host "Copying -Path $sourceRoot -ChildPath "CafeShop.postman_collection.json"
$postmanDest = Join-Path -Path $targetRoot -ChildPathtination $postmanDest -Force
    Replace-FileContent -filePath $postmanDest -replacements $replacements
}

Write-Host "Clone and replacement completed successfully!" -ForegroundColor Green
Write-Host "Project location: $targetRoot" -ForegroundColor Green

