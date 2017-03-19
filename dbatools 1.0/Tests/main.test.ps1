[CmdletBinding()]
Param (
    [switch]
    $UseMaster,
    
    [switch]
    $SkipDownload
)

#region Preparing the playing field
if (-not $SkipDownload)
{
    if ($UseMaster) { $url = 'https://github.com/sqlcollaborative/dbatools/archive/master.zip' }
    else { $url = 'https://github.com/sqlcollaborative/dbatools/archive/development.zip' }
    
    $temp = ([System.IO.Path]::GetTempPath()).TrimEnd("\")
    $zipfile = "$temp\dbatools.zip"
    
    Invoke-WebRequest $url -OutFile $zipfile
    Unblock-File $zipfile -ErrorAction SilentlyContinue
    
    Remove-Item "$temp\dbatools" -Recurse -Force
    $root = New-Item -Path $temp -Name "dbatools" -ItemType Directory -Force
    
    Expand-Archive -Path $zipfile -DestinationPath $root.FullName
    
    $root = Get-ChildItem -Path $root.FullName | Select-Object -First 1
}
else
{
    $temp = ([System.IO.Path]::GetTempPath()).TrimEnd("\")
    $root = "$temp\dbatools" | Get-ChildItem | Select-Object -First 1
}

Remove-Module -Name dbatools -ErrorAction Ignore
Import-Module "$($root.FullName)\dbatools.psm1"

$functions_public = Get-ChildItem -Path "$($root.FullName)\functions" -Filter "*.ps1"
$functions_internal = Get-ChildItem -Path "$($root.FullName)\internal\" -Filter "*.ps1" | Where-Object Name -ne DynamicParams.ps1

# Add Utilities
. "$PSScriptRoot\Get-FunctionValidationTags.ps1"
. "$PSScriptRoot\Write-TestResult.ps1"

# Add testing functions
. "$PSScriptRoot\Test-DeprecatedVerbosityCommands.ps1"
. "$PSScriptRoot\Test-CodeStyle.ps1"
. "$PSScriptRoot\Test-EvilBreakContinue.ps1"
. "$PSScriptRoot\Test-FlowControl.ps1"
. "$PSScriptRoot\Test-FunctionName.ps1"
. "$PSScriptRoot\Test-MessagingUsage.ps1"
. "$PSScriptRoot\Test-ParamSilentExists.ps1"
. "$PSScriptRoot\Test-PipelineImplementation.ps1"
. "$PSScriptRoot\Test-SyntaxError.ps1"
#endregion Preparing the playing field

$global:results_public = @{ }
$global:results_internal = @{ }
$global:BadFunctions = @()

$ContinueBreakExceptions = Get-Content "$PSScriptRoot\ContinueBreakExceptions.txt"

Describe "Testing dbatools in its entirety on its path to Release 1.0" {
}

#region Process public functions
Describe "Testing Public functions" {
    foreach ($function in $functions_public)
    {
        $file = (Get-Content -Path $Function.FullName -ReadCount 0) -join ""
        $Tokens = $null
        $Errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($Function.FullName, [ref]$Tokens, [ref]$Errors)
        $tags = Get-FunctionValidationTags -Function $function
        
        $functionObject = @{
            Name = ($Ast.EndBlock.Statements.Name)
        }
        
        Context "Testing function: $($function.BaseName)" {
            
            # Parsed tests
            Test-SyntaxError -Errors $Errors
            Test-DeprecatedVerbosityCommands -File $file
            Test-FunctionName -Ast $ast
            Test-ParamSilentExists -Ast $ast
            Test-EvilBreakContinue -Tokens $Tokens -Exceptions $ContinueBreakExceptions -Ast $ast
            
            # Tag based tests
            Test-CodeStyle -Tags $tags
            Test-MessagingUsage -Tags $tags
            Test-FlowControl -Tags $tags
            Test-PipelineImplementation -Tags $tags
        }
        
        if ($Ast.EndBlock.Statements.Name) { $global:results_public[$Ast.EndBlock.Statements.Name] = New-Object PSObject -Property $functionObject }
        else { $global:BadFunctions += $function.Name }
    }
    #endregion Process public functions
}

#region Process internal functions
foreach ($function in $functions_internal)
{
    $file = (Get-Content -Path $Function.FullName -ReadCount 0) -join ""
    $Tokens = $null
    $Errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Function.FullName, [ref]$Tokens, [ref]$Errors)
    $tags = Get-FunctionValidationTags -Function $function
    
    $functionObject = @{
        Name = ($Ast.EndBlock.Statements.Name)
    }
    
    Context "Testing function: $($function.BaseName)" {
        
        # Parsed tests
        Test-SyntaxError -Errors $Errors
        if ($Ast.EndBlock.Statements.Name -ne "Write-Message") { Test-DeprecatedVerbosityCommands -File $file }
        #Test-FunctionName -Ast $ast
        #Test-ParamSilentExists -Ast $ast
        Test-EvilBreakContinue -Tokens $Tokens -Exceptions $ContinueBreakExceptions -Ast $ast
        
        # Tag based tests
        Test-CodeStyle -Tags $tags
        #Test-MessagingUsage -Tags $tags
        #Test-FlowControl -Tags $tags
        Test-PipelineImplementation -Tags $tags
    }
    
    if ($Ast.EndBlock.Statements.Name) { $global:results_internal[$Ast.EndBlock.Statements.Name] = New-Object PSObject -Property $functionObject }
    else { $global:BadFunctions += $function.Name }
}
#endregion Process internal functions

#region Generate Output files
Write-Host @"
Writing results to file in the current directory.

The following functions had some odd issue and are not on the list, though they too experienced a Pester test:
$($BadFunctions -join "`n")
"@
$global:results_internal.Values | Select-Object Name, Syntax, Pipeline, CodeStyle, BreakContinue, DeprecatedVerbostyCommands | Export-Csv -Path "internal.csv" -NoTypeInformation
$global:results_internal.Values | Select-Object Name, Syntax, Pipeline, CodeStyle, BreakContinue, DeprecatedVerbostyCommands | ConvertTo-Html | Set-Content -Path "internal.html" -Encoding UTF8
$global:results_public.Values | Select-Object Name, Syntax, Pipeline, CodeStyle, FlowControl, Messaging, FunctionName, SilentParameter, BreakContinue, DeprecatedVerbostyCommands | Export-Csv -Path "public.csv" -NoTypeInformation
$global:results_public.Values | Select-Object Name, Syntax, Pipeline, CodeStyle, FlowControl, Messaging, FunctionName, SilentParameter, BreakContinue, DeprecatedVerbostyCommands | ConvertTo-Html | Set-Content -Path "public.html" -Encoding UTF8
#endregion Generate Output files