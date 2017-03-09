function Test-DeprecatedVerbosityCommands
{
    [CmdletBinding()]
    Param (
        [string]
        $File
    )
    
    It -name "Should not use Write-Verbose, Write-Host, Write-Output, Write-Warning, Write-Debug or Write-Information" -test {
        $test = $file -Match "(?s)^(?!.*(Write-Verbose|Write-Host|Write-Output|Write-Warning|Write-Debug|Write-Information)).*"
        Should -ActualValue $test -Be $true
    }
    
    Write-TestResult -Name "DeprecatedVerbosityCommands" -Result $test
}