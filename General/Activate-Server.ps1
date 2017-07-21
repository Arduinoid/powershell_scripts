function Activate-Server ($key) {
$command = "dism /online /set-edition:ServerStandard /productkey:{0} /accepteula"
Invoke-Expression -Command $($command -f $key)
}