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

import ballerina/io;

# GetInstance
# + response - json return for instance API
# + return - oci instance or default empty instance if conversion failure
function getInstance(json response) returns OciInstance {
    OciInstance instance = createOciInstance();
    OciInstance|error ociInstance = OciInstance.constructFrom(response);
    if (ociInstance is OciInstance) {
        instance = ociInstance;
    }
    return instance;
}


# ListInstances
# + response - json OciInstance
# + return - return converted OCI instance array or empty array if conversion failure 
function getListInstances(json response) returns OciInstance[] {
    OciInstance[] list = [];
    int i = 0;
    int j = 0;
    json instance;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        instance = responseList[i];
        OciInstance|error ociInstance = OciInstance.constructFrom(instance);
        if (ociInstance is OciInstance) {
            list[j] = ociInstance;
            j = j + 1;
        }
        i = i + 1;
    }

    return list;
}


# GetVcn
# + response - json Vcn
# + return - OciVcn
function getVcn(json response) returns OciVcn {
    OciVcn vcn = createOciVcn();
    OciVcn|error ociVcn = OciVcn.constructFrom(response);
    if (ociVcn is OciVcn) {
        vcn = ociVcn;
    }
    return vcn;
}


# ListVcns
# + response - json Vcn
# + return - list of OciVcn
function getListVcns(json response) returns OciVcn[] {
    OciVcn[] list = [];
    int i = 0;
    int j = 0;
    json vcn;
    json[] responseList = <json[]> response;
    while(i < responseList.length()) {
        vcn = responseList[i];
        OciVcn|error ociVcn = OciVcn.constructFrom(vcn);
        if (ociVcn is OciVcn) {
            list[j] = ociVcn;
            j = j + 1;
        }
        i = i + 1;
    }    
    return list;
}


# GetRouteTable
# + response - json route table 
# + return - Return OciRouteTable
function getRouteTable(json response) returns OciRouteTable {
    OciRouteTable routeTable = createOciRouteTable();
    OciRouteTable|error ociRouteTable = OciRouteTable.constructFrom(response);
    if (ociRouteTable is OciRouteTable) {
        routeTable = ociRouteTable;
    } else {
        io:println(ociRouteTable);
    }
    return routeTable;
}


# ListRouteTables
# + response - json route table
# + return - Return list of OciRouteTable
function getListRouteTables(json response) returns OciRouteTable[] {
    OciRouteTable[] list = [];
    int i = 0;
    int j = 0;
    json routeTable;
    json[] responseList = <json[]> response;
    while(i < responseList.length()) {
        routeTable = responseList[i];
        OciRouteTable|error ociRouteTable = OciRouteTable.constructFrom(routeTable);
        if (ociRouteTable is OciRouteTable) {
            list[j] = ociRouteTable;
            j = j + 1;
        }
        i = i + 1;
    }    
    return list;
}


# GetRouteTable
# + response - json Internet Gateway
# + return - Return OciInternetGateway
function getInternetGateway(json response) returns OciInternetGateway {
    OciInternetGateway igw = createOciInternetGateway();
    OciInternetGateway|error ociInternetGateway = OciInternetGateway.constructFrom(response);
    if (ociInternetGateway is OciInternetGateway) {
        igw = ociInternetGateway;
    }
    return igw;
}


# ListInternetGateways
# + response - json Internet Gateway
# + return - Return list of OciInternetGateway
function getListInternetGateways(json response) returns OciInternetGateway[] {
    OciInternetGateway [] list = [];
    int i = 0;
    int j = 0;
    json igw;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        igw = responseList[i];
        OciInternetGateway|error ociInternetGateway = OciInternetGateway.constructFrom(igw);
        if (ociInternetGateway is OciInternetGateway) {
            list[j] = ociInternetGateway;
            j = j + 1;
        }
        i = i + 1;
    }
    return list;
}


# GetNatGateway
# + response - json Nat Gateway
# + return - Return OciNatGateway
function getNatGateway(json response) returns OciNatGateway {
    OciNatGateway ngw = createOciNatGateway();
    OciNatGateway|error ociNatGateway = OciNatGateway.constructFrom(response);
    if (ociNatGateway is OciNatGateway) {
        ngw = ociNatGateway;
    }
    return ngw;
}


# ListNatGateways
# + response - json Nat Gateway
# + return - Return list of OciNatGateway
function getListNatGateways(json response) returns OciNatGateway[] {
    OciNatGateway [] list = [];
    int i = 0;
    int j = 0;
    json ngw;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        ngw = responseList[i];
        OciNatGateway|error ociNatGateway = OciNatGateway.constructFrom(ngw);
        if (ociNatGateway is OciNatGateway) {
            list[j] = ociNatGateway;
            j = j + 1;
        }
        i = i + 1;
    }
    return list;
}


# GetSubnet
# + response - json subnet
# + return - Return OciSubnet
function getSubnet(json response) returns OciSubnet {
    OciSubnet subnet = createOciSubnet();
    OciSubnet|error ociSubnet = OciSubnet.constructFrom(response);
    if (ociSubnet is OciSubnet) {
        subnet = ociSubnet;
    } else {
        io:println(ociSubnet);
    }
    return subnet;
}


# ListSubnets
# + response - json subnet
# + return - Return list of OciSubnets
function getListSubnets(json response) returns OciSubnet[] {
    OciSubnet[] list = [];
    int i = 0;
    int j = 0;
    json subnet;
    json[] responseList = <json[]> response;
    while(i < responseList.length()) {
        subnet = responseList[i];
        OciSubnet|error ociSubnet = OciSubnet.constructFrom(subnet);
        if (ociSubnet is OciSubnet) {
            list[j] = ociSubnet;
            j = j + 1;
        }
        i = i + 1;
    }    
    return list;
}


# GetServiceGateway
# + response - json Service Gateway
# + return - Return OciServiceGateway
function getServiceGateway(json response) returns OciServiceGateway {
    OciServiceGateway sGateway = createOciServiceGateway();
    OciServiceGateway|error ocisGateway = OciServiceGateway.constructFrom(response);

    if (ocisGateway is OciServiceGateway) {
        sGateway = ocisGateway;
    } else {
        io:println(ocisGateway);
    }
    return sGateway;
}


# GetListServiceGateways
# + response - json Service Gateway
# + return - Return list of OciServiceGateway
function getListServiceGateways(json response) returns OciServiceGateway[] {
    OciServiceGateway[] list = [];
    int i = 0;
    int j = 0;
    json sGateway;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        sGateway = responseList[i];
        OciServiceGateway|error ocisGateway = OciServiceGateway.constructFrom(sGateway);
        if (ocisGateway is OciServiceGateway) {
            list[j] = ocisGateway;
            j = j + 1;
        }
        i = i + 1;
    }
    return list;
}


# GetListServices
# + response - json service
# + return - Return OciService
function getListServices(json response) returns OciService[] {
    OciService[] list = [];
    int i = 0;
    int j = 0;
    json serv;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        serv = responseList[i];
        OciService|error ocis = OciService.constructFrom(serv);
        if (ocis is OciService) {
            list[j] = ocis;
            j = j + 1;
        }
        i = i + 1;
    }
    return list;
}


# GetSecurityList
# + response - json Security List
# + return - OciSecurityList
function getSecurityList(json response) returns OciSecurityList {
    OciSecurityList securityList = createOciSecurityList();
    io: println(securityList);
    io:println(response);
    OciSecurityList|error ociSecurityList = OciSecurityList.constructFrom(response);
    if (ociSecurityList is OciSecurityList) {
        securityList = ociSecurityList;
    } else {
        io:println(ociSecurityList);
    }
    return securityList;
}


# ListSecurityLists
# + response - json Security List
# + return - list of OciSecurityList
function getListSecurityLists(json response) returns OciSecurityList[] {
    OciSecurityList[] list = [];
    int i = 0;
    int j = 0;
    json securityList;
    json[] responseList = <json[]> response;
    while(i < responseList.length()) {
        securityList = responseList[i];
        OciSecurityList|error ociSecurityList = OciSecurityList.constructFrom(securityList);
        if (ociSecurityList is OciSecurityList) {
            list[j] = ociSecurityList;
            j = j + 1;
        }
        i = i + 1;
    }    
    return list;
}
