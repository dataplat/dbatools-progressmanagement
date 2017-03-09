function Write-TestResult
{
    [CmdletBinding()]
    Param (
        [String]
        $Name,
        
        [bool]
        $Result
    )
    
    $functionObject[$Name] = $Result
}