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

import ballerina/encoding;
import ballerina/http;
import ballerina/io;
import ballerina/time;
// import ballerina/system;
import ballerina/crypto;
// import ballerina/file;
import ballerina/log;
// import ballerina/mime;

//testing out base 8
import ballerina/lang.'array as arrays;

# Given
# + ociConfig - Client OciConfiguration
# + ociClient - Client http:Client
# + ociResource - OCI resource type (e.g. INSTANCES/VCNS/etc.)
# + id - OCID 
# + queries - filters
# + return - json
# When:  GET
# Then:  Get resource
public function ociGetRequest(OciConfiguration ociConfig, http:Client ociClient, 
                                    string ociResource, string id, map<string> queries) returns json {
    http:Request request = new;
    string canonicalQueryString = "/" + API_VERSION + "/" + ociResource + "/";

    if(id == "") {
        canonicalQueryString += buildQueryString(queries);
    }else{
        canonicalQueryString += id;
    }
    //string canonicalQueryString = "/" + API_VERSION + "/" + ociResource + "/" + id;
    string reqTarget = GET + " " + canonicalQueryString;
    var signature = generateSignature(request, GET, ociConfig.tenancyId, ociConfig.authUserId,
    ociConfig.keyFingerprint, ociConfig.pathToKey, ociConfig.keyStorePassword,
    ociConfig.keyAlias, ociConfig.keyPassword, "", ociConfig.host, reqTarget);
    http:Response|error response = ociClient->get(canonicalQueryString, message = request);
    //io:println(response);
    return getCleanedJSON(ociResource, GET, response);
}

# Given
# + ociConfig - Client OciConfiguration
# + ociClient - Client http:Client
# + ociResource - OCI resource type (e.g. INSTANCES/VCNS/etc.)
# + id - OCID 
# When:  DELETE
# Then:  Delete resource 
public function ociDeleteRequest(OciConfiguration ociConfig, http:Client ociClient, 
                                    string ociResource, string id) {  
    http:Request request = new;
    string canonicalQueryString = "/" + API_VERSION + "/" + ociResource + "/" + getEncodedString(id);
    string reqTarget = DELETE + " " + canonicalQueryString;
    var signature = generateSignature(request, DELETE, ociConfig.tenancyId, ociConfig.authUserId,
        ociConfig.keyFingerprint, ociConfig.pathToKey, ociConfig.keyStorePassword,
        ociConfig.keyAlias, ociConfig.keyPassword, "", ociConfig.host, reqTarget);
    var response = ociClient->delete(canonicalQueryString, request);
    // return getCleanedJSON(ociResource, DELETE, response);
}

# Given
# + ociConfig - Client OciConfiguration
# + ociClient - Client http:Client
# + ociResource - OCI resource type (e.g. INSTANCES/VCNS/etc.)
# + id - OCID 
# + action - resource action (e.g. RUNNING/STOPPED/etc.)
# + jsonBody - json information for launching reosurce
# + return - json
# When:  POST action/launch
# Then:  Return json response 
# Possible bug - jsonBody gets "" as body
public function ociPostRequest(OciConfiguration ociConfig, http:Client ociClient, 
                    string ociResource, string id, string action, json jsonBody) returns json {
    http:Request request = new;
    string canonicalQueryString = "/" + API_VERSION + "/" + ociResource + "/";

    if (action != "") {
        canonicalQueryString += id + "?action=" + action;
        var signature = generateSignature(request, POST, ociConfig.tenancyId, ociConfig.authUserId,
        ociConfig.keyFingerprint, ociConfig.pathToKey, ociConfig.keyStorePassword,
        ociConfig.keyAlias, ociConfig.keyPassword, "", ociConfig.host, POST + " " + canonicalQueryString);
    } else {
        var signature = generateSignature(request, POST, ociConfig.tenancyId, ociConfig.authUserId,
        ociConfig.keyFingerprint, ociConfig.pathToKey, ociConfig.keyStorePassword,
        ociConfig.keyAlias, ociConfig.keyPassword, jsonBody, ociConfig.host, POST + " " + canonicalQueryString);
    }
    http:Response|error response = ociClient->post(canonicalQueryString, request);
    return getCleanedJSON(ociResource, POST, response);
}

# Given
# + ociConfig - Client OciConfiguration
# + ociClient - Client http:Client
# + ociResource - OCI resource type (e.g. INSTANCES/VCNS/etc.)
# + id - OCID 
# + jsonBody - json information for launching reosurce
# + return - json
# When:  PUT update
# Then:  Return json response 
# Possible bug - jsonBody gets "" as body
public function ociPutRequest(OciConfiguration ociConfig, http:Client ociClient, 
                                    string ociResource, string id, json jsonBody) returns json {
    http:Request request = new;
    string canonicalQueryString = "/" + API_VERSION + "/" + ociResource + "/" + getEncodedString(id);
    string reqTarget = PUT + " " + canonicalQueryString;
    var signature = generateSignature(request, PUT, ociConfig.tenancyId, ociConfig.authUserId,
        ociConfig.keyFingerprint, ociConfig.pathToKey, ociConfig.keyStorePassword,
        ociConfig.keyAlias, ociConfig.keyPassword, jsonBody, ociConfig.host, reqTarget);


    // io:println(canonicalQueryString);

    var response = ociClient->put(canonicalQueryString, request);
    return getCleanedJSON(ociResource, PUT, response);
}

# Given
# + id - id to be encoded
# + return - endcoded value
# When: PUT request
# Then: Return encoded id or throw error
public function getEncodedString(string id) returns string {
    //var value = http:encode(id, UTF_8);
    // var value = encoding:encodeUriComponent(id, UTF_8);
    var value = encoding:encodeUriComponent(id,UTF_8);
    if (value is string) {
        return value;
    } else {
        error err = error("100", message = "Error occurred while encoding");
        panic err;
    }
}

# Given: 
# + ociResource - OCI resource (e.g. INSTANCES/VCNS/etc.)
# + request - HTTP call
# + response - http:Response|error
# + return - cleaned json
# When: OCI HTTP request call from utils.bal
# Then: Clean and return json
# Else: Print error message
public function getCleanedJSON(string ociResource, string request, http:Response|error response) returns json {
    if (response is http:Response) {
        json|error msg = response.getJsonPayload();
        if (msg is json) {
            if(isMsgError(msg)) {
                printJsonError(ociResource, request, msg);
            }            
            // io:println(msg);
            return <@untainted> msg;
        } else {
            log:printError("Invalid payload received", err = msg);
        }
    } else {
        log:printError("Error when calling " + ociResource + " " + request, err = response);
    }
}

# Given
# + msg - JSON 
# + return - error msg
# When: Http response gives an error
# Then: Check if 'code' key exists in json
public function isMsgError(json msg) returns boolean {
    return (msg?.code != null);
}

# Given:
# + ociResource - OCI resource (e.g. INSTANCES/VCNS/etc.)
# + request - HTTP call
# + msg - JSON error
# When: getCleanedJSON() has error when retrieving json payload from http response
# Then: print error message code and message
public function printJsonError(string ociResource, string request, json msg) {
    // io:println(msg["code"]);
    // io:println(msg["message"]);
    io:println(msg?.code);
    io:println(msg?.message);
}

# Given
# + queries - map of string variables required to form the query 
# + return - the built query string
public function buildQueryString(map<string> queries) returns string {
    string queryString = "";
    foreach var [queryType, value] in queries.entries() {
        queryString = queryString + (queryString == "" ? "?" : "&") + queryType + "=" + encodeString(value);
    }
    return queryString;
}

# Given:
# + value - string to be encoded
# + return - encoded string
# When: string cannot be encoded, it throws error
# Then: print error message code and message
public function encodeString(string value) returns string {
    // var encodedValue = http:encode(value, UTF-8);
    var encodedValue = encoding:encodeUriComponent(value, UTF_8);
    string encodedString;
    if (encodedValue is string) {
        encodedString = encodedValue;
    } else {
        error err = error("100", message = "Error occurred while encoding");
        panic err;
    }
    return encodedString;
}

public function generateSignature(http:Request request, string httpMethod, string tenancyId, string authUserId,
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
    if (httpMethodLower == PUT || httpMethodLower == POST) {
        // string body = jsonBody.toString();     

        string body = jsonBody.toJsonString();

        if (body != "") {
            request.setPayload(jsonBody);
        }
        // byte[] bodyArr = body.toByteArray(UTF_8);
        byte[] bodyArr = body.toBytes();    
        int contentLength = body.length();
        byte[] contentSha256Byte = crypto:hashSha256(bodyArr);
        // string contentSha256 = encoding:encodeBase64(contentSha256Byte);

        string contentSha256 = arrays:toBase64(contentSha256Byte);

        request.setHeader(CONTENT_LENGTH, contentLength.toString());
        request.setHeader(CONTENT_TYPE, APPLICATION_JSON);
        request.setHeader(X_CONTENT_SHA256, contentSha256);
        signingString = signingString + "\n" +
                        CONTENT_LENGTH + ": " + contentLength.toString() + "\n" + 
                        CONTENT_TYPE + ": " + APPLICATION_JSON + "\n" + 
                        X_CONTENT_SHA256 + ": " + contentSha256;

        // io:println("Signing String");
        // io:println(signingString);
        // io:println();
    }
 
    // Get Private Key
    crypto:KeyStore keyStore = {path: pathToKey, password: keyStorePassword};
    var privateKey = crypto:decodePrivateKey(keyStore, keyAlias, keyPassword);
    if (privateKey is crypto:PrivateKey) {
        // Encrypt signing string
        // byte[] signingArray = signingString.toByteArray(UTF_8);

        byte[] signingArray = signingString.toBytes();

        byte[] signatureArray = check crypto:signRsaSha256(signingArray, privateKey);
        // string signature = encoding:encodeBase64(signatureArray);
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

# createOciInstance
# + return - OciInstance
public function createOciInstance() returns OciInstance {
    OciInstance instance = {
        availabilityDomain : "",
        compartmentId : "",
        displayName : "",
        faultDomain : "",
        id : "",
        imageId : "",
        launchMode : "",
        lifecycleState : "",
        region : "",
        shape : "",
        timeCreated : ""
    };
    return instance;
}

# createOciVcn
# + return - OciVcn
public function createOciVcn() returns OciVcn {
    OciVcn vcn = {
        cidrBlock : "",
        compartmentId : "",
        defaultDhcpOptionsId : "",
        defaultRouteTableId : "",
        defaultSecurityListId : "",
        displayName : "",
        dnsLabel : "",
        id : "",
        lifecycleState : "",
        timeCreated : "",
        vcnDomainName : ""
    };
    return vcn;
}

# createOciRouteTable
# + return - OciRouteTable
public function createOciRouteTable() returns OciRouteTable{
    OciRouteRule routeRule = {
        cidrBlock: "",
        destination: "",
        destinationType: "",
        networkEntityId: ""
    };
    OciRouteTable routeTable = {
        compartmentId: "",
        displayName: "",
        id: "",
        lifecycleState: "",
        routeRules: [routeRule],
        timeCreated: "",
        vcnId: ""
    };
    return routeTable;
}

# createOciServiceGateway
# + return - OciServiceGateway
public function createOciServiceGateway() returns OciServiceGateway {
    OciServiceGateway sGateway = {
        blockTraffic: false,
        compartmentId: "",
        displayName: "",
        id: "",
        lifecycleState: "",
        services: [],
        vcnId: ""
    };
    return sGateway;
}

# createOciInternetGateway
# + return - OciInternetGateway
public function createOciInternetGateway() returns OciInternetGateway {
    OciInternetGateway igw = {
        id : "",
        compartmentId : "",
        vcnId : "",
        displayName : "",
        lifecycleState : "",
        timeCreated : "",
        //inactiveStatus : "",
        //capabilities : "",
        isEnabled : true,
        definedTags : "",
        freeformTags : ""
    };
    return igw;
}

# createOciNatGateway
# + return - OciNatGateway
public function createOciNatGateway() returns OciNatGateway {
    OciNatGateway ngw = {
        id : "",
        compartmentId : "",
        vcnId : "",
        displayName : "",
        lifecycleState : "",
        timeCreated : "",
        //inactiveStatus : "",
        //capabilities : "",
        definedTags : "",
        freeformTags : "",
        blockTraffic : false,
        natIp : ""
    };
    return ngw;
}

# createOciSecurityList
# + return - OciSecurityList
public function createOciSecurityList() returns OciSecurityList {

    OciPortRange portRange = {
        max: 0,
        min: 0
    };

    OciUdpOptions udpOptions = {
        destinationPortRange: portRange,
        sourcePortRange: portRange
    };

    OciTcpOptions tcpOptions = {
        destinationPortRange: portRange,
        sourcePortRange: portRange
    };

    OCiIcmpOptions icmpOptions = {
        code: 0,
        icmpType: 0
    };

    OciDefinedTags definedTags = {

    };

    OciFreeFormTags freeformTags = {

    };

    // leave the below commented as we will use it in future versions
    OciEgressSecurityRule egressSecRule  = {
        destination: "",
        destinationType: "",
        //icmpOptions: icmpOptions,
        isStateless: false,
        protocol: ""
        //tcpOptions: tcpOptions,
        //udpOptions: udpOptions
    };

    // leave the below commented as we will use it in future versions
    OciIngressSecurityRule ingressSecRule  = {
        // icmpOptions: [icmpOptions],
        // isStateless: false,
        // protocol: "",
        // source: "",
        // sourceType: "",
        // tcpOptions: [tcpOptions],
        // udpOptions: [udpOptions]
    };

    OciSecurityList securityList = {
        compartmentId: "",
        definedTags: definedTags,
        displayName: "",
        egressSecurityRules: [egressSecRule],
        freeformTags: freeformTags,
        id: "",
        ingressSecurityRules: [ingressSecRule],
        lifecycleState: "",
        timeCreated: "",
        vcnId: ""
    };
    return securityList;
}

# createOciSubnet
# + return - OciSubnet
public function createOciSubnet() returns OciSubnet{
    OciSubnet subnet = {
        availabilityDomain: "",
        cidrBlock: "",
        compartmentId: "",
        dhcpOptionsId: "",
        displayName: "",
        dnsLabel: "",
        id: "",
        ipv6CidrBlock: "",
        ipv6PublicCidrBlock: "",
        ipv6VirtualRouterIp: "",
        lifecycleState: "",
        prohibitPublicIpOnVnic: false,
        routeTableId: "",
        securityListIds: [""],
        //subnetDomainName: "",
        timeCreated: "",
        vcnId: "",
        virtualRouterIp: "",
        virtualRouterMac: ""
    };
    return subnet;
}