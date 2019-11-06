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
import ballerina/runtime;
import ballerina/io;

// get configuration information from ballerina.conf
string host = config:getAsString("HOST_CORE");
string tenancyId = config:getAsString("TENANCY_ID"); 
string authUserId= config:getAsString("AUTHUSER_ID"); 
string keyFingerprint = config:getAsString("KEYFINGERPRINT"); 
string pathToKey = config:getAsString("PATHTOKEY"); 
string keyStorePassword = config:getAsString("KEYSTOREPASSWORD"); 
string keyAlias = config:getAsString("KEYALIAS"); 
string keyPassword = config:getAsString("KEYPASSWORD"); 

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

// Instance
# Terminal command to test:
# ballerina test --config ballerina.conf --groups instances-<GROUPS>
# Example: ballerina test --config ballerina.conf --groups instances-list

# Delay by X amount of minutes
# + minutes - float to allow for decimal valued minutes
function delay(float minutes) {
    int totalDelay = <int>(minutes * 60 * 1000);
    runtime:sleep(totalDelay);
}

// Instances test variables
string compartmentId = "";
string instanceDisplayName = "";
string instanceDisplayNameUpdate = "";
string instanceId = "";
string instanceAvailDomain = "";
string instanceShape = "";
string instanceImageId = "";
string instanceSubnetId = "" ;


// VCN test variables
string vcnDisplayName = "";
string vcnDisplayNameUpdate = "";
string vcnCidrBlock = "";


// Route Table test variables
string routeTableDisplayName_default = "";
string rtId = "";
string rtDisplayName = "";
string rtDisplayNameUpdate = "";
string rtIdToBeDeleted = "";
string createRtVcnId = "";
string createRtCidr = "";
string createRtNwEntity = "";
string destinationType = "";


// Service Gateway test variables
string sGatewayDisplayName = "";
string sGatewayUpdatedName = "";
string sGOCID = "";
string sGVcnId = "";
string sGNewCompId = "";
string sGServiceId = "";


// Internet Gateway test variables
string vcnId = "";
string internetGatewayDisplayName = "";
boolean isEnabled = true;
string igId = "";
string internetGatewayDisplayNameUpdate = "";


// NAT gateway test variables
string natGatewayDisplayName = "";
string natGatewayId = "";  
string natGatewayDisplayNameUpdate = "";


// Security List test variables
string securityListDisplayName_default = "";
// for get
string securityListId = "";
// for create
string slDisplayName = "";
string slVcnId = "";
string slDestination = "";
string slProtocol = "";
// for update
string slDisplayNameUpdate = "";
string slIdToBeUpdated = "";
string slDestUpdate = "";
string slDestType = "";
boolean slStateless = false;
// for delete
string slIdToBeDeleted = "";
// for list
string slVcnIdForList = "";


//Subnet test variables
string subnetId = "";
string subnetDisplayName = "";
string subnetDisplayName_default = "";
string subnetCreateDisplayName = "";
string subnetCreateDisplayNameUpdate = "";
string subnetIdToBeDeleted = "";
string subnetRtId = "";
string subnetSlId = "";
string subnetDHCPOptions = "";
string subnetVcnId = "";
string subnetCIDRBlock = "";


# Given: instanceId
# When: getInstance
# Then: Prints instance name
# Assert: Found instance's id matches instanceId
@test:Config{}
function testGetInstance() {
    io:println();
    io:println("ociClient -> getInstance()");
    OciInstance instance = ociClient->getInstance(instanceId);
    io:println(instance.displayName);
    test:assertEquals(instance.id, instanceId, msg = "Cannot get instance");
}

# Given: compartmentId and instance requirements in jsonBody
# When: launchInstance
# Then: Create instance within compartment
# Assert: Instance created has instanceDisplayName
@test:Config{
    groups: ["instances-launch"]
}
function testLaunchInstance() {
    json jsonBody = {
        "compartmentId" : compartmentId,
        "availabilityDomain" : instanceAvailDomain,
        "displayName": instanceDisplayName,
        "shape": instanceShape,
        "imageId": instanceImageId,
        "subnetId": instanceSubnetId 
    };
    io:println("ociClient -> launchInstance()");
    OciInstance instance = ociClient->launchInstance(jsonBody);
    io:println(instance.displayName);
    io:println(instance.id);
    test:assertEquals(instanceDisplayName, instance.displayName, msg = "Incorrect displayName for launched instance");
}

# Given: Dictionary query string of instance compartmentId
# When: listInstances
# Then: Prints names of list of instances from compartment
# Assert: List contains instance with display name that matches instanceDisplayName
@test:Config{
    groups: ["instances-list"]
}
function testListInstances() {
    io:println("ociClient -> listInstances()");
    map<string> queries = {
        "compartmentId" : compartmentId
    };
    OciInstance[] instances = ociClient->listInstances(queries);
    boolean exists = false;
    foreach OciInstance instance in instances{
        io:println(instance.displayName);
        if(instance.displayName == instanceDisplayName){
            exists = true;
        }
    }
    test:assertEquals(exists, true, msg = "Cannot find instance with displayName " + instanceDisplayName + " within list");
}

# Given: instanceId and action[INSTANCES_START]
# When: instanceAction
# Then: Prints name of instance that has been started
# Assert: Instance has the state INSTANCES_START
@test:Config{
    groups: ["instances-start"]
}
function testInstanceAction_START() {
    io:println("ociClient -> instanceAction(" + INSTANCES_START + ")");
    OciInstance instance = ociClient->instanceAction(instanceId, INSTANCES_START);
    io:println(instance.displayName);
    io:println(instance.lifecycleState);
    test:assertEquals(instance.lifecycleState, INSTANCES_STARTING, msg = "Instance not started");
}

# Given: instanceId and action[INSTANCES_STOP]
# When: instanceAction
# Then: Prints name of instance that has been stopped
# Assert: Instance stopped is found and has the state INSTANCES_STOP
@test:Config{
    groups: ["instances-stop"]
}
function testInstanceAction_STOP() {
    io:println("ociClient -> instanceAction(" + INSTANCES_STOP + ")");
    OciInstance instance = ociClient->instanceAction(instanceId, INSTANCES_STOP);
    io:println(instance.displayName);
    io:println(instance.lifecycleState);
    test:assertEquals(instance.lifecycleState, INSTANCES_STOPPING, msg = "Instance not stopped");
}

# Given: instanceId
# When: terminateInstance
# Then: Terminate instance
# Assert: Check if instanceId exists using getInstance() call.
@test:Config{
    groups: ["instances-terminate"]
}
function testTerminateInstance() {
    io:println("ociClient -> terminateInstance()");
    ociClient->terminateInstance(instanceId);
    OciInstance instance = ociClient->getInstance(instanceId);
    test:assertEquals(instance.lifecycleState, INSTANCES_TERMINATING, msg = "Instance not terminated.");
}

# Given: instanceId and updated instance with instanceDisplayNameUpdate in jsonBody
# When: updateInstance
# Then: Prints name of instance that has updated information
# Assert: Instance has instanceDisplayNameUpdate 
@test:Config{
    groups: ["instances-update"]
}
function testUpdateInstance() {
    json jsonBody = {
        "displayName" : instanceDisplayNameUpdate
    };
    io:println("ociClient -> updateInstance()");
    OciInstance instance = ociClient->updateInstance(instanceId, jsonBody);
    io:println(instance.displayName);
    test:assertEquals(instanceDisplayNameUpdate, instance.displayName, msg = "Instnace display name not updated");
}

# Given: jsonBody for VCN cidrBlock/compartmentId/displayName
# When: createVcn
# Then: Display vcn information
# Assert: Vcn display name matches
@test:Config{
    groups: ["vcns-create"]
}
function testCreateVcn() {
    json jsonBody = {
        "cidrBlock" : vcnCidrBlock,
        "compartmentId" : compartmentId,
        "displayName" : vcnDisplayName
    };
    io:println("ociClient -> createVcn()");
    OciVcn vcn = ociClient->createVcn(jsonBody);
    test:assertEquals(vcnDisplayName, vcn.displayName, msg = "VCN " + vcnDisplayName + " not created.");
}

# Given: vcnId
# When: deleteVcn
# Then: Delete vcn
# Assert: GetVCN with vcnId doesn't return vcn with vcnDisplayName.
@test:Config{
    groups: ["vcns-delete"]
}
function testDeleteVcn() {
    io:println("ociClient -> deleteVcn()");
    ociClient->deleteVcn(vcnId);
    OciVcn vcn = ociClient->getVcn(vcnId);
    test:assertEquals(vcnDisplayName, vcn.displayName, msg = "VCN not deleted");
}

# Given: vcnId
# When: getVcn
# Then: Display vcn name
# Assert: Vcn returned has matching id with vcnId.
@test:Config{
    groups: ["vcns-get"]
}
function testGetVcn() {
    io:println("ociClient -> getVcn()");
    OciVcn vcn = ociClient->getVcn(vcnId);
    io:println("vcnName: " + vcn.displayName);
    test:assertEquals(vcn.id, vcnId, msg = "VCN not found");
}

# Given: Dictionary query string of vcn compartmentId
# When: listVcns
# Then: Displays list of vcn's from compartment
# Assert: List contains a vcn with display name that matches vcnDisplayName
@test:Config{
    groups: ["vcns-list"]
}
function testListVcns() {
    io:println("ociClient -> listVcns()");
    map<string> queries = {
        "compartmentId" : compartmentId
    };
    OciVcn[] vcns = ociClient->listVcns(queries);
    boolean exists = false;
    foreach OciVcn vcn in vcns {
        io:println("vcnName: " + vcn.displayName);
        if(vcn.displayName == vcnDisplayName){
            exists = true;
        }
    }
    test:assertEquals(exists, true, msg = "Cannot find instance with displayName" + vcnDisplayName + " within list");
}

# Given: vcnId with instanceDisplayNameUpdate in jsonBody
# When: updateVcn
# Then: Displays vcn that has updated display name
# Assert: Vcn has vcnDisplayNameUpdate 
@test:Config{
    groups: ["vcns-update"]
}
function testUpdateVcn() {
    json jsonBody = {
        "displayName" : vcnDisplayNameUpdate
    };
    io:println("ociClient -> updateVcn()");
    OciVcn vcn = ociClient->updateVcn(vcnId, jsonBody);
    io:println(vcn);
    test:assertEquals(vcnDisplayNameUpdate, vcn.displayName, msg = "VCN display name not updated");
}

# Given: rtId
# When: createRouteTable
# Then: Create route table
# Assert: Route table created has rtDisplayName 
@test:Config{
    groups: ["rt-create"]
}
function testCreateRouteTable() {
    io:println("ociClient -> createRouteTable");
    json jsonBody = {
        "displayName" : rtDisplayName,
        "vcnId" : createRtVcnId,
        "routeRules" : [{
            "cidrBlock" : createRtCidr,
            "networkEntityId" : createRtNwEntity
        }],
        "compartmentId" : compartmentId
    };

    OciRouteTable routeTable = ociClient->createRouteTable(jsonBody);
    test:assertEquals(routeTable.displayName, rtDisplayName, msg = rtDisplayName + " not created.");
}

# Given: rtId
# When:  deleteRouteTable
# Then:  Delete Route Table
# Assert: Route table fetched has no matching rtIDs
@test:Config{
    groups: ["rt-delete"]
}
function testDeleteRouteTable() {
    io:println("ociClient -> deleteRouteTable");
    ociClient->deleteRouteTable(rtIdToBeDeleted);
    OciRouteTable routeTable = ociClient->getRouteTable(rtIdToBeDeleted);
    test:assertEquals(routeTable.displayName, "", msg = "Route table not deleted.");
}

# Given: rtId
# When:  getRouteTable
# Then:  Display route table name and tags
# Assert: route table fetched has "Default Route Table for" within display name
@test:Config{
    groups: ["rt-get"]
}
function testGetRouteTable_Default() {
    io:println("ociClient -> getRouteTable");
    OciRouteTable routeTable = ociClient->getRouteTable(rtId);
    io:println(routeTable.displayName);
    // io:println(routeTable.definedTags);
    test:assertEquals(routeTable.displayName, routeTableDisplayName_default, msg = "Route table does not contain default");
}

# Given: Dictionary query string of compartmentId and vcnId
# When: listRouteTables
# Then: Displays list of route tables from compartment and VCN
# Assert: List contains route table that has "Default Route Table for" within display name
@test:Config{
    groups: ["rt-list"]
}
function testListRouteTables() {
    io:println("ociClient -> listRouteTables()");
    map<string> queries = {
        "compartmentId" : compartmentId,
        "vcnId" : createRtVcnId
    };
    OciRouteTable[] rts = ociClient->listRouteTables(queries);
    boolean exists = false;
    foreach OciRouteTable rt in rts {
        io:println(rt.displayName);
        if(rt.displayName == routeTableDisplayName_default) {
            exists = true;
        }
    }
    test:assertEquals(exists, true, msg = "Cannot find default route table within list");
}

# Given: rtId with instanceDisplayNameUpdate and route rules in jsonBody
# When: updateRouteTable
# Then: update Route Table
# Assert: Route table has rtDisplayNameUpdate and updated route rules
@test:Config{
    groups: ["rt-update"]
}
function testUpdateRouteTable() {
    OciRouteRule routeRule = {
        cidrBlock: createRtCidr,
        destination: createRtCidr,
        destinationType: destinationType,
        networkEntityId: createRtNwEntity
    };
    json jsonBody = {
        "displayName" : rtDisplayNameUpdate,
        "routeRules" : [{
            "cidrBlock" : createRtCidr,
            "networkEntityId" : createRtNwEntity
        }]
    };
    io:println("ociClient -> updateRouteTable()");
    OciRouteTable routeTable = ociClient->updateRouteTable(rtId, jsonBody);
    test:assertEquals(rtDisplayNameUpdate, routeTable.displayName, msg = "Route table display name not updated");
    test:assertEquals(routeRule, routeTable.routeRules[0], msg = "Route table rules not updated");
}

# Given: Compartment Id
# When: listServiceGateways
# Then: Prints list of service gateways
# Assert: List contains a service gateway with display name that matches sGatewayDisplayName
@test:Config {
    groups: ["sg-list"]
}
function testListServiceGateways() {
    io:println("ociClient -> listServiceGateways()");
    map<string> queries = {
        "compartmentId" : "ocid1.compartment.oc1..aaaaaaaaom5hbg7e3ozfd2z54guiaouexv5swrjyioru3xxgaaufs6jhhzpq"
    };
    boolean exists = false;
    OciServiceGateway[] sGateways = ociClient->listServiceGateways(queries);
    foreach OciServiceGateway sGateway in sGateways {
        io:println(sGateway.displayName);
        if (sGateway.displayName == sGatewayDisplayName) {
            exists = true;
        }
    }
    test:assertEquals(exists, true, msg = "SG doesn't exist");
}

# Given: Service Gateway OCID
# When: getServiceGateway
# Then: Print service gateway name
# Assert: Display name matches the provided name
@test:Config {
    groups: ["sg-get"]
}
function testGetServiceGateways() {
    io:println("ociClient -> getServiceGateway()");
    OciServiceGateway sGateway = ociClient->getServiceGateway(sGOCID);
    io:println(sGateway.displayName);
    test:assertEquals(sGateway.displayName, sGatewayDisplayName, msg = "SG doesn't exist");
}

# Given: Json body containing service gateway details
# When: createServiceGateway
# Then: Create service gateway and display the name
# Assert: The created service gateway display name matches the name provided
@test:Config{
    groups: ["sg-create"]
}
function testCreateServiceGateways() {
    io:println("ociClient -> createServiceGateway()");
    json jsonBody = {
        "compartmentId": compartmentId,
        "displayName": sGatewayDisplayName,
        "vcnId": sGVcnId,
        "services": []
    };
    OciServiceGateway sGateway = ociClient->createServiceGateway(jsonBody);
    io:println(sGateway.displayName);
    test:assertEquals(sGateway.displayName, sGatewayDisplayName, msg = "SG was not created successfully");
}

# Given: Service Gateway OCID
# When: deteleServiceGateway
# Then: Delete service gateway
# Assert: Service gateway was deleted by doing a get
@test:Config{
    groups: ["sg-delete"]
}
function testDeleteServiceGateways() {
    io:println("ociClient -> deleteServiceGateway()");
    ociClient->deleteServiceGateway(sGOCID);
    OciServiceGateway sGateway = ociClient->getServiceGateway(sGOCID);
    test:assertEquals(sGateway.lifecycleState, "TERMINATING", msg = "SG was not deleted");
}

# Given: Service Gateway OCID and name to be updated
# When: updateServiceGateway
# Then: Update the name of the service gateway
# Assert: The name of the service gateway was updated 
@test:Config{
    groups: ["sg-update"]
}
function testUpdateServiceGateways() {
    io:println("ociClient -> updateServiceGateway()");
    json jsonBody = {
        "displayName": sGatewayUpdatedName
    };
    OciServiceGateway sGateway = ociClient->updateServiceGateway(sGOCID, jsonBody);
    test:assertEquals(sGateway.displayName, sGatewayUpdatedName, msg = "SG was not updated");
}

# Given: Service Gateway OCID and compartment id to be moved to
# When: changeServiceGatewayCompartment
# Then: Move the service gateway to the given compartment
# Assert: The compartment id that the service gateway is in matches the one we provided
@test:Config{
    groups: ["sg-changecmp"]
}
function testChangeServiceGatewayCompartment() {
    io:println("ociClient -> changeServiceGatewayCompartment()");
    json jsonBody = {
        "compartmentId": sGNewCompId
    };
    ociClient->changeServiceGatewayCompartment(sGOCID, jsonBody);
    OciServiceGateway sGateway = ociClient->getServiceGateway(sGOCID);
    test:assertEquals(sGateway.compartmentId, sGNewCompId, msg = "SG was not moved to right compartment");
}

# Given: Service Gateway OCID and service id to be attached
# When: attachServiceId
# Then: Attach the service gateway to the given service id
# Assert: Service Id was attached by fetching the current one and comparing it to the one we provided
@test:Config{
    groups: ["sg-attach"]
}
function testAttachServiceId() {
    io:println("ociClient -> attachServiceId()");
    json jsonBody = {
        "serviceId": sGServiceId
    };
    OciServiceGateway sGateway = ociClient->attachServiceId(sGOCID, jsonBody);
    test:assertEquals(sGateway.services[0].serviceId, sGServiceId, msg = "ServiceId was not attached");
}

# Given: Service Gateway OCID and service id to be detached
# When: detachServiceId
# Then: Detach Service Id from the Service Gateway
# Assert: The servie id is detached
@test:Config{
    groups: ["sg-detach"]
}
function testDetachServiceId() {
    io:println("ociClient -> detachServiceId()");
    json jsonBody = {
        "serviceId": sGServiceId
    };
    OciServiceGateway sGateway = ociClient->detachServiceId(sGOCID, jsonBody);
    test:assertEquals(sGateway.services.length(), 0, msg = "ServiceId was not detached");
}

# Given: None
# When: listServices
# Then: List all the services in the region
# Assert: There is at least one service returned
@test:Config{
    groups: ["sg-servs"]
}
function testListServices() {
    io:println("ociClient -> listServices()");
    OciService[] ocis = ociClient->listServices();
    io:println(ocis);
    test:assertNotEquals(ocis.length(), 0, msg = "No services returned");
}


# Given: compartmentId, vcnId and internet gateway requirements in jsonBody
# When: createInternetGateway
# Then: Create internet gateway within tenancy
# Assert: Internet Gateway created has internetGatewayDisplayName
@test:Config{
    groups: ["internet-gateways-create"]
}
function testCreateInternetGateway() {
    json jsonBody = {
        "compartmentId" : compartmentId,
        "vcnId" : vcnId,
        "displayName" : internetGatewayDisplayName, 
        "isEnabled": isEnabled
    };
    io:println("ociClient -> createInternetGateway()");
    OciInternetGateway igw = ociClient->createInternetGateway(jsonBody);
    test:assertEquals(internetGatewayDisplayName, igw.displayName, msg = "INTERNET_GATEWAY " + internetGatewayDisplayName + " not created.");  
    io:println("IGW " + igw.displayName + " created with OCID--> " + igw.id);
}

# Given: igId
# When: deleteInternetGateway
# Then: Delete internet gateway
# Assert: GetInternetGateway with igId doesn't return internet gateway with internetGatewayDisplayName
@test:Config{
    groups: ["internet-gateways-delete"]
}
function testDeleteInternetGateway() {
    OciInternetGateway igw = ociClient->getInternetGateway(igId);
    io:println("ociClient -> deleteInternetGateway()");
    ociClient->deleteInternetGateway(igId);
    test:assertEquals(igId, igw.id, msg = "INTERNET_GATEWAY not deleted");
    io:println("IGW " + igw.displayName + " with OCID--> " + igw.id + " deleted");
}

# Given: igId
# When: getInternetGateway
# Then: Prints internet gateway
# Assert: Internet Gateway fetched has matching id with igId
@test:Config{
    groups: ["internet-gateways-get"]
}
function testGetInternetGateway() {
    io:println("ociClient -> getInternetGateway()");
    OciInternetGateway igw = ociClient->getInternetGateway(igId);
    test:assertEquals(igw.id, igId, msg = "INTERNET_GATEWAY not found");
    io:println("displayName: " + igw.displayName);
    io:println("igId: " + igw.id);
}

# Given: Dictionary query string of internet gateway compartmentId, vcnId
# When: listInternetGateways
# Then: Display list of internet gateways from compartment, vcn
# Assert: 
@test:Config{
    groups: ["internet-gateways-list"]
}
function testListInternetGateways() {
    io:println("ociClient -> listInternetGateways()");
    map<string> queries = {
        "compartmentId" : compartmentId,
        "vcnId" : vcnId
    };
    OciInternetGateway[] igws = ociClient->listInternetGateways(queries);
    foreach OciInternetGateway igw in igws{
        io:println("displayName: " + igw.displayName);
        io:println("igId: " + igw.id);
    }
}

# Given: igId with internetGatewayDisplayNameUpdate in jsonBody
# When: updateInternetGateway
# Then: Display internet gateway that has updated description
# Assert: InternetGateway display name was updated
@test:Config{
    groups: ["internet-gateways-update"]
}
function testUpdateInternetGateway() {
    json jsonBody = {
        "displayName" : internetGatewayDisplayNameUpdate,
        "isEnabled" : false
    };
    io:println("ociClient -> updateInternetGateway()");
    OciInternetGateway igw = ociClient->updateInternetGateway(igId, jsonBody);
    test:assertEquals(internetGatewayDisplayNameUpdate, igw.displayName, msg = "IGW displayName not updated");
    io:println("Internet Gateway " + igw.displayName + " with OCID--> " + igw.id + " updated");
}

# Given: compartmentId, vcnId and internet gateway requirements in jsonBody
# When: CreateNatGateway
# Then: Create nat gateway within tenancy
# Assert: Nat Gateway created has natGatewayDisplayName
@test:Config{
    groups: ["nat-gateways-create"]
}
function testCreateNatGateway() {
    json jsonBody = {
        "displayName" : natGatewayDisplayName,
        "compartmentId" : compartmentId,
        "vcnId" : vcnId
    };
    io:println("ociClient -> createNatGateway()");
    OciNatGateway ngw = ociClient->createNatGateway(jsonBody);
    //test:assertEquals(natGatewayDisplayName, ngw.displayName, msg = "NAT_GATEWAY " + natGatewayDisplayName + " not created.");
    io:println("NGW " + ngw.displayName + " created with OCID--> " + ngw.id);
}

# Given: natGatewayId
# When: deleteNatGateway
# Then: Delete nat gateway
# Assert: GetNatGateway with natGatewayId doesn't return nat gateway with natGatewayDisplayName
@test:Config{
    groups: ["nat-gateways-delete"]
}
function testDeleteNatGateway() {
    OciNatGateway ngw = ociClient->getNatGateway(natGatewayId);
    io:println("ociClient -> deleteNatGateway()");
    ociClient->deleteNatGateway(natGatewayId);
    test:assertEquals(natGatewayId, ngw.id, msg = "NAT_GATEWAY not deleted");
    io:println("NGW " + ngw.displayName + "with OCID--> " + ngw.id + " deleted");
}

# Given: natGatewayId
# When: getNatGateway
# Then: Prints nat gateway
# Assert: Nat Gateway fetched has matching id with natGatewayId
@test:Config{
    groups: ["nat-gateways-get"]
}
function testGetNatGateway() {
    io:println("ociClient -> getNatGateway()");
    OciNatGateway ngw = ociClient->getNatGateway(natGatewayId);
    test:assertEquals(ngw.id, natGatewayId, msg = "NAT_GATEWAY not found");
    io:println("displayName: " + ngw.displayName);
    io:println("natGatewayId: " + ngw.id);
}

# Given: Dictionary query string of nat gateway compartmentId, vcnId
# When: listNatGateways
# Then: Display list of nat gateways from compartment, vcn
# Assert:  
@test:Config{
    groups: ["nat-gateways-list"]
}
function testListNatGateways() {
    io:println("ociClient -> listNatGateways()");
    map<string> queries = {
        "compartmentId" : compartmentId,
        "vcnId" : vcnId
    };
    OciNatGateway[] ngws = ociClient->listNatGateways(queries);
    foreach OciNatGateway ngw in ngws {
        io:println("displayName: " + ngw.displayName);
        io:println("natGatewayId: " + ngw.id);
    }  
}

# Given: natGatewayId with natGatewayDisplayNameUpdate in jsonBody
# When: updateNatGateway
# Then: Display nat gateway that has updated description
# Assert: That nat gateway was updated with the provided display name
@test:Config{
    groups: ["nat-gateways-update"]
}
function testUpdateNatGateway() {
    json jsonBody = {
        "displayName" : natGatewayDisplayNameUpdate
    };
    io:println("ociClient -> updateNatGateway()");
    OciNatGateway ngw = ociClient->updateNatGateway(natGatewayId, jsonBody);
    test:assertEquals(natGatewayDisplayNameUpdate, ngw.displayName, msg = "NGW displayName not updated");
    io:println("Nat Gateway " + ngw.displayName + " with OCID--> " + ngw.id + " updated");
}

# Given: securityListId
# When: getSecurityList
# Then: Display security list name from security list ID
# Assert: Security list returned has "Default Security List for" within display name
@test:Config {
    groups: ["sl-get"]
}
function testGetSecurityList_Default() {
    io:println("ociClient -> getSecurityList");
    OciSecurityList securityList = ociClient->getSecurityList(securityListId);
    io:println(securityList.displayName);
    test:assertEquals(securityList.displayName, securityListDisplayName_default, msg = "Security list does not contain default");
}

# Given: slId
# When: createSecurityList
# Then: Create security list with a 0.0.0.0/0 cidr block egress TCP security rule 
# Assert: Security list returned matches slDisplayName 
@test:Config{
    groups: ["sl-create"]
}
function testCreateSecurityList() {
    io:println("ociClient -> createSecurityList");
    json jsonBody = {
        "compartmentId": compartmentId,
        "displayName": slDisplayName,
        "egressSecurityRules": [{
            "destination": slDestination,
            "protocol": slProtocol
        }],
        "ingressSecurityRules": [],
        "vcnId": slVcnId
    };
    OciSecurityList securityList = ociClient->createSecurityList(jsonBody);
    test:assertEquals(securityList.displayName, slDisplayName, msg = slDisplayName + " not created.");
}

# Given: slIdToBeUpdated with slDisplayNameUpdate and egress security rules in jsonBody
# When: updateSecurityList
# Then: Update security list
# Assert: Security List has slDisplayNameUpdate and updated egress security rules
@test:Config{
    groups: ["sl-update"]
}
function testUpdateSecurityList() {
    OciEgressSecurityRule egressSecurityRule = {
        destination: slDestUpdate,
        protocol: slProtocol,
        destinationType: slDestType, 
        isStateless: slStateless
    };
    json jsonBody = {
        "displayName" : slDisplayNameUpdate,
        "egressSecurityRules" : [{
           "destination": slDestUpdate,
            "protocol": slProtocol
        }]
    };
    io:println("ociClient -> updateSecurityList()");
    OciSecurityList securityList = ociClient->updateSecurityList(slIdToBeUpdated, jsonBody);
    test:assertEquals(slDisplayNameUpdate, securityList.displayName, msg = "Security List display name not updated");
    test:assertEquals(egressSecurityRule, securityList.egressSecurityRules[0], msg = "Security List rules not updated");
}

# Given: slId
# When: deleteSecurityList
# Then: Delete security list
# Assert: Security list returned has no matching slID
@test:Config{
    groups: ["sl-delete"]
}
function testDeleteSecurityList() {
    io:println("ociClient -> deleteSecurityList");
    ociClient->deleteSecurityList(slIdToBeDeleted);
    OciSecurityList securityList = ociClient->getSecurityList(slIdToBeDeleted);
    test:assertEquals(securityList.displayName, "", msg = "Security List not deleted.");
}

# Given: Dictionary query string of compartmentId and vcnId
# When: listSecurityLists
# Then: Display name of security lists from the given compartment and VCN
# Assert: List contains security lists that has "Default Security List for" within display name
@test:Config{
    groups: ["sl-list"]
}
function testListSecurityLists() {
    io:println("ociClient -> listSecurityRules()");
    map<string> queries = {
        "compartmentId" : compartmentId,
        "vcnId" : slVcnIdForList
    };
    OciSecurityList[] sls = ociClient->listSecurityList(queries);
    boolean exists = false;
    foreach OciSecurityList sl in sls {
        if(sl.displayName == securityListDisplayName_default) {
            exists = true;
        }
        io:println(sl.displayName);
    }
    test:assertEquals(exists, true, msg = "Cannot find default security list within list");
}

# Given: Subnet details
# When: createSubnet
# Then: create subnet
# Assert: Subnet created has provided display name
@test:Config{
    groups: ["subnet-create"]
}
function testCreateSubnet(){
    io:println("ociClient -> createSubnet()");
    json jsonBody = {
        "displayName" : subnetCreateDisplayName,
        "cidrBlock" : subnetCIDRBlock,
        "availabilityDomain" : instanceAvailDomain,
        "routeTableId" : subnetRtId,
        "securityListIds" : [ subnetSlId ],
        "dhcpOptionsId" : subnetDHCPOptions,
        "vcnId" : subnetVcnId,
        "compartmentId" : compartmentId
    };
    OciSubnet subnet = ociClient->createSubnet(jsonBody);
    test:assertEquals(subnet.displayName, subnetCreateDisplayName, msg = subnetCreateDisplayName + " not created.");
}

# Given: SubnetId
# When: deleteSubnet
# Then: Delete Subnet
# Assert: List of subnets returned has no matching subnetId
@test:Config{
    groups: ["subnet-delete"]
}
function testDeleteSubnet(){
    io:println("ociClient -> deleteSubnet");
    ociClient->deleteSubnet(subnetIdToBeDeleted);
    OciSubnet subnet = ociClient->getSubnet(subnetIdToBeDeleted);
    test:assertEquals(subnet.displayName, "", msg = "Subnet not deleted.");
}

# Given: SubnetId
# When: getSubnet
# Then: Print subnet name
# Assert: The subnet display name fetched matches provided subnet name
@test:Config{
    groups: ["subnet-get"]
}
function testGetSubnet(){
    io:println("ociClient -> getSubnet");
    OciSubnet subnet = ociClient->getSubnet(subnetId);
    io:println(subnet.displayName);
    test:assertEquals(subnet.displayName, subnetDisplayName, msg = "Subnet not found");
}

# Given: Dictionary query string of compartmentId and vcnId
# When: listSubnets
# Then: Display list of subnets from compartment and VCN
# Assert: List contains subnets that has "Public Subnet" within display name
@test:Config{
    groups: ["subnet-list"]
}
function testListSubnets() {
    io:println("ociClient -> listSubnets()");
    map<string> queries = {
        "compartmentId" : compartmentId,
        "vcnId" : subnetVcnId
    };
    OciSubnet[] subnets = ociClient->listSubnets(queries);
    boolean exists = false;
    foreach OciSubnet subnet in subnets{
        io:println(subnet.displayName);
        if(subnet.displayName == subnetDisplayName_default) {
            exists = true;
        }
    }
    test:assertEquals(exists, true, msg = "Cannot find default route table within list");
}

# Given: subnetId and UpdateSubnetDetails jsonBody
# When: updateSubnet
# Then: Update subnet display name
# Assert: Subnet has subnetCreateDisplayNameUpdate 
@test:Config{
    groups: ["subnet-update"]
}
function testUpdateSubnet() {
    json jsonBody = {
        "displayName" : subnetCreateDisplayNameUpdate
    };
    io:println("ociClient -> updateSubnet()");
    OciSubnet subnet = ociClient->updateSubnet(subnetId, jsonBody);
    test:assertEquals(subnetCreateDisplayNameUpdate, subnet.displayName, msg = "Subnet display name not updated");
}
