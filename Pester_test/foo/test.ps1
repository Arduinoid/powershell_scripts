function Add-TwoTo($a) {
    return $a + 2
}

Describe "Add-TwoTo" {
    It "adds two to a given number" {
        $sum = Add-TwoTo 5
        $sum | Should Be 7
    }

    It "adds two to a negative number" {
        $sum = Add-TwoTo (-4)
        $sum | Should Be (-2)
    }

    It "adds two to nothing and outputs two" {
        $sum = Add-TwoTo 
        $sum | Should Be 2
    }
}