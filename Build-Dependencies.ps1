param(
	[Parameter(Mandatory = $true)]
	[string]$ProjectPath,
	[Parameter(Mandatory = $false)]
	[switch]$IsExtensionModule
)

$projectRoot = Split-Path $ProjectPath -Parent
$libFolder = "$projectRoot\lib"
$projectName = (Get-Item $ProjectPath).BaseName

# Builds all libraries that PoShLog depends on
dotnet publish -c Release $ProjectPath -o $libFolder

# Remove unecessary files
Get-ChildItem $libFolder | Where-Object { $_.Name -like "*$projectName*" } | Remove-Item -Force

if($IsExtensionModule){
	Remove-Item -Path "$libFolder\Serilog.dll" -Force
}

# Remove unecessary bin and obj folders
Remove-Item -Path @("$projectRoot\bin", "$projectRoot\obj") -Recurse -Force