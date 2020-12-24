Set-StrictMode -Version 2

# This legitimate file is signed using the impacted Code Signing Certificate
Invoke-WebRequest -Uri 'https://downloads.solarwinds.com/solarwinds/Release/FreeTool/SolarWinds-FT-CostCalculatorforAzure-1.0.zip' -ErrorAction Stop -OutFile SolarWinds-FT-CostCalculatorforAzure-1.0.zip
Expand-Archive -LiteralPath .\SolarWinds-FT-CostCalculatorforAzure-1.0.zip

# The backdoored file can be seen at this URL, including the thumbprint of the compromised certificate:
# https://www.virustotal.com/gui/file/d0d626deb3f9484e649294a8dfa814c5568f846d5aa02d4cdad5d041a29d5600/details
$badthumbprint = '47D92D49E6F7F296260DA1AF355F941EB25360C4'
$cert = Get-AuthenticodeSignature .\SolarWinds-FT-CostCalculatorforAzure-1.0\CostCalculator.exe | Select-Object -ExpandProperty SignerCertificate
if ($badthumbprint -ne  $cert.Thumbprint) {
    # Safety check - if this tool is changed for example and the certificate stops being the correct one
    Write-Error "Correct certificate not found"
    return
}

Write-Output "Certificate verified: Revoking"

# Write to disk and import to disallowed certificates
$cert | Export-Certificate -FilePath .\SolarwindsLLC.cer -Type CERT | Out-Null
Import-Certificate .\SolarwindsLLC.cer -CertStoreLocation Cert:\LocalMachine\Disallowed\ | Out-Null

# Check
Get-AuthenticodeSignature .\SolarWinds-FT-CostCalculatorforAzure-1.0\CostCalculator.exe | Format-List Status,StatusMessage
