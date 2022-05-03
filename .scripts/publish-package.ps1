# Copyright 2022 the Sabl authors. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.

param(
  [string]$Package,
  [switch]$Push
)

. (Join-Path $PSScriptRoot 'utils.ps1')

$cdir = (Get-Location).Path
$Package = Select-TSPackage $cdir $Package 

Write-Host "Publishing package $Package" -ForegroundColor Green

$rootDir    = Split-Path $PSScriptRoot -Parent 
$packageDir = Join-FPath $rootDir, 'packages', $Package -Resolve
$publishDir = Join-FPath $rootDir, 'publish', $Package 

Push-Location $packageDir

pnpm clean
pnpm build

if(Test-Path $publishDir) {
    Remove-Item $publishDir -Recurse -Force
}
mkdir $publishDir | Out-Null

# Copy root files
Get-ChildItem (Join-Path $packageDir '*') -File | Copy-Item -Destination $publishDir

# src
Copy-Item (Join-Path $packageDir 'src') $publishDir -Recurse

# dist
Copy-Item (Join-Path $packageDir 'dist') $publishDir -Recurse

# Replace tsconfig.json with resolved tsconfig.build.json
$tsconfig = pnpx tsc --project .\tsconfig.build.json --showConfig | Join-String -Sep "`n"
  
# Write-Host 'Resolved tsconfig' -ForegroundColor Green
# Write-Host $tsconfig -ForegroundColor Cyan
 
$tsconfig > (Join-FPath $publishDir, tsconfig.json)
Remove-Item (Join-FPath $publishDir, tsconfig.build.json)

$pjs = Get-Content (Join-FPath $publishDir, 'package.json') | ConvertFrom-Json
$pjs.PSObject.Properties.Remove('scripts')
$pjs.PSObject.Properties.Remove('publishConfig')
$pjs | ConvertTo-Json | Out-File (Join-FPath $publishDir, 'package.json')

if ($Push) {
  Write-Host "Pushing package to remote feed..." -ForegroundColor Cyan
  npm publish $publishDir
} else {
  Write-Host "`nCreated output folder $publishDir.`n" -ForegroundColor Green
  Write-Host "To push to remote feed, use npm publish, or use the -Push flag with this script`n" -ForegroundColor Yellow
}

Pop-Location