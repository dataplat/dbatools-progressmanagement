function Test-CodeStyle
{
    [CmdletBinding()]
    Param (
        [string[]]
        $Tags
    )
    
    It "Should contain the Tag 'CodeStyle'" {
        Should -ActualValue "CodeStyle" -BeIn $Tags
    }
    
    Write-TestResult -Name "CodeStyle" -Result ("CodeStyle" -in $Tags)
}