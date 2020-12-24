Set-StrictMode -Version 2

# This script is designed to be fully self contained and verifiable. It does not ship executables or certificates themselves in order to allow you to
# independently verify its actions.

# This legitimate file is signed using the impacted Code Signing Certificate
Invoke-WebRequest -Uri 'https://downloads.solarwinds.com/solarwinds/Release/FreeTool/SolarWinds-FT-CostCalculatorforAzure-1.0.zip' -OutFile SolarWinds-FT-CostCalculatorforAzure-1.0.zip
Expand-Archive -LiteralPath .\SolarWinds-FT-CostCalculatorforAzure-1.0.zip

# The backdoored file can be seen at this URL, including the thumbprint of the compromised certificate:
# https://www.virustotal.com/gui/file/d0d626deb3f9484e649294a8dfa814c5568f846d5aa02d4cdad5d041a29d5600/details
$badthumbprint = '47D92D49E6F7F296260DA1AF355F941EB25360C4'
$cert = Get-AuthenticodeSignature .\SolarWinds-FT-CostCalculatorforAzure-1.0\CostCalculator.exe | select-object -ExpandProperty SignerCertificate
if ($badthumbprint -eq  $cert.Thumbprint) {
  Write-Host "Certificate verified: Revoking"
} else {
  Write-Error "Correct certificate not found"
  exit
}

# Write to disk and import to disallowed certificates
$cert | Export-Certificate -FilePath .\SolarwindsLLC.cer -Type CERT
Import-Certificate .\SolarwindsLLC.cer -CertStoreLocation Cert:\LocalMachine\Disallowed\

# Check
Get-AuthenticodeSignature .\RequirementsChecker.exe | fl Status,StatusMessage