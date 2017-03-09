function Test-FunctionName
{
    [CmdletBinding()]
    Param (
        $Ast
    )
    
    It "Should have a name with the Dba prefix" {
        Should -ActualValue $Ast.EndBlock.Statements.Name -Match "-Dba"
    }
    
    Write-TestResult -Name "FunctionName" -Result ($Ast.EndBlock.Statements.Name -Match "-Dba")
}