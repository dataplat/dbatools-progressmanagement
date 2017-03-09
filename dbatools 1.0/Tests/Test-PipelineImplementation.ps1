function Test-PipelineImplementation
{
    [CmdletBinding()]
    Param (
        [string[]]
        $Tags
    )
    
    It "Should contain the Tag 'Pipeline'" {
        Should -ActualValue "Pipeline" -BeIn $Tags
    }
    
    Write-TestResult -Name "Pipeline" -Result ("Pipeline" -in $Tags)
}