function Test-ParamEnableExceptionExists
{
    [CmdletBinding()]
    Param (
        $Ast
    )
    
    It "Should contain a switch parameter named EnableException" {
        $test = 1 -eq ($Ast.EndBlock.Statements.Body.ParamBlock.Parameters | Where-Object Name -like '$EnableException' | Where-Object StaticType -eq ([System.Management.Automation.SwitchParameter])).Count
        Write-TestResult -Name "EnableException" -Result $test
        Should -ActualValue $test -Be $true
    }
}