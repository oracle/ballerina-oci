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

import ballerina/config;
import ballerina/test;
import ballerina/io;
import ballerina/http;
 
//get configuration information from ballerina.conf
string host = config:getAsString("HOST");
string tenancyId = config:getAsString("TENANCY_ID"); 
string authUserId= config:getAsString("AUTHUSER_ID"); 
string keyFingerprint = config:getAsString("KEYFINGERPRINT"); 
string pathToKey = config:getAsString("PATHTOKEY"); 
string keyStorePassword = config:getAsString("KEYSTOREPASSWORD"); 
string keyAlias = config:getAsString("KEYALIAS"); 
string keyPassword = config:getAsString("KEYPASSWORD"); 
json chunking = "{ chunking: http:CHUNKING_NEVER}";

// oci client endpoint
OciConfiguration ociConfig = {
    host: host,
    tenancyId: tenancyId,
    authUserId: authUserId,
    keyFingerprint: keyFingerprint,
    pathToKey: pathToKey,
    keyStorePassword: keyStorePassword,
    keyAlias: keyAlias,
    keyPassword: keyPassword
};
 
Client ociClient = new(ociConfig);

http:ClientHttp1Settings chunk = {
    chunking: "NEVER"
};  

# Terminal command to test:
# ballerina test --config ballerina.conf --groups compartments-<GROUPS>
# Example: ballerina test --config ballerina.conf --groups bucket-list

// Bucket and Object test variables
string compartmentId = "";
string tenancy = "";
string bucketName = "";
string path = "";
string objectName = "";
string fileName = "";
string createdBy = "";


// Buckets tests

# Given: compartmentId and tenancy
# When: listBucket
# Then: list all buckets
 @test:Config {
    groups: ["bucket-list"]
 }
 function testlistBuckets() {
    io:println("ociClient -> listBuckets()");
    ociClient->listObjectStorageBuckets(compartmentId, tenancy);
}

# Given: compartmentId, tenancy, bucket requirements in jsonBody
# When: createBucket
# Then: Create bucket
@test:Config {
    groups: ["bucket-create"]
 }
function testcreateBucket() {

    io:println("ociClient -> createBucket()");
     json jsonBody = {
        "compartmentId" : compartmentId,
        "name": bucketName,
        "freeformTags": {"Createdby": createdBy}
    };
    ociClient->createObjectStorageBucket(compartmentId, tenancy, jsonBody);
}

# Given: compartmentId, tenancy, bucket name
# When: getBucket
# Then: list the bucket
@test:Config {
    groups: ["bucket-get"]
 }
function testgetBucket() {
    io:println("ociClient -> getBucket()");
    ociClient->getObjectStorageBucket(compartmentId, tenancy, bucketName);
}
 
# Given: compartmentId, tenancy, bucket name
# When: deleteBucket
# Then: delete the bucket
@test:Config {
    groups: ["bucket-delete"]
 }
function testdeleteBucket() {
    io:println("ociClient -> deleteBucket()");
    ociClient->deleteObjectStorageBucket(compartmentId, tenancy, bucketName);
}


// Objects tests

# Given: tenancy, bucket name
# When: listObjects
# Then: list objects within the bucket in the tenancy
@test:Config {
    groups: ["object-list"]
 }
function testlistObjects() {
    io:println("ociClient -> List object storage objects");
    ociClient->listObjectStorageObjects(tenancy, ""); 
}


# Given: tenancy, bucketName, objectName
# When: deleteObject
# Then: Delete the object from the bucket in the tenancy
@test:Config {
    groups: ["object-delete"]
 }
function  testdeleteObject() {
    io:println("ociClient -> delete objectStorage object");
    ociClient->deleteObjectStorageObject(tenancy, bucketName, objectName);
}

# Given: tenancy, bucketName, objectName, path
# When: createObject
# Then: Take the object from the path and create object in the bucket using the objectName
@test:Config {
    groups: ["object-create"]
 }
function testcreateObject() {
    io:println("ociClient -> createObject");     
    var objectStorageObject = ociClient->createObjectStorageObject(tenancy, "", objectName, path);
     io:println(objectStorageObject.toString());
}

# Given: tenancy, bucketName, objectName, fileName
# When: getObject
# Then: Get object details
@test:Config {
    groups: ["object-get"]
 }
function  testgetObject() {
    io:println("ociClient -> getObject");
    error? objectStorageObject = ociClient->getObjectStorageObject(tenancy, bucketName, objectName, "" + objectName);
}