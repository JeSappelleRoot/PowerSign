# PowerSign

- [PowerSign](#powersign)
- [Command line arguments](#command-line-arguments)
- [Asymetric key generation](#asymetric-key-generation)
- [OpenSSL path](#openssl-path)
- [Example](#example)
  - [File signature with signature mode](#file-signature-with-signature-mode)
  - [File check with check mode](#file-check-with-check-mode)
  - [In case of file alteration/modification](#in-case-of-file-alterationmodification)
- [Troubleshooting](#troubleshooting)
  - [Unable to load key file](#unable-to-load-key-file)


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

- Generate private key
```
openssl.exe genrsa -out private.key 4096
openssl.exe rsa -in private.key -text -noout
```
- Generate public key
```
openssl.exe rsa -in private.key -pubout > public.pub
openssl.exe rsa -in public.pub -pubin -text -noout
```
![generate](https://user-images.githubusercontent.com/52102633/68892223-199b2a00-06e8-11ea-8044-4fe375234726.jpg)

>You will obtain an RSA 4096 bits private key, and the associated public key

> Many others method can be used to generate private and public key

# OpenSSL path

Before use PowerSign script, you need to specify the OpenSSL binary path.  
Line 114, modify `$opensslBin = "C:\OpenSSL-Win64\bin\openssl.exe"` and adjust it to your OpenSSL configuration


# Example

Assume we have a file like :   

![file](https://user-images.githubusercontent.com/52102633/68892222-199b2a00-06e8-11ea-8b0c-ac01cc72ec08.jpg)

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

![check](https://user-images.githubusercontent.com/52102633/68897105-6e43a280-06f2-11ea-8671-70b6a3be09b1.jpg)

## In case of file alteration/modification

Assume the previous file is modified with the new following content : 

![modified TXT](https://user-images.githubusercontent.com/52102633/68897108-6e43a280-06f2-11ea-9c57-f51bb41061b6.jpg)

A new signature checking with PowerSign will report a error : 

![check failed](https://user-images.githubusercontent.com/52102633/68897107-6e43a280-06f2-11ea-8349-c4f8fd146e3e.jpg)

# Troubleshooting

## Unable to load key file

If you encounter the following message during : 
- public key generation
- signature check with public key

![ts1](https://user-images.githubusercontent.com/52102633/68897110-6e43a280-06f2-11ea-9b6e-9a5654eb64c3.jpg)

![ts2](https://user-images.githubusercontent.com/52102633/68897111-6edc3900-06f2-11ea-8621-b25b20b7848c.jpg)

**Check the public key format file**

![solution](https://user-images.githubusercontent.com/52102633/68897109-6e43a280-06f2-11ea-9511-1dc219c60df0.jpg)

> OpenSSL needs a public key encoded with UTF-8