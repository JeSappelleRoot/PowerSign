# Script arguments for command line
param(
[string]$privateKey,
[string]$publicKey,
[string]$mode,
[string]$signature,
[string]$file
)



function displayBanner {
# It's always better with a banner


Write-Host "
  _____                       _____ _             
 |  __ \                     / ____(_)            
 | |__) |____      _____ _ _| (___  _  __ _ _ __  
 |  ___/ _ \ \ /\ / / _ \ '__\___ \| |/ _' | '_ \ 
 | |  | (_) \ V  V /  __/ |  ____) | | (_| | | | |
 |_|   \___/ \_/\_/ \___|_| |_____/|_|\__, |_| |_|
                                       __/ |      
                                      |___/       

" -ForegroundColor Green

}


function displayHelp {
# Function to display some help

Write-Host "

Sign method use SHA512 fingerprint method, which will sign with an asymetric key
    
-privateKey : private key used to sign
-publicKey  : public key used to verify signature
-mode       : [sign/check] to specify which mode use
-signature  : file which contains signature
-file       : specify which file sign/check
"



Write-Host "
Example : 

File signature :
PowerSign.ps1 -mode signature -privateKey C:\folder\private.key -signature C:\folder\signature.sha512 -file C:\folder\file_to_sign.pdf

Whith this command line : 
- use sign mode
- with private key private.key
- signature will be in file C:\folder\signature.sha512
- C:\folder\file_to_sign.pdf will be the signed file


Check signature :
PowerSign.ps1 -mode check -publicKey C:\folder\public.pub -signature C:\folder\signature.sha512 -file C:\folder\file_to_check.pdf

With this command line : 
- use check mode
- with public key public.pub
- signature is in file C:\folder\signature.sha512
- signed file to check is C:\folder\file_to_check.pdf

------------------------------------------
Remember - To generate asymetric keys, use these commands : 
- openssl.exe genrsa -out private.key 4096
- openssl.exe rsa -in private.key -text -noout
- openssl.exe rsa -in private.key -pubout > public.pub
- openssl.exe rsa -in public.pub -pubin -text -noout
"
}



function makeSign ($exe, $key, $signFile, $inputFile) {
# Function to make a signature

    # Pipe openssl process with -Passthru
    $process = Start-Process $exe -NoNewWindow -Wait -ArgumentList "dgst -sha512 -sign $key -out $signFile $inputFile" -PassThru
    
    # Check exit code
    if ($process.ExitCode -eq 0) {Write-Host "[+] $inputFile successfully signed " -ForegroundColor Green}
    elseif ($process.ExitCode -ne 0) {Write-Host "[!] Something wrong happened when trying to sign $inputFile" -ForegroundColor Red -BackgroundColor White}
    
    return
}


function makeCheck ($exe, $key, $signFile, $inputFile) {
# Function to check signature

    # Pipe process with -Passthru
    $process = Start-Process $exe -NoNewWindow -Wait -ArgumentList "dgst -sha512 -verify $key -signature $signFile $inputFile" -PassThru
    
    # Check exit code
    if ($process.ExitCode -eq 0) {
    Write-Host "[+] $inputFile signature successfully checked " -ForegroundColor Green}
    elseif ($process.ExitCode -ne 0) {Write-Host "[!] $inputFile signature could not be verified" -ForegroundColor Red -BackgroundColor White}
    
    return
}

# ------------------------------------------ Main ------------------------------------------

# It's always better with a banner
displayBanner

# OpenSSL binary path
# With error condition
$opensslBin = "C:\OpenSSL-Win64\bin\openssl.exe"
if (-not(Test-Path $opensslBin)) {
    Write-Host "[!] Please check OpenSSL binary path : $opensslBin" -ForegroundColor Red -BackgroundColor White
    Exit

}

# Error condition for script parameters
if ($PSBoundParameters.Count -ne 4) {displayHelp}

# Switch mode of script
switch ($mode) {

# Sign mode
'sign' {

    # If the specified private key doesn't exist
    if (-not(Test-Path $privateKey)) {
        Write-Host "[!] Specified private key not found : $privateKey" -ForegroundColor Red
        $privateKey
        Exit
        }

    # If the specified file to sign doesn't exist
    if (-not(Test-Path $file)) {
        Write-Host "[!] Specified file to sign not found : $file" -ForegroundColor Red
        Exit
        }

    # Sign file with function
    makeSign $opensslBin $privateKey $signature $file

}


# Check mode
'check' {

    # If public key doesn't exist
    if (-not(Test-Path $publicKey)) {
        Write-Host "[!] Public key not found : $publicKey" -ForegroundColor Red 
        Exit
    }

    # If signature file doesn't exist, or not found
    if (-not(Test-Path $signature)) {
        Write-Host "[!] File containing signature not found : $signature" -ForegroundColor Red
        Exit
    }

    # If specified file to check doesn't exist, or not found
    if (-not(Test-Path $file)) {
        Write-Host "[!] Specified file not found : $file" -ForegroundColor Red
        Exit
    }

    # Check signature file
    makeCheck $opensslBin $publicKey $signature $file

    }

}


