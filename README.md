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

>You will obtain an RSA 4096 bits private key, and the associated public key

# Example

## File signature with signature mode

**Command line :** `PowerSign.ps1 -mode signature -privateKey C:\dossier\private.key -signature C:\folder\signature.sha512 -file C:\folder\file_to_sign.pdf`

>Whith this command line :   
>- use sign mode  
>- with private key private.key  
>- signature will be in file C:\folder\signature.sha512  
>- C:\folder\file_to_sign.pdf will be the signed file  

## File check with check mode

**Command line :** `PowerSign.ps1 -mode check -publicKey C:\folder\public.pub -signature C:\folder\signature.sha512 -file C:\folder\file_to_check.pdf`

>With this command line : 
>- use check mode
>- with public key public.pub
>- signature is in file C:\folder\signature.sha512
>- signed file to check is C:\folder\file_to_check.pdf
