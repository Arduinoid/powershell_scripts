function bar($a) {
    if ($a.GetType() -eq [bool]) {
        return -not $a
    }
    else {
        return "Not a bool"
    }
}
