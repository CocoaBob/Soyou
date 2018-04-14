# Update Certificate for Apple Push Notification Service 

## 1. Create Certificate

##### 1.1 Open Developer website

https://developer.apple.com/account/ios/certificate/create/

##### 1.2 Create a Certificate Signing Request (CSR)

To manually generate a Certificate, you need a Certificate Signing Request (CSR) file from your Mac. To create a CSR follow the instructions below to create one using Keychain Access.

In the Applications folder on your Mac, open the Utilities folder and launch Keychain Access.

Within the Keychain Access drop down menu, select Keychain Access > Certificate Assistant > Request a Certificate from a icate Authority.

1. In the Certificate Information window, enter the following information:
2. In the User Email Address field, enter your email address.
3. In the Common Name field, create a name for your private key (e.g., John Doe Dev Key).
4. The CA Email Address field should be left empty.
5. In the "Request is" group, select the "Saved to disk" option.
6. Click Continue within Keychain Access to complete the CSR generating process.

##### 1.3 Download Certificate and import to Keychain

Download the certificate file, and double click to import.

## 2. Convert Certificate and Private Key to `pem` format

After requesting the certificate from Apple, download the `.cer` file (usually named `aps_production.cer` or `aps_development.cer`) from the iOS Provisioning Portal, save in a clean directory, and import it into Keychain Access.

It should now appear in the keyring under the "Certificates" category, as `Apple Push Services`. Inside the certificate you should see a private key (only when filtering for the "Certificates" category). Export this private key as a `.p12` file.

Now, in the directory containing `cert.cer` and `key.p12`, execute the following commands to generate your `.pem` files:

	$ openssl x509 -in cert.cer -inform DER -outform PEM -out cert.pem
	$ openssl pkcs12 -in key.p12 -out key.pem -nodes
	
Test certificates:

	$ openssl s_client -connect gateway.push.apple.com:2195 -cert cert.pem -key key.pem # production

If you are using a development certificate you may wish to name them differently to enable fast switching between development and production. The filenames are configurable within the module options, so feel free to name them something more appropriate.

## 3. Use the content of Certificate and Private Key from `pem` files


