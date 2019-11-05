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
import ballerina/io;
import ballerina/log;
import ballerina/encoding;
import ballerina/mime;

public type Client client object{

 
    OciConfiguration ociConfig = {
        host:"",
        tenancyId:"",
        authUserId:"",
        keyFingerprint:"",
        pathToKey:"",
        keyStorePassword:"",
        keyAlias:"",
        keyPassword:""
    };
 

    http:Client clientEndpoint;
 
    public function __init(OciConfiguration ociConfig)
    {
        io:println("Init client");
        self.ociConfig = ociConfig;
        string endpointUrl = "https://" + self.ociConfig.host;
      //  self.clientEndpoint = new(endpointUrl, config = ociConfig.clientConfig);
      //  self.clientEndpoint = new(endpointUrl, ociConfig.clientConfig);
        self.clientEndpoint = new(endpointUrl, { http1Settings : { chunking: http:CHUNKING_NEVER }});
        //io:println(self.clientEndpoint.config.get("chunking"));
        io:println(self.clientEndpoint.config.toString());
    }

// Todo: Multipart Upload

# Buckets

# Creates/updates/get/delete/list bucket in a specifed compartment and tenancy

# Given
# + compartmentId - compartmentId OCID
# + tenancy - tenancy OCID
# + jsonPayload - json
# Create object storage bucket
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Bucket/CreateBucket
public remote function createObjectStorageBucket(string compartmentId, string tenancy, json jsonPayload) {
    http:Request request = new;
    string httpMethod = POST;
    string reqTarget = httpMethod + " /n/" + tenancy + "/b/";
    var canonicalQueryString = "/n/" + tenancy  + "/b/";
 
    var signature = generateSignature(request, httpMethod, self.ociConfig.tenancyId,
                    self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                    self.ociConfig.keyAlias, self.ociConfig.keyPassword, jsonPayload, self.ociConfig.host, reqTarget);
    // io:println(canonicalQueryString);
    // io:println("request");
    // io:println(request.getTextPayload());
    // io:println("request");
    var response = self.clientEndpoint->post(canonicalQueryString, request);
    if (response is http:Response) {
        io:println("POST request:");
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println(msg);
        } else {
                    log:printError("Invalid payload received", err = msg);
        }
    } else {
  
        log:printError("Error when calling backend", err = response);

    }
}


# Given
# + compartmentId - compartmentId OCID
# + tenancy - tenancy OCID
# + bucketName - json
# Get object storage bucket
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Bucket/GetBucket
public remote function getObjectStorageBucket(string compartmentId, string tenancy, string bucketName) {
    http:Request request = new;
    string httpMethod = GET;
    string reqTarget = httpMethod + " /n/" + tenancy + "/b/" + bucketName;
    var canonicalQueryString = "/n/" + tenancy  + "/b/" + bucketName;

    var signature = generateSignature(request, httpMethod, self.ociConfig.tenancyId,
                    self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                    self.ociConfig.keyAlias, self.ociConfig.keyPassword, "", self.ociConfig.host, reqTarget);
    var response = self.clientEndpoint->get(canonicalQueryString, message=request);
    if (response is http:Response) {
       
        io:println("GET request:" + bucketName);
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println(msg);
        } else {
            log:printError("Invalid payload received", err = msg);
        }
    } else {
        log:printError("Error when calling the backend", err = response);
    }
}


# Given
# + compartmentId - compartmentId OCID
# + tenancy - tenancy OCID
# + bucketName - json
# Delete object storage bucket
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Bucket/DeleteBucket
public remote function deleteObjectStorageBucket(string compartmentId, string tenancy, string bucketName) {
    http:Request request = new;
    string httpMethod = DELETE;
    string reqTarget = httpMethod + " /n/" + tenancy + "/b/" + bucketName;
    var canonicalQueryString = "/n/" + tenancy  + "/b/" + bucketName;
 
    var signature = generateSignature(request, httpMethod, self.ociConfig.tenancyId,
                    self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                    self.ociConfig.keyAlias, self.ociConfig.keyPassword, "", self.ociConfig.host, reqTarget);
    io:println(canonicalQueryString);
    io:println(request);
    var response = self.clientEndpoint->delete(canonicalQueryString, request);
    if (response is http:Response) {
        io:println("DELETE request:" + bucketName);
       
    } else {
        log:printError("Error when calling the backend", err = response);
    }
}


# Given
# + compartmentId - compartmentId OCID
# + tenancy - tenancy OCID
# List object storage buckets
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Bucket/ListBuckets
public remote function listObjectStorageBuckets(string compartmentId, string tenancy) {
    http:Request request = new;
    string httpMethod = GET;
    string partReqTarget = httpMethod + " /n/" + tenancy + "/b/?compartmentId=";
    string encodedString = getEncodedString(compartmentId);
    var canonicalQueryString = "/n/" + tenancy + "/b/?compartmentId=" + encodedString;
    string reqTarget = partReqTarget + encodedString;
 
    var signature = generateSignature(request, httpMethod, self.ociConfig.tenancyId,
                    self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                    self.ociConfig.keyAlias, self.ociConfig.keyPassword, "", self.ociConfig.host, reqTarget);
    io:println(canonicalQueryString);
    io:println(request);
    var response = self.clientEndpoint->get(canonicalQueryString, message = request);
    if (response is http:Response) {
        io:println("List Buckets request:");
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println(msg);
        } else {
            log:printError("Invalid payload received", err = msg);
        }
    } else {
        log:printError("Error when calling the backend", err = response);
    }
}


# Objects

# Creates/updates/get/delete/list objects in a specifed tenancy and bucket

# Given
# + tenancy - tenancy OCID
# + bucketName - bucket name
# + objectName - object name
# + path - path
# + return - int or error
# Create object storage object
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Object/PutObject
public remote function createObjectStorageObject(string tenancy, string bucketName, string objectName, string path) returns int|error? {
    io:ReadableByteChannel getNumOfBytes; 
    getNumOfBytes = check io:openReadableFile(path + "/" + objectName);

    int|error? cl = getFileSize(getNumOfBytes);
    close(getNumOfBytes);

    io:ReadableByteChannel src; 
    src = check io:openReadableFile(path + "/" + objectName);
    http:Request request = new;
    string httpMethod = PUT;
    string reqTarget = httpMethod + " /n/" + tenancy + "/b/" + bucketName + "/o/" + objectName;
    var canonicalQueryString = "/n/" + tenancy  + "/b/" + bucketName + "/o/" + objectName;

    if(cl is int){
        int contentLength = cl;
        var signature = generateSignatureReadableByteChannel(request, httpMethod, self.ociConfig.tenancyId,
                            self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                            self.ociConfig.keyAlias, self.ociConfig.keyPassword, src, contentLength, self.ociConfig.host, reqTarget);
       // io:println(self.clientEndpoint.config.toString() );                    
       // io:println(request.getHeader("Content-Length"));   
        request.setFileAsPayload(path + "/" + objectName, contentType = mime:APPLICATION_OCTET_STREAM);               
        var response = self.clientEndpoint->put(canonicalQueryString, request);
        if (response is http:Response) {
            io:println(response);     
        } else {
            log:printError("Error when calling the backend", err = response);
        }
    }
    else{
         log:printError("Error when reading file: ", err = cl);
         return 0;
    }
     close(src);
     return 1;
}


# Given
# + tenancy - tenancy OCID
# + bucketName - bucket name
# + objectName - object name
# + fileName - file name
# + return - error
# Get object storage object
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Object/GetObject
public remote function getObjectStorageObject(string tenancy, string bucketName, string objectName, string fileName) returns error?{
    http:Request request = new;
    string httpMethod = GET;
    string reqTarget = httpMethod + " /n/" + tenancy + "/b/" + bucketName + "/o/" + objectName;
    var canonicalQueryString = "/n/" + tenancy  + "/b/" + bucketName + "/o/" + objectName;
    var signature = generateSignature(request, httpMethod, self.ociConfig.tenancyId,
                    self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                    self.ociConfig.keyAlias, self.ociConfig.keyPassword, "", self.ociConfig.host, reqTarget);
    var response = self.clientEndpoint->get(canonicalQueryString, message=request);
    if (response is http:Response) {     
        io:println("GET request:" + reqTarget);
        var payload = response.getByteChannel();
        if (payload is io:ReadableByteChannel) {
            io:WritableByteChannel destinationChannel = check io:openWritableFile(fileName);
            var result = copy(payload, destinationChannel);
            if (result is error) {
                    log:printError("error occurred while performing copy ",
                                    err = result);
                }       
            close(payload);
            close(destinationChannel);
            response.setPayload("File Received!");
        } else {
            setError(response, payload);
        }
        
    } else {
        log:printError("Error when calling the backend", err = response);
    }
}


# Given
# + tenancy - tenancy OCID
# + bucketName - bucket name
# + objectName - object name
# Delete object storage object
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Object/DeleteObject
public remote function deleteObjectStorageObject(string tenancy, string bucketName, string objectName) {
    http:Request request = new;
    string httpMethod = DELETE;
    string reqTarget = httpMethod + " /n/" + tenancy + "/b/" + bucketName + "/o/" + objectName;
    var canonicalQueryString = "/n/" + tenancy  + "/b/" + bucketName + "/o/" + objectName;
    var signature = generateSignature(request, httpMethod, self.ociConfig.tenancyId,
                    self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                    self.ociConfig.keyAlias, self.ociConfig.keyPassword, "", self.ociConfig.host, reqTarget);
    var response = self.clientEndpoint->delete(canonicalQueryString, request);
    if (response is http:Response) {
        io:println(response);     
    } else {
        log:printError("Error when calling the backend", err = response);
    }
}


# Given
# + tenancy - tenancy OCID
# + bucketName - bucket name
# List object storage objects
# https://docs.cloud.oracle.com/iaas/api/#/en/objectstorage/20160918/Object/ListObjects
public remote function listObjectStorageObjects(string tenancy, string bucketName) {
    http:Request request = new;
    string httpMethod = GET;
    string partReqTarget = httpMethod + " /n/" + tenancy + "/b/" + bucketName + "/o";
    var canonicalQueryString = "/n/" + tenancy + "/b/" +  bucketName + "/o";
    string reqTarget = partReqTarget;
    var signature = generateSignature(request, httpMethod, self.ociConfig.tenancyId,
                    self.ociConfig.authUserId, self.ociConfig.keyFingerprint, self.ociConfig.pathToKey, self.ociConfig.keyStorePassword,
                    self.ociConfig.keyAlias, self.ociConfig.keyPassword, "", self.ociConfig.host, reqTarget);
    io:println(canonicalQueryString);
    io:println(request);
    var response = self.clientEndpoint->get(canonicalQueryString, message = request);
    if (response is http:Response) {
        io:println("List Objects request:");
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println(msg);
        } else {
            log:printError("Invalid payload received", err = msg);
        }
    } else {
        log:printError("Error when calling the backend", err = response);
    }
}
};

# Given
# + id - id to be encoded
# + return - endcoded value
# When: PUT request
# Then: Return encoded id or throw error
 public function getEncodedString(string id) returns string {
    var value = encoding:encodeUriComponent(id, UTF_8);
    if (value is string) {
        return value;
    } else {
        error err = error("100", message = "Error occurred while encoding");
        panic err;
    }
} 