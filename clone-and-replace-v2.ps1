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
    
    try {
        $content = Get-Content -Path $filePath -Raw -ErrorAction SilentlyContinue
        if ($null -eq $content) {
            return
        }
        
        foreach ($replacement in $replacements) {
            $content = $content -replace [regex]::Escape($replacement.old), $replacement.new
        }
        
        # Write file with UTF-8 encoding without BOM
        $utf8NoBOM = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBOM)
    } catch {
        Write-Host "Error processing $filePath : $_" -ForegroundColor Yellow
    }
}

# Function to copy directory recursively
function Copy-DirectoryWithReplacements {
    param(
        [string]$source,
        [string]$destination,
        [array]$replacements,
        [string[]]$excludePatterns = @("target", ".git", "__MACOSX", "*.class", ".DS_Store")
    )
    
    if (-not (Test-Path $destination)) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
    }
    
    $items = @(Get-ChildItem -Path $source -Force -ErrorAction SilentlyContinue)
    
    foreach ($item in $items) {
        $itemName = $item.Name
        
        # Check if item matches exclude patterns
        $exclude = $false
        foreach ($pattern in $excludePatterns) {
            if ($itemName -like $pattern) {
                $exclude = $true
                break
            }
        }
        
        if ($exclude) {
            continue
        }
        
        $srcPath = $item.FullName
        $destPath = Join-Path -Path $destination -ChildPath $itemName
        
        if ($item.PSIsContainer) {
            Copy-DirectoryWithReplacements -source $srcPath -destination $destPath -replacements $replacements -excludePatterns $excludePatterns
        } else {
            # Copy file
            Copy-Item -Path $srcPath -Destination $destPath -Force -ErrorAction SilentlyContinue
            
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
    $src = Join-Path -Path $sourceRoot -ChildPath $service
    $dest = Join-Path -Path $targetRoot -ChildPath $service
    
    if (Test-Path $src) {
        Write-Host "Processing $service..." -ForegroundColor Yellow
        Copy-DirectoryWithReplacements -source $src -destination $dest -replacements $replacements
    }
}

# Copy Postman collection if it exists
$postmanSrc = Join-Path -Path $sourceRoot -ChildPath "CafeShop.postman_collection.json"
if (Test-Path $postmanSrc) {
    Write-Host "Copying Postman collection..." -ForegroundColor Cyan
    $postmanDest = Join-Path -Path $targetRoot -ChildPath "PotionShop.postman_collection.json"
    Copy-Item -Path $postmanSrc -Destination $postmanDest -Force -ErrorAction SilentlyContinue
    Replace-FileContent -filePath $postmanDest -replacements $replacements
}

Write-Host "Clone and replacement completed successfully!" -ForegroundColor Green
Write-Host "Project location: $targetRoot" -ForegroundColor Green
