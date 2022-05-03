# Copyright 2022 the Sabl authors. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.

param(
  [string]$Package 
)

. (Join-Path $PSScriptRoot 'utils.ps1')

$cdir = (Get-Location).Path
$repoDir = Join-FPath $PSScriptRoot, '..' -Resolve
$Package = Select-TSPackage $cdir $Package 
 
if ($Package) {
    Write-Host "Cleaning package $Package`n" -f Green
    $searchDir = Join-FPath $repoDir, 'packages', $Package -Resolve 
}
else {
    Write-Host "Cleaning all packages`n" -f Green
    $searchDir = Join-FPath $repoDir, 'packages' -Resolve 
}
    
if (!$Package) {
    @('coverage', 'dist') | `
        ForEach-Object { Get-ChildItem $repoDir -Directory -Filter $_ } | `
        ForEach-Object { 
        Write-Host "Cleaning $($_.FullName.Replace($cdir, '.'))" -ForegroundColor Cyan
        Remove-Item -Recurse -Force $_
    }
}

@('coverage', 'dist') | `
    ForEach-Object { Get-ChildItem $searchDir -Directory -Recurse -Filter $_ } | `
    Sort-Object | `
    ForEach-Object { 
    Write-Host "Cleaning $($_.FullName.Replace($cdir, '.'))" -ForegroundColor Cyan
    Remove-Item -Recurse -Force $_
} 