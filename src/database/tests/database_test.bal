//
// Copyright © [2018,] 2019, Oracle and/or its affiliates. All rights reserved.
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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
import ballerina/runtime;

//get configuration information from ballerina.conf
string host = config:getAsString("HOST_IAM");
string tenancyId = config:getAsString("TENANCY_ID"); 
string authUserId= config:getAsString("AUTHUSER_ID"); 
string keyFingerprint = config:getAsString("KEYFINGERPRINT"); 
string pathToKey = config:getAsString("PATHTOKEY"); 
string keyStorePassword = config:getAsString("KEYSTOREPASSWORD"); 
string keyAlias = config:getAsString("KEYALIAS"); 
string keyPassword = config:getAsString("KEYPASSWORD"); 

// # oci client endpoint
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

//User
# Terminal command to test:
# ballerina test --config ballerina.conf --groups users-<GROUPS>
# Example: ballerina test --config ballerina.conf --groups users-list

# Delay by X amount of minutes
# + minutes - float to allow for decimal valued minutes
function delay(float minutes) {
    int totalDelay = <int>(minutes * 60 * 1000);
    runtime:sleep(totalDelay);
}


//Users test variables
string userDescription = "";
string userName = "";
string userId = "";
string userDescriptionUpdate = "";


//Group
# Terminal command to test:
# ballerina test --config ballerina.conf --groups groups-<GROUPS>
# Example: ballerina test --config ballerina.conf --groups groups-list
 
//Groups test variables
string groupDisplayName = "";
string groupDescription  = "";
string groupDescriptionUpdate = "";
string groupId = "";


//Compartment
# Terminal command to test:
# ballerina test --config ballerina.conf --groups compartments-<GROUPS>
# Example: ballerina test --config ballerina.conf --groups compartments-list
string compartmentName = "";
string compartmentDescription = "";
string compartmentUpdatedDescription = "";
string compartmentUpdatedName = "";
string compartmentId = "";
string compartmentLimit = "";


# Given: compartmentId and user requirements in jsonBody
# When:  createUser
# Then:  Create user within tenancy
# Assert:User created has userName
@test:Config{
    groups: ["users-create"]
}
function testCreateUser() {
    json jsonBody = {
        "compartmentId" : compartmentId,
        "name" : userName, 
        "description": userDescription,
        "email": "ballerina.user@oracle.com"
    };
    io:println("ociClient -> createUser()");
    OciUser user = ociClient->createUser(jsonBody);
    io:println("User " + user.name + " created with OCID--> " + user.id);
    test:assertEquals(userName, user.name, msg = "USER " + userName + " not created.");
}

# Given: userId
# When:  deleteUser
# Then:  Delete user
# Assert:GetUser with userId doesn't return user with userName.
@test:Config{
    groups: ["users-delete"]
}
function testDeleteUser() {
    OciUser user = ociClient->getUser(userId);
    io:println("ociClient -> deleteUser()");
    ociClient->deleteUser(userId);
    io:println("User " + user.name + "with OCID--> " + user.id + " deleted");
    test:assertEquals(userName, user.name, msg = "USER not deleted");
}

# Given: userId
# When:  getUser
# Then:  Returns user
# Assert:User returned has matching id with userId.
@test:Config{
    groups: ["users-get"]
}
function testGetUser() {
    io:println("ociClient -> getUser()");
    OciUser user = ociClient->getUser(userId);
    io:println("userName: " + user.name);
    io:println("userId: " + user.id);
    test:assertEquals(user.id, userId, msg = "USER not found");
}

# Given: Dictionary query string of user compartmentId
# When:  listUsers
# Then:  Returns list of users from compartment
# Assert:List contains a user with user name that matches userName
@test:Config{
    groups: ["users-list"]
}
function testListUsers() {
    io:println("ociClient -> listUsers()");
    map<string> queries = {
        "compartmentId" : compartmentId
    };
    OciUser[] users = ociClient->listUsers(queries);
    foreach OciUser user in users{
        io:println("User Name: " + user.name);
        io:println("User Id: " + user.id);
    }
}

# Given: userId with userDescriptionUpdate in jsonBody
# When:  updateUser
# Then:  Returns user that has updated description
# Assert:User has userDescriptionUpdate 
@test:Config{
    groups: ["users-update"]
}
function testUpdateUser() {
    json jsonBody = {
        "description" : userDescriptionUpdate
    };
    io:println("ociClient -> updateUser()");
    OciUser user = ociClient->updateUser(userId, jsonBody);
    io:println("User " + user.name + "with OCID--> " + user.id + " updated");
    test:assertEquals(userDescriptionUpdate, user.description, msg = "USER description not updated");
}


# Given:  compartmentId and group requirements in jsonBody
# When:   createGroup
# Then:   Create group within tenancy
# Assert: Group created has groupDisplayName
@test:Config{
    groups: ["groups-create"]
}
function testCreateGroups() {
    json jsonBody = {
        "compartmentId" : compartmentId,
        "name" : groupDisplayName, 
        "description": groupDescription
    };
    OciGroups groupi = ociClient->createGroups(jsonBody);
    io:println("Group " + groupi.name + " created with OCID--> " + groupi.id);
    test:assertEquals(groupDisplayName, groupi.name, msg = "GROUPS " + groupDisplayName + " not created.");
}

# Given: groupId
# When:  deleteGroup
# Then:  Delete group
# Assert:GetGroup with groupId doesn't return group with groupDisplayName.
@test:Config{
    groups: ["groups-delete"]
}
function testDeleteGroup() {
    OciGroups groupi = ociClient->getGroups(groupId);
    io:println("ociClient -> deleteGroup()");
    ociClient->deleteGroup(groupId);
    io:println("Group " + groupi.name + "with OCID--> " + groupi.id + " deleted");
    test:assertEquals(groupDisplayName, groupi.name , msg = "Group not deleted");
}

# Given: groupId
# When:  getGroup
# Then:  Returns Group
# Assert:Group returned has matching id with groupId.
@test:Config{
    groups: ["groups-get"]
}
function testGetGroup() {
    io:println("ociClient -> getGroup()");
    OciGroups groupi = ociClient->getGroups(groupId);
    io:println("groupName: " + groupi.name);
    io:println("groupId: " + groupi.id);
    test:assertEquals(groupi.name, groupDisplayName, msg = "GROUP not found");
}

# Given: Dictionary query string of group compartmentId
# When:  listGroups
# Then:  Returns list of groups from compartment
# Assert:List contains a group with group name that matches groupDisplayName
@test:Config{
    groups: ["groups-list"]
}
function testListGroups() {
    io:println("ociClient -> listGroups()");
    map<string> queries = {
        "compartmentId" : compartmentId
    };
    OciGroups[] groups = ociClient-> listGroups(queries);
    foreach OciGroups groupi in groups{
        io:println("Group Name: " + groupi.name);
        io:println("Group Id: " + groupi.id);
    }
}

# Given: groupId 
# When:  updateGroup
# Then:  Returns group that has updated description
# Assert:Group has groupDescriptionUpdate
@test:Config{
    groups: ["groups-update"]
}
function testUpdateGroup() {
    json jsonBody = {
        "description" : groupDescriptionUpdate
    };
    io:println("ociClient -> updateGroup()");
    OciGroups groupi = ociClient->updateGroup(groupId, jsonBody);
    io:println("User " + groupi.name + " with OCID--> " + groupi.id + " updated");
    test:assertEquals(groupDescriptionUpdate, groupi.description, msg = "Group description not updated");
}

# Given: Dictionary query string of compartmentId
# When: listCompartments
# Then: Returns list of compartments from parent compartment
# Assert: List contains compartment with display name that matches compartmentDisplayName
@test:Config{
    groups: ["compartments-list"]
}
function testListCompartments() {
    io:println("ociClient -> listCompartments()");
    map<string> queries = {
        "compartmentId" : compartmentId,
        "compartmentIdInSubtree" : "true",
        "limit": compartmentLimit
    };
    OciCompartment[] compartments = ociClient->listCompartments(queries);
    boolean exists = false;
    foreach OciCompartment compartment in compartments {
        io:println(compartment.name);
        if (compartment.name == compartmentName) {
            exists = true;
        }
    }
}

@test:Config{
    groups: ["compartments-get"]
}
function testGetCompartment() {
    io:println("ociClient -> getCompartment()");
    OciCompartment compartment = ociClient->getCompartment(compartmentId);
    io:println("Compartment Name " + compartment.name);
    test:assertEquals(compartment.id,compartmentId , msg = "Cannot get compartment");
}

@test:Config{
    groups: ["compartments-delete"]
}
function testDeleteCompartment() {
    io:println("ociClient -> deleteComparatment()");
    json response = ociClient->deleteCompartment(compartmentId);
    OciCompartment compartment = ociClient->getCompartment(compartmentId);
    test:assertNotEquals(compartment.lifecycleState, COMPARTMENT_ACTIVE, msg = "Compartment not deleted");
}

@test:Config{
    groups: ["compartments-create"]
}
function testCreateCompartment() {
    io:println("ociClient -> createCompartment()");
    json jsonBody = {
        "compartmentId" : compartmentId,
        "description" : compartmentDescription,
        "name" : compartmentName
    };
    OciCompartment compartment = ociClient->createCompartment(jsonBody);
    test:assertEquals(compartment.name, compartmentName, msg = "Cannot create compartment");
}

@test:Config{
    groups: ["compartments-update"]
}
function testUpdateCompartment() {
    io:println("ociClient -> updateCompartment()");
    json jsonBody = {
        "description" : compartmentUpdatedDescription,
        "name" : compartmentUpdatedName
    };
    OciCompartment compartment = ociClient->updateCompartment(compartmentId, jsonBody);
    test:assertEquals(compartment.name, compartmentUpdatedName , msg = "Cannot update compartment");
}
