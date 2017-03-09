function Test-MessagingUsage
{
    [CmdletBinding()]
    Param (
        [string[]]
        $Tags
    )
    
    It "Should contain the Tag 'Messaging'" {
        Should -ActualValue "Messaging" -BeIn $Tags
    }
    
    Write-TestResult -Name "Messaging" -Result ("Messaging" -in $Tags)
}