$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "bar" {
    It "bar will return true when given false" {
        bar $False | Should Be $True
    }

    It "bar will return false when given true" {
        bar $True | Should Be $False
    }

    It "bar given a string value returns message" -Pending {
        bar 'hi' | Should Be "Not a bool"
    }
    
    It "bar given an int value returns message" -skip {
        bar 15 | Should Be "Not a bool"
    }
}
