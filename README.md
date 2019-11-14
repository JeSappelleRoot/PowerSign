# PowerSign


PowerSign is a simple Powershell script to perform checks and signatures with OpenSSL Windows version. 

# Command line arguments

Sign method use SHA512 fingerprint method, which will sign with an asymetric key  
    
- **-privateKey** : private key used to sign  
- **-publicKey**  : public key used to verify signature  
- **-mode**       : [sign/check] to specify which mode use  
- **-signature**  : file which contains signature  
- **-file**       : specify which file sign/check  

# Asymetric key generation

To generate pair of private and public keys, you can use the following command : 
```
openssl.exe genrsa -out private.key 4096
openssl.exe rsa -in private.key -pubout > public.pub
```
![generate](https://user-images.githubusercontent.com/52102633/68892223-199b2a00-06e8-11ea-8044-4fe375234726.jpg)

>You will obtain an RSA 4096 bits private key, and the associated public key

> Many others method can be used to generate private and public key

# OpenSSL path

Before use PowerSign script, you need to specify the OpenSSL binary path.  
Line 115, modify `$opensslBin = "C:\OpenSSL-Win64\bin\openssl.exe"` and adjust it to your OpenSSL configuration


# Example

## File signature with signature mode

**Command line :** `PowerSign.ps1 -mode signature -privateKey C:\folder\private.key -signature C:\folder\signature.sha512 -file C:\folder\file_to_sign.pdf`

>Whith this command line :   
>- use sign mode  
>- with private key private.key  
>- signature will be in file C:\folder\signature.sha512  
>- C:\folder\file_to_sign.pdf will be the signed file  

![signature](https://user-images.githubusercontent.com/52102633/68892224-199b2a00-06e8-11ea-829d-f7fd6d7b0625.jpg)

## File check with check mode

**Command line :** `PowerSign.ps1 -mode check -publicKey C:\folder\public.pub -signature C:\folder\signature.sha512 -file C:\folder\file_to_check.pdf`

>With this command line : 
>- use check mode
>- with public key public.pub
>- signature is in file C:\folder\signature.sha512
>- signed file to check is C:\folder\file_to_check.pdf
