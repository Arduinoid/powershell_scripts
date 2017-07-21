workflow Do-Stuff {
    param (
        $Hosts
    )
    $connected = @()
    $range = @(1..255)
    foreach -parallel ($r in $range) {
        Test-Connection "10.11.7.$r" -count 1 -BufferSize 16 -ErrorAction SilentlyContinue
    }
}