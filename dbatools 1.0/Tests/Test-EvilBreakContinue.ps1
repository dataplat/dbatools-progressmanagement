function Test-EvilBreakContinue
{
    [CmdletBinding()]
    Param (
        $Tokens,
        
        [string[]]
        $Exceptions,
        
        $Ast
    )
    
    if ($Exceptions -contains $Ast.EndBlock.Statements.Name) { return }
    
    It -name "Should not contain continue/break" -test {
        $test = $null
        $test = $Tokens | Where-Object -Property Text -Match '^continue$|^break$'
        Should -ActualValue $test -BeNullOrEmpty
    }
    
    Write-TestResult -Name "BreakContinue" -Result ($null -eq $test)
}