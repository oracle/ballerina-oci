# Ballerina Oracle OCI Connector

The Oracle OCI connector allows you to access the Oracle OCI REST APIs through ballerina. This project is open source and maintained by Oracle Corp.


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
    <tr>
		<td>Oracle Identity and Access Management Service API</td>
		<td>20160918</td>
	</tr>
    <tr>
		<td>Oracle Object Storage Service API</td>
		<td>20160918</td>
	</tr>
</tbody>
</table>

```
|-------------------------------|----------------|
|                               |    Version     |
|-------------------------------|----------------|
| Ballerina Language            |     1.0.1      |
|-------------------------------|----------------|
| Oracle Core Services API      |   20160918     |
|-------------------------------|----------------|
| Oracle Identity and Access    |                | 
| Management Service API        |   20160918     |
|-------------------------------|----------------|
| Oracle Object Storage Service |                |
| API                           |   20160918     |
|-------------------------------|----------------|
```



## Prerequisites

- Install Ballerina version as mentioned above - https://ballerina.io/downloads
- Oracle Cloud account - https://myservices.us.oraclecloud.com/mycloud/signup?sourceType=_ref_coc-asset-opcSignIn&language=en


## Module Version Dependency

Core, IAM, Objectstorage modules have not been pushed to the Ballerina Central as of now. Thus, in order to use these in your project, add the below dependency in your Ballerina.toml file.

```
[dependencies]
"oracle/core" = { path = "https://github.com/oracle/ballerina-oci/target/core-2019r3-any-0.1.0.balo", version = "0.1.0"}
"oracle/iam" = { path = "https://github.com/oracle/ballerina-oci/target/iam-2019r3-any-0.1.0.balo", version = "0.1.0"}
"oracle/core" = { path = "https://github.com/oracle/ballerina-oci/target/objectstorage-2019r3-any-0.1.0.balo", version = "0.1.0"}
```


### Install from Source
Alternatively, you can install Oracle OCI connectors from the source using the following instructions.

**Building the source**
1. Clone this repository using the following command:

    ```shell
    $ git clone https://github.com/oracle/ballerina-oci.git
    ```

2. Run below commands from the `ballerina-oci` root directory:

    ```shell
    $ ballerina build -c --skip-tests --all
    $ ballerina compile --skip-tests
    ```


## Running Tests

1. Create or update `ballerina.conf` file in `ballerina-oci` with following configurations and provide appropriate value. Below is an example.

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

    You will also have to change the variables in each of the test.bal in each module.

2. Navigate to the `ballerina-oci` directory.

3. Run tests :

    ```ballerina
    ballerina init
    ballerina test core
    ballerina test iam
    ballerina test objectstorage
    ```

## The following sections provide you with information on how to use the Ballerina Oracle OCI connector.

- [Working with Oracle OCI Connector](#Working-with-Oracle-OCI-Connector)
- [Sample](#sample)

### Working with Oracle OCI Connector

1] Create PEM key with password
openssl genrsa -out ~/.oci/oci_api_key.pem -aes128 2048


2] Add the public key to your account and get the key fingerprint which will be required in configuration. Refer - https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#three


3] Convert PEM to PKCS12 format
openssl pkcs12 -export -nocerts -inkey ~/.oci/<KEY_NAME>.pem -in ~/.oci/<KEY_NAME>.pem -out ~/.oci/<KEY_NAME_P12>.p12 -name "<KEY_ALIAS>"

This converts the PEM to PKSC12 with the alias/name. It will prompt for the PEM password. It will prompt for a keystore password.


4] After adding the dependency as mentioned above in the Ballerina.toml file, import the `oracle/core` module into the Ballerina project.

```ballerina
import oracle/core;
```

In order for you to use the Oracle OCI Connector, first you need to create a Oracle OCI Client endpoint.

```ballerina
oci:OciConfiguration ociConfig = {
    host: "",
    tenancyId: "",
    authUserId: "",
    keyFingerprint: "",
    pathToKey: "",
    keyStorePassword: "",
    keyAlias: "",
    keyPassword: ""
};
   
oci:Client ociClient = new(ociConfig);
```

##### Sample

```ballerina
import ballerina/io;
import oracle/core;

oci:OciConfiguration ociConfig = {
    host: "",
    tenancyId: "",
    authUserId: "",
    keyFingerprint: "",
    pathToKey: "",
    keyStorePassword: "",
    keyAlias: "",
    keyPassword: ""
};
   
oci:Client ociClient = new(ociConfig);

public function main() {

    var instanceResponse = ociClient->getInstance(<instance OCID>);
    if (instance is OciInstance) {
        io:println("Instance display name: ", instanceResponse.displayName);
    } else {
        io:println("Error: ", instanceResponse);
    }
    
}
```

Similarly, you can use the `oracle/iam` and `oracle/objectstorage` module.


## Help
* The [Issues](https://github.com/oracle/ballerina-oci/issues) page of this GitHub repository.
* [Stack Overflow](https://stackoverflow.com/), use the [oracle-cloud-infrastructure](https://stackoverflow.com/questions/tagged/oracle-cloud-infrastructure) and [ballerina-oci](https://stackoverflow.com/questions/tagged/ballerina-oci) tags in your post.
* [Developer Tools](https://community.oracle.com/community/cloud_computing/bare-metal/content?filterID=contentstatus%5Bpublished%5D~category%5Bdeveloper-tools%5D&filterID=contentstatus%5Bpublished%5D~objecttype~objecttype%5Bthread%5D) of the Oracle Cloud forums.
* [My Oracle Support](https://support.oracle.com).


## Contributing
`ballerina-oci` is an open source project. See [CONTRIBUTING](/CONTRIBUTING.md) for details. We welcome contributions from the community. Check the [issue tracker](https://github.com/oracle/ballerina-oci/issues) for open issues that interest you. We look forward to receiving your contributions.

Oracle gratefully acknowledges the contributions to ballerina-oci that have been made by the community.


## License
Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.

This Connector and sample is licensed under Apache License 2.0.

See [LICENSE](/LICENSE.txt) for more details.


## Changes
See [CHANGELOG](/CHANGELOG.md).


## Known Issues
You can find information on any known issues with the module here and under the [Issues](https://github.com/oracle/ballerina-oci/issues) tab of this project's GitHub repository.
