function Get-Thing {
    param()
    [pscustomobject]@{
        Name = 'thing1'
        Description = 'thing1 description'
    }
    [pscustomobject]@{
        Name = 'thing2'
        Description = 'thing2 description'
    }
}

function Set-Thing {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,
        Mandatory,
        HelpMessage="You must pass in a name",
        ValueFromPipelineByPropertyName)]
        [String]$Name,

        [Parameter(Position=1)]
        [Int]$Number=1,

        [Parameter()]
        [ValidateSet('Space','Comma','Colon')]
        $Delimiter
    )
    switch ($Delimiter) {
        'Space' {$thing = ' '}
        'Comma' {$thing = ','}
        'Colon' {$thing = ':'}
        default {$thing = ''}
    }
    ($Name + $thing) * $Number
}