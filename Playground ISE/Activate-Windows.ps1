function Activate-Windows ($csvfile) {
$keys = import-csv -Path $csvfile
$server_model = ((Get-CimInstance CIM_ComputerSystem).model -split ' ')[1]
$product_key = ($keys | ? server -like $server_model).key
$command = "dism /online /set-edition:ServerStandard /productkey:{0} /accepteula"

Invoke-Expression -Command $($command -f $product_key)
}