# Connects to Oracle Identity and Access Management Services (IAM) from Ballerina

*Copyright © 2019 Oracle and/or its affiliates. All rights reserved.*

# Module Overview

The Oracle IAM Services connector allows you to work with Oracle Identity and Access Management Service API through Ballerina. The following section provides you with the details on connector operations.

The Oracle IAM Services connector allows you to work with the following Oracle cloud resources:
```
- User
- Group
- Compartment
```

**User Operations**

The `oracle/iam` module contains operations that work with Users. You can create, delete, get, list, update.

**Group Operations**

The `oracle/iam` module contains operations that work with Groups. You can create, delete, get, list, update.

**Compartment Operations**

The `oracle/iam` module contians operations that work with route tables. You can get, create, delete, list,  update.

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
		<td>Oracle Identity and Access Management Service API</td>
		<td>20160918</td>
	</tr>
</tbody>
</table>

## Running Sample

Let's get started with a simple program in Ballerina to get an user.

Add the below dependency in your Ballerina.toml file.

```
[dependencies]
"oracle/iam" = { path = "https://github.com/oracle/ballerina-oci/blob/master/target/balo/iam-2019r3-any-0.1.0.balo", version = "0.1.0"}
```

You can use the `oracle/iam` module to integrate with Oracle IAM Services. Import the `oracle/iam` module into the Ballerina project.

```ballerina
import ballerina/io;
import oracle/iam;

iam:OciConfiguration ociConfig = {
    host: "",
    tenancyId: "",
    authUserId: "",
    keyFingerprint: "",
    pathToKey: "",
    keyStorePassword: "",
    keyAlias: "",
    keyPassword: ""
};
   
iam:Client ociClient = new(ociConfig);

public function main() {

    var userResponse = ociClient->getUser(<User OCID>);
    if (userResponse is iam:OciUser) {
        io:println("User display name: ", userResponse.name);
    } else {
        io:println("Error: ", userResponse);
    }
    
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
Create or update `ballerina.conf` file in `ballerina-oci` with following configurations and provide appropriate value. Below is an example.

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