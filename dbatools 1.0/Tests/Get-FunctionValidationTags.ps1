function Get-FunctionValidationTags
{
    [CmdletBinding()]
    Param (
        [System.IO.FileInfo]
        $Function
    )
    
    $line = Get-Content -Path $Function.FullName -ReadCount 1 -TotalCount 1
    
    if ($line -match "#ValidationTags#") { return $line.Trim('#').Split("#")[1].Split(",") }
}