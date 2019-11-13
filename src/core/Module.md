# Connects to Oracle Core Services from Ballerina

*Copyright © 2019 Oracle and/or its affiliates. All rights reserved.*

# Module Overview

The Oracle Core Services connector allows you to work with Oracle Core Services API through Ballerina. The following section provides you with the details on connector operations.

The Oracle Core Services connector allows you to work with the following Oracle cloud resources:
```
- Instance
- VCN
- Route Table
- Internet Gateway
- NAT Gateway
- Subnet
- Service Gateway
- Security List
```

**Instance Operations**

The `oracle/core` module contains operations that work with Instances. You can get, update instance action[START/STOP/SOFTRESET/SOFTSTOP/RESET], launch, list, terminate, update.

**VCN[Virtual Cloud Network] Operations**

The `oracle/core` module contains operations that work with VCNs. You can create, delete, get, list, update.

**Route Table Operations**

The `oracle/core` module contians operations that work with Route Tables. You can get, create, delete, list, update.

**Service Gateway Operations**

The `oracle/core` module contains operations that work with Service Gateways. You can list services in the region, list, get, create, delete, change compartment, attach service ID, detach service ID.

**Internet Gateway Operations**

The `oracle/core` module contains operations that work with Internet Gateways. You can get, list, delete, update, create.

**NAT[Network Address Translation] Gateway Operations**

The `oracle/core` module contains operations that work with NAT Gateways. You can get, list, delete, update, create.

**Security List Operations**

The `oracle/core` module contains operations that work with Security Lists. You can get, create, delete, get, list, update.

**Subnet Operations**

The `oracle/core` module contains operations that work with Subnet. You can get, list, delete, update, create.

## Compatibility

<table>
<thead>
	<tr>
		<th></th>
		<th>Version</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td>Ballerina Language</td>
		<td>1.0.1 </td>
	</tr>
	<tr>
		<td>Oracle Core Services API</td>
		<td>20160918</td>
	</tr>
</tbody>
</table>

## Running Sample

Let's get started with a simple program in Ballerina to get an instance.

Add the below dependency in your Ballerina.toml file.

```
[dependencies]
"oracle/core" = { path = "path-to-core.balo", version = "0.1.0"}
```

You can use the `oracle/core` module to integrate with Oracle Core Services. Import the `oracle/core` module into the Ballerina project.

```ballerina
import ballerina/io;
import ballerina/config;
import oracle/core;

string host = config:getAsString("HOST_CORE");
string tenancyId = config:getAsString("TENANCY_ID"); 
string authUserId= config:getAsString("AUTHUSER_ID"); 
string keyFingerprint = config:getAsString("KEYFINGERPRINT"); 
string pathToKey = config:getAsString("PATHTOKEY"); 
string keyStorePassword = config:getAsString("KEYSTOREPASSWORD"); 
string keyAlias = config:getAsString("KEYALIAS"); 
string keyPassword = config:getAsString("KEYPASSWORD"); 

# OCI Client endpoint
core: OciConfiguration ociConfig = {
    host: host,
    tenancyId: tenancyId,
    authUserId: authUserId,
    keyFingerprint: keyFingerprint,
    pathToKey: pathToKey,
    keyStorePassword: keyStorePassword,
    keyAlias: keyAlias,
    keyPassword: keyPassword
};
   
core:Client ociClient = new(ociConfig);

public function main() {
    var instanceResponse = ociClient->getInstance(<Instance OCID>);
    io:println("Instance display name: ", instanceResponse.displayName);
}
```

#### Before you Begin

1. Sign up for an [Oracle Cloud account](https://myservices.us.oraclecloud.com/mycloud/signup?sourceType=_ref_coc-asset-opcSignIn&language=en)
2. You need to get host core url based on region and credentials such as tenancy ID, authorized user ID, key fingerprint, path to key, keystore password, key alias and key password.
3. In the directory wher eyou have your sample, create a `ballerina.conf` file and add the details you obtained from your account and instructions below.

**Obtaining Account IDs**

Follow [Oracle Documentation](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm) to generate API signing key, upload public key, get key fingerprint and retrieve tenancy and user OCID's. 

**Creating PEM key and converting to PKCS12 format**

Refer [Oracle Documentation](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#How3)

1. Use this to create a PEM key WITH a password and add the public key to your account!

```openssl genrsa -out ~/.oci/oci_api_key.pem -aes128 2048```


2. This converts the PEM to PKSC12 with the alias/name. It will prompt for the PEM password. It will also prompt you for a keystore password.

```openssl pkcs12 -export -nocerts -inkey ~/.oci/<KEY_NAME>.pem -in ~/.oci/<KEY_NAME>.pem -out ~/.oci/<KEY_NAME_P12>.p12 -name "<KEY_ALIAS>"```

# Ballerina Configuration File
Create or update `ballerina.conf` file in your project with following configurations and provide appropriate values. Below is an example.

    ```
    HOST_CORE = "iaas.us-ashburn-1.oraclecloud.com" (region of the tenancy in which you are working)
    TENANCY_ID = "<TENANCY OCID>"
    AUTHUSER_ID = "<USER OCID>"
    KEYFINGERPRINT = "<FINGERPRINT ADDED TO THE ABOVE USER>"
    PATHTOKEY = "<PATH TO OCI KEY IN .P12 format>"
    KEYSTOREPASSWORD = "<KEYSTORE PASSWORD>"
    KEYALIAS = "<KEY ALIAS>"
    KEYPASSWORD = "<KEY PASSWORD>"
    ```