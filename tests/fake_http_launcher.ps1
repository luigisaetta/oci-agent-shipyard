<#
.SYNOPSIS
Test launcher: runs a PowerShell script with a fake Invoke-WebRequest.

.DESCRIPTION
The verifier probes endpoints with Invoke-WebRequest, which the fake curl of the
Bash tests does not replace. This launcher defines a global function with the
same name, which PowerShell resolves before the cmdlet, then runs the target
script with the remaining arguments and returns its exit code.
A request with an Authorization header answers 200; one without answers 200,
or FAKE_HTTP_UNAUTHENTICATED_STATUS when set. No network access is made.
Usage: pwsh -NoProfile -File fake_http_launcher.ps1 TARGET.ps1 [ARGUMENTS...]
#>
function global:Invoke-WebRequest {
    [CmdletBinding()]
    param(
        [string]$Uri,
        [string]$Method,
        [hashtable]$Headers,
        [int]$TimeoutSec,
        [switch]$SkipHttpErrorCheck
    )
    $status = 200
    $authenticated = $Headers -and $Headers.ContainsKey('Authorization')
    if (-not $authenticated -and $env:FAKE_HTTP_UNAUTHENTICATED_STATUS) {
        $status = [int]$env:FAKE_HTTP_UNAUTHENTICATED_STATUS
    }
    [pscustomobject]@{ StatusCode = $status }
}

$target = $args[0]
$rest = @($args | Select-Object -Skip 1)
& $target @rest
exit $LASTEXITCODE
