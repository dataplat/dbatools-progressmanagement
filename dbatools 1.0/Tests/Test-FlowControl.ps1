function Test-FlowControl
{
    [CmdletBinding()]
    Param (
        [string[]]
        $Tags
    )
    
    It "Should contain the Tag 'FlowControl'" {
        Should -ActualValue "FlowControl" -BeIn $Tags
    }
    
    Write-TestResult -Name "FlowControl" -Result ("FlowControl" -in $Tags)
}