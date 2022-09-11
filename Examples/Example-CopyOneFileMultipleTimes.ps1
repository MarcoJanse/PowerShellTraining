# Copy one file multiple times

$SourcePath = 'C:\Scripts\input'
$SourceFile = 'TextFiletoCopy.txt'
$DestinationPath = 'C:\Scripts\output'

1..3 | ForEach-Object { Copy-Item -Path $SourcePath\$SourceFile -Destination $DestinationPath\Copy-$_.txt }