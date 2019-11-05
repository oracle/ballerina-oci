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
import ballerina/time;
import ballerina/crypto;
import ballerina/log;
import ballerina/lang.'array as arrays;

public function generateSignature (http:Request request, string httpMethod, string tenancyId, string authUserId,
    string keyFingerprint, string pathToKey, string keyStorePassword, string keyAlias, string keyPassword, 
    json jsonBody, string host, string reqTarget) returns error? {
 
    time:Time|error time = time:toTimeZone(time:currentTime(), GMT);
    string timeFormat = "";
    if(time is time:Time){
        string|error timeFormatUncleaned = time:format(time, TIME_FORMAT);
        if(timeFormatUncleaned is string){
            timeFormat = timeFormatUncleaned;
        }
    }
    string date = timeFormat + " " + GMT;
    request.setHeader(DATE, date);
    request.setHeader(HOST, host);
    request.setHeader(REQUEST_TARGET, reqTarget);
 
    // Create API Key ID
    string apiKeyId = tenancyId + "/" + authUserId + "/" + keyFingerprint;
 
    // Create Signing String
    string signingString = DATE + ": " + date + "\n";
    signingString = signingString + "(" + REQUEST_TARGET + "): " + reqTarget + "\n";
    signingString = signingString + HOST + ": " + host ;
 
    string httpMethodLower = httpMethod.toLowerAscii();
    io:println(jsonBody);
    if (httpMethodLower == PUT || httpMethodLower == POST) {
        string body = jsonBody.toJsonString();       
        if (body != "") {
            request.setPayload(jsonBody);
        }
        // byte[] bodyArr = body.toByteArray(UTF_8);
        byte[] bodyArr = body.toBytes();    
        int contentLength = body.length();

        byte[] contentSha256Byte = crypto:hashSha256(bodyArr);
        string contentSha256 = arrays:toBase64(contentSha256Byte);
  
        request.setHeader(CONTENT_LENGTH, contentLength.toString());
        request.setHeader(CONTENT_TYPE, APPLICATION_JSON);
        request.setHeader(X_CONTENT_SHA256, contentSha256);
        request.setPayload(jsonBody);
        signingString = signingString + "\n";
        signingString = signingString + CONTENT_LENGTH + ": " + contentLength.toString() + "\n";
        signingString = signingString + CONTENT_TYPE + ": " + APPLICATION_JSON + "\n";
        signingString = signingString + X_CONTENT_SHA256 + ": " + contentSha256;
    }

    // Get Private Key
    crypto:KeyStore keyStore = {path: pathToKey, password: keyStorePassword};
    var privateKey = crypto:decodePrivateKey(keyStore, keyAlias, keyPassword);
    if (privateKey is crypto:PrivateKey) {
        // Encrypt signing string
        byte[] signingArray = signingString.toBytes();
        byte[] signatureArray = check crypto:signRsaSha256(signingArray, privateKey);
        string signature = arrays:toBase64(signatureArray);
 
        // Create Authorization Header
        string authHeader;
        authHeader = SIGNATURE_VERSION;
        authHeader = authHeader + "," + HEADERS + "=" + "\"" + DATE + " (" + REQUEST_TARGET +  ") " + HOST;
        if (httpMethodLower == PUT || httpMethodLower == POST) {
            authHeader = authHeader + " " + CONTENT_LENGTH + " " + CONTENT_TYPE + " " + X_CONTENT_SHA256;

        }
        authHeader = authHeader + "\"";
        authHeader = authHeader + "," + KEY_ID + "=" + "\"" + apiKeyId + "\"";
        authHeader = authHeader + "," + ALGORITHM + "=" + "\"" + RSA_SHA256 + "\"";
        authHeader = authHeader + "," + SIGNATURE + "=" + "\"" + signature + "\"";
        request.setHeader(AUTHORIZATION, authHeader);
    }
}

public function generateSignatureReadableByteChannel (http:Request request, string httpMethod, string tenancyId, 
    string authUserId, string keyFingerprint, string pathToKey, string keyStorePassword, string keyAlias, string keyPassword, 
    io:ReadableByteChannel jsonBody, int pContentLength, string host, string reqTarget) returns error? {
 
    time:Time|error time = time:toTimeZone(time:currentTime(), GMT);
    string timeFormat = "";
    if(time is time:Time){
        string|error timeFormatUncleaned = time:format(time, TIME_FORMAT);
        if(timeFormatUncleaned is string){
            timeFormat = timeFormatUncleaned;
        }
    }
    string date = timeFormat + " " + GMT;
    request.setHeader(DATE, date);
    request.setHeader(HOST, host);
    request.setHeader(REQUEST_TARGET, reqTarget);
 
    // Create API Key ID
    string apiKeyId = tenancyId + "/" + authUserId + "/" + keyFingerprint;
 
    // Create Signing String
    string signingString = DATE + ": " + date + "\n";
    signingString = signingString + "(" + REQUEST_TARGET + "): " + reqTarget + "\n";
    signingString = signingString + HOST + ": " + host ;
 
    string httpMethodLower = httpMethod.toLowerAscii();
 
    if (httpMethodLower == PUT || httpMethodLower == POST) {
      
        byte[]|error? body = copyToByte(jsonBody, pContentLength);
        int contentLength = pContentLength;
      
        if(body is  byte[]) {
            contentLength = body.length();
            byte[] contentSha256Byte = crypto:hashSha256(body);
            io:println(contentLength);
            string contentSha256 = arrays:toBase64(contentSha256Byte);
        
            io:println("contentSha256\n" + contentSha256 + "\ncontentSha256");
            request.setHeader(CONTENT_LENGTH, contentLength.toString());
            request.setHeader(CONTENT_TYPE, APPLICATION_OCTET_STREAM);
            request.setHeader(X_CONTENT_SHA256, contentSha256);
            signingString = signingString + "\n";
            signingString = signingString + CONTENT_LENGTH + ": " + contentLength.toString() + "\n";
            signingString = signingString + CONTENT_TYPE + ": " + APPLICATION_OCTET_STREAM + "\n";
            signingString = signingString + X_CONTENT_SHA256 + ": " + contentSha256;
         }
    }
 
        // Get Private Key
    crypto:KeyStore keyStore = {path: pathToKey, password: keyStorePassword};
    var privateKey = crypto:decodePrivateKey(keyStore, keyAlias, keyPassword);
    if (privateKey is crypto:PrivateKey) {
        // Encrypt signing string
    
        byte[] signingArray = signingString.toBytes();
        byte[] signatureArray = check crypto:signRsaSha256(signingArray, privateKey);
        string signature = arrays:toBase64(signatureArray);
 
        // Create Authorization Header
        string authHeader;
        authHeader = SIGNATURE_VERSION;
        authHeader = authHeader + "," + HEADERS + "=" + "\"" + DATE + " (" + REQUEST_TARGET +  ") " + HOST;
        if (httpMethodLower == PUT || httpMethodLower == POST) {
            authHeader = authHeader + " " + CONTENT_LENGTH + " " + CONTENT_TYPE + " " + X_CONTENT_SHA256;
        }
        authHeader = authHeader + "\"";
        authHeader = authHeader + "," + KEY_ID + "=" + "\"" + apiKeyId + "\"";
        authHeader = authHeader + "," + ALGORITHM + "=" + "\"" + RSA_SHA256 + "\"";
        authHeader = authHeader + "," + SIGNATURE + "=" + "\"" + signature + "\"";
        request.setHeader(AUTHORIZATION, authHeader);
    }
}
 
function getFileSize(io:ReadableByteChannel src) returns int|error? {  
    int readCount = 1;
    int contentLength = 0;
    while (true) {
        byte[]|io:Error  result =  src.read(1000);
        if (result is io:EofError) {
            break;
        } else if (result is error) {
            return <@untained> result;
        } else {
            contentLength = contentLength +result.length();
        }
    }
    io:println("contentLength:" + contentLength.toString());
    return <@untained> contentLength;
}

function copyToByte(io:ReadableByteChannel src,  int pContentLength) returns  byte[]|error? {   
    int readCount = 1;
    int contentLength = 0;
    byte[] ret=[];
    while (true) {    
        byte[]|io:Error result =  src.read(pContentLength + 1024);
        if (result is io:EofError) {
            break;
        } else if (result is error) {
            return <@untainted> result;
        } else {
            ret = merge(result,ret);
        }
        contentLength = contentLength + readCount;     
    }
    return <@untainted>ret;
}


function setError(http:Response res, error err) {
    res.statusCode = 500;
    res.setPayload(<@untainted> <string> err.detail()?.message);
}


function copy(io:ReadableByteChannel src, io:WritableByteChannel dst) returns error? {
    int readCount = 1;
    byte[] mergedContent= [];
    while (true) {
        byte[]|io:Error result =  src.read(100000);
        if (result is io:EofError) {
            break;
        } else if (result is error) {
            return <@untained> result;
        } else {
            mergedContent = merge(result,mergedContent);
        }
    }
    io:println("After Break");
    int i = 0;
    while (i < mergedContent.length()) {
                var writeResult = dst.write(mergedContent, i);
                if (writeResult is error) {
                    return writeResult;
                } else {
                    i = i + writeResult;
                }
              //  io:println("writeFile");
    }
    return;
}


function merge(byte[] src, byte[] dest) returns byte[] {
      foreach int i in 0 ..< src.length() {
            dest[dest.length()] = src[i];
      }
   return <@untained> dest;
}


function close(io:ReadableByteChannel|io:WritableByteChannel ch) {
    abstract object {
        public function close() returns error?;
    } channelResult = ch;
    var cr = channelResult.close();
    if (cr is error) {
        log:printError("Error occured while closing the channel: ", err = cr);
    }
}
