# --------- Listener ---------
$listener = [System.Net.Sockets.TcpListener]::new("0.0.0.0", 4444)
$listener.Start()
Write-Host "Listening on port 4444..."

$client = $listener.AcceptTcpClient()
Write-Host "Connection received from" $client.Client.RemoteEndPoint

$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true
$buffer = New-Object byte[] 4096

while ($client.Connected) {
    $input = Read-Host "PS (ether) "
    $writer.WriteLine($input)

    $responseBuilder = ""

    while ($true) {
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -le 0) { break }

        $chunk = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
        $responseBuilder += $chunk

        if ($chunk -like "*$#*") { break }
    }

    $response = $responseBuilder -replace "\$\#", ""
    Write-Host $response
}
