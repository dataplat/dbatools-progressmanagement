function Test-SyntaxError
{
    [CmdletBinding()]
    Param (
        $Errors
    )
    
    It -name "Should contain no syntax errors" -test {
        Should -ActualValue $Errors.Length -Be 0
    }
    
    Write-TestResult -Name "Syntax" -Result ($Errors.Length -eq 0)
}