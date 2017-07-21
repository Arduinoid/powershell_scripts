# Testing function param passing
function show-params
{
    Param ([String]$first,[String]$second)
    Write-Output "First param is $first"
    Write-Output "Second param is $second"
}