# Contributing to the Ballerina OCI Connector

*Copyright © 2019 Oracle and/or its affiliates. All rights reserved.*

Pull requests can be made under
[The Oracle Contributor Agreement](https://www.oracle.com/technetwork/community/oca-486395.html)
(OCA).

For pull requests to be accepted, the bottom of your commit message must have the following line using your name and
e-mail address as it appears in the OCA Signatories list.

```
Signed-off-by: Your Name <you@example.org>
```

This can be automatically added to pull requests by committing with:

```
git commit --signoff
````

Only pull requests from committers that can be verified as having
signed the OCA can be accepted.


The requirements are to be test driven. Follow the Gherkin format to define a test flow before writing any production code. This will improve readability and set expectations of what code will do.

# Endpoints

Given: OCID and settings variable(s)
When:  API call method
Then:  Code response and returned variable.

# Tests 

Use same format and include an assert statement.

Given:  Test variable(s) defined in method or globally
When:   Endpoint method being test
Then:   Returned variable or response
Assert: Compare resulting variable with test variable or response with test response

Use test config identifier: <API_MODULE>-<API_CALL>

Example:
@test:Config{
    groups: ["instances-list"]
}

# Contributing

1] ballerina.conf   - user will specify which OCI resource will be used for HOST
2] constants.bal    - create a final string that references OCI resource's from API website
3] test.bal         - follow test format above to test all base HTTP REST calls 
4] types.bal        - create record type. Can grab values from OCI API Resource Reference page from API Website
5] utils.bal        - write a createOci<RESOURCE> method for non-null Oci object
6] datamappings.bal - follow method formats to create empty oci resource object, use convert() function from json to Oci resource object
7] endpoint.bal     - create oci client method and utilize utils HTTP API call methods for ociGet/Put/Post/DELETE requests
8] Add copyright to top of every file. Example below. Add year as comma separated values.    

```
//
// Copyright © 2019 Oracle and/or its affiliates. All rights reserved.
//
// This file is under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//
```

