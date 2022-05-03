# Copyright 2022 the Sabl authors. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.

function Join-FPath {
    param([string[]]$Parts, [switch]$Resolve)
    $joined = [System.IO.Path]::Combine($Parts)
    if (!$Resolve) { return $joined }
    return Resolve-Path $joined
}
  
function Select-TSPackage {
    param ([string]$WorkDir, [string]$Package)
     
    if (!$Package -and ((Split-Path (Split-Path $WorkDir -Parent) -Leaf) -eq 'packages')) {
        $Package = Split-Path $cdir -Leaf
        Write-Host "Automatically selecting package $Package"
    } 

    return $Package
}