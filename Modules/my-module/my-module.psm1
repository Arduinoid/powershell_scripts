# Powershell Module practice

function Get-Day () {
    return (Get-Date).Day
}

function Print-Day() {
    echo "Today is the $(get-day)"
}

function foo() {
    echo "I do nothing"
}

new-alias -Name pday -Value Print-Day
new-alias -Name bar -Value foo