# Powershell Module practice

function Get-Day () {
    return (Get-Date).Day
}

function Print-Day() {
    echo "Today is the $(get-day)"
}

export-modulemember -function Print-Day