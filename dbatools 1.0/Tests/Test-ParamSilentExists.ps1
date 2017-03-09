function Test-ParamSilentExists
{
    [CmdletBinding()]
    Param (
        $Ast
    )
    
    It "Should contain a switch parameter named silent" {
        $test = $null -eq ($Ast.EndBlock.Statements.Body.ParamBlock.Parameters | Where-Object Name -like '$Silent' | Where-Object StaticType -eq ([System.Management.Automation.SwitchParameter]))
        Should -ActualValue $test -Be $true
    }
    
    Write-TestResult -Name "SilentParameter" -Result $test
}