# Revoke Compromised Solarwinds Certificate

Following the recent Solarwinds incident, it is a common view that the impacted certificate should be revoked. This is currently planned, but not until February 22nd per this advisory:
https://status.solarwindsmsp.com/2020/12/18/update-digital-certificate-revocation-date-change/

Some parties have recommended using the existing certificate as an IOC:
https://github.com/fireeye/sunburst_countermeasures/pull/3

## Manually revoking the certificate

In order to be more proactive, this script will allow you to revoke the certificate immediately. In order to ensure its content can be independently verified, I do not ship any executables or certificates themselves. Accordingly, running this script starts by downloading the free "Azure Cost Calculator" (~90MB download) from Solarwinds. This is a *non malicious* file, signed by the impacted code signing certificate.

## Automated Deployment

In a larger network you would be much better served with a Group Policy Object to automate this process. However, you may wish to start with this script to most easily obtain the certificate to revoke.

## Usage

From an Administrative Powershell session, run the script `RevokeSolar.ps1` from a temporary directory. Once completed the script and the file it creates in that temporary directory may be deleted.

## Impact

Windows does not always outright block an executable with a revoked certificate. However, UAC will always deny execution "as administrator". You can find this documented here:

https://docs.microsoft.com/en-us/troubleshoot/windows-client/identity/uac-blocks-elevation-executable-apps

If you would like to test this as a standard user, you may need to wait a while due to OCSP caching. After which, running the executable should present you a less firm, but still unskippable block message:

![Running executable with revoked certificate](standarduser.png)
