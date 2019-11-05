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

import ballerina/http;

# Define the configurations for the OCI connector
# Need to turn off chunking for Object storage put requests
# + host - The OCI home region url
# + tenancyId - The tenancy OCID
# + authUserId - The user OCID
# + keyFingerprint - The user fingerprint
# + pathToKey - The full path to the private key
# + keyStorePassword - The keystore password
# + keyAlias - The name of the key
# + keyPassword - The key password
# + http1Settings - The HTTP settings
# + clientConfig - HTTP client endpoint config
public type OciConfiguration record {
    string host = "";
    string tenancyId = "";
    string authUserId = "";
    string keyFingerprint = "";
    string pathToKey = "";
    string keyStorePassword = "";
    string keyAlias = "";
    string keyPassword = "";
    string http1Settings = "{ chunking: http:CHUNKING_NEVER }";
    http:ClientConfiguration clientConfig = {};
};


# Bucket
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Bucket/
# + namespace - https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Bucket/
# + name - The name of the bucket
# + compartmentId - The compartment ID in which the bucket is authorized
# + createdBy - The OCID of the user who created the bucket
# + timeCreated - The date and time the bucket was created, as described in RFC 2616, section 14.29
# + etag - The entity tag (ETag) for the bucket
public type OciOSBucket record {
    string namespace = "";
    string name = "";
    string compartmentId = "";
    string createdBy = "";
    string timeCreated = "";
    string etag = "";
};
