# Copyright 2022 the Sabl authors. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.

param(
  [switch]$View, 
  [switch]$Render,
  [string]$Package,
  [switch]$Pretty
)

. (Join-Path $PSScriptRoot 'utils.ps1')

$cdir = (Get-Location).Path
$searchDir = Join-FPath $PSScriptRoot, '..', 'packages'
$Package = Select-TSPackage $cdir $Package 
Push-Location (Join-FPath $PSScriptRoot, '..')

function prettypath($relPath) {
  if(!$Pretty) { return $relPath }
  return $relPath.Replace($cdir, '.')
}

if ($Package) {
  Write-Host "Testing package $Package`n" -f Green
  $searchDir = Join-Path $searchDir $Package -Resolve 
  $covDir = Join-Path $searchDir 'coverage'
}
else {
  Write-Host "Testing all packages`n" -f Green
  $covDir = Join-FPath $PSScriptRoot, '..', 'coverage'
}
  
$testPaths = `
  Get-ChildItem $searchDir -Filter 'jest.config.js' -Recurse | `
  Join-String -Property FullName -Separator " ```n               "
  
$jestPath = Join-FPath ., node_modules, .bin, jest
$reporters = 'text'

if ($View -or $Render) {
  $reporters += ' lcov'
}

$cmd = "  $jestPath ```n    --coverage true"
if ($View -or $Render) {
  $cmd += " ```n    --coverageDirectory $covDir"
}
$cmd += " ```n    --coverageReporters $reporters"  
$cmd += " ```n    --projects $testPaths"    
 
if ($Package -and (Test-Path $covDir)) {
  Write-Host "`nClearing existing coverage dir $(prettypath $covDir)`n" -f Cyan
  Remove-Item -Recurse -Force $covDir
}
 
Write-Host ((prettypath $cmd) + "`n") -f Cyan

Invoke-Expression $cmd
   
if ($View) {
  $covPath = Join-FPath $covDir, 'lcov-report', 'index.html'
  Write-Host "`nOpening coverage report $(prettypath $covPath)`n" -ForegroundColor Green
  . $covPath
} 

Pop-Location