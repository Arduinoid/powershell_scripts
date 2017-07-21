$sd_card = 'H:\'
$fullPath = 'C:\Users\Jon\Documents\Code\'
$file = 'CentOS-7-x86_64-Minimal-1511.iso'
 
 function Measure-WriteSpeed ($drive, $fullPath, $file)
 {
 $time = Measure-Command {`
 Copy-Item "$fullPath$file" -Destination $drive }
 Remove-Item "$drive$file"
 return $time.Seconds, $time.Milliseconds
 }

 function Measure-ReadSpeed ($drive, $fullPath, $file)
 {
 $time = Measure-Command {`
 Copy-Item "$drive$file" -Destination $fullPath }
 Remove-Item "$fullpath$file"
 return $time.Seconds, $time.Milliseconds
 }