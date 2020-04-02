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

# Oracle Client object.
# + ociConfig - OCI configuration
# + ociClient - HTTP client endpoint config
public type Client client object {

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
    
    http:Client ociClient;

    public function __init(OciConfiguration ociConfig) {
        io:println("Init OCI Client");
        self.ociConfig = ociConfig;
        string endpointUrl = "https://" + self.ociConfig.host;
        self.ociClient = new(endpointUrl, ociConfig.clientConfig);
    }

    # Given: User requirements in json body { Compartment Id - Availability Domain - Display Name - Shape - Image Id - Subnet Id }
    # When:  GET 
    # Then:  Return user details.
    # + userId - OCID of user
    # + return - If successful, returns an OCI user, else logs the error
    public remote function getUser(string userId) returns OciUser {
        return getUser(ociGetRequest(self.ociConfig, self.ociClient, USERS, userId, {}));
    }

    # Given: Instance requirements in json body { Compartment Id - Availability Domain - Display Name - Shape - Image Id - Subnet Id }
    # When:  GET
    # Then:  Return group details.
    # + groupId - OCID of group
    # + return - If successful, returns an OCI group, else logs the error
    public remote function getGroups(string groupId) returns OciGroups {
        return getGroups(ociGetRequest(self.ociConfig, self.ociClient, GROUPS, groupId, {}));
    }

    # Given: Dictionary of query items
    #   Required: compartmentId 
    #   Optional: availabilityDomain, displayName, limit, page, sortBy, sortOrder, lifecycleState
    # When:  GET 
    # Then:  Return list of users that match query.
    # + queries - Map of query strings for filtering list of users
    # + return - If successful, returns OciUser[] with zero or more users, else logs the error
    public remote function listUsers(map<string> queries) returns OciUser[] {
        return getListUsers(ociGetRequest(self.ociConfig, self.ociClient, USERS, "", queries));
    }
    # Given: Dictionary of query items
    #   Required: compartmentId
    #   Optional: availabilityDomain, displayName, limit, page, sortBy, sortOrder, lifecycleState
    # When:  GET
    # Then:  Return list of groups that match query.
    # + queries - Map of query strings for filtering list of groups
    # + return - If successful, returns OciGroups[] with zero or more groups, else logs the error
    public remote function listGroups(map<string> queries) returns OciGroups[] {
        return getListGroups(ociGetRequest(self.ociConfig, self.ociClient, GROUPS, "", queries));
    }

    # Given: User Id.
    # When:  DELETE 
    # Then:  Terminate user with user id.
    # + userId - OCID of user
    public remote function deleteUser(string userId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, USERS, userId);
    }

    # Given: Group Id.
    # When:  DELETE
    # Then:  Terminate group with group id.
    # + groupId - OCID of group
    public remote function deleteGroup(string groupId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, GROUPS, groupId);
    } 

    # Given: User Id and json for updated user information.
    # When:  PUT 
    # Then:  Update and return user with updated information.
    # + userId - OCID of user
    # + jsonBody - change user: definedTags, displayName, freeformTags, metadata, extendedMetadata
    # + return - If successful, returns an OCI user, else logs the error
    public remote function updateUser(string userId, json jsonBody) returns OciUser {
        return getUser(ociPutRequest(self.ociConfig, self.ociClient, USERS, 
                            userId, jsonBody));

    }

    # Given: Group Id and json for updated group information.
    # When:  PUT
    # Then:  Update and return group with updated information.
    # + groupId - OCID of group
    # + jsonBody - change group: definedTags, displayName, freeformTags, metadata, extendedMetadata
    # + return - If successful, returns an OCI group, else logs the error
    public remote function updateGroup(string groupId, json jsonBody) returns OciGroups {
        return getGroups(ociPutRequest(self.ociConfig, self.ociClient, GROUPS, groupId, jsonBody));
    }

    # Given: Json body with name, compartmentId, description and email
    # When:  POST 
    # Then:  Create and return user with name, description and email.
    # + jsonBody - compartmentId, displayName
    # + return - If successful, returns an OCI User, else logs the error
    # public remote function createUser(json jsonBody) returns OciUser;
    public remote function createUser(json jsonBody) returns OciUser{
        return getUser(ociPostRequest(self.ociConfig, self.ociClient, USERS, "", "", jsonBody));
    }

    # Given: Json body with name, compartmentId, description and email
    # When:  POST
    # Then:  Create and return group with name, description and email.
    # + jsonBody - compartmentId, displayName
    # + return - If successful, returns an OCI Group, else logs the error
    # public remote function createGroups(json jsonBody) returns OciGroups;
    public remote function createGroups(json jsonBody) returns OciGroups{
        return getGroups(ociPostRequest(self.ociConfig, self.ociClient, GROUPS, "", "", jsonBody));
    }

    # Given: 
    #   Required : compartmentId
    #   Optional : page, limit, accessLevel, compartmentIdInSubtree
    # When:  GET
    # Then:  List child compartments under parent compartment
    # + queries - Map of query strings for filtering list of compartments
    # + return - If successful, returns OciCompartments[] with zero or more compartments, else logs the error
    public remote function listCompartments(map<string> queries) returns OciCompartment[] {
        return getListCompartments(ociGetRequest(self.ociConfig, self.ociClient, COMPARTMENTS, "", queries));
    }

    # Given: compartmentId of interest
    # When:  GET
    # Then:  Return compartment details
    # + compartmentId - ocid of compartment to get
    # + return - If successful, return OCI compartment object, else logs error
    public remote function getCompartment(string compartmentId) returns OciCompartment {
        return getCompartment(ociGetRequest(self.ociConfig, self.ociClient, COMPARTMENTS, compartmentId, {}));
    }

    # Given: compartmentId of interest
    # When:  GET
    # Then:  Terminate compartment
    # + compartmentId - ocid of compartment to delete
    public remote function deleteCompartment(string compartmentId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, COMPARTMENTS, compartmentId);
    }

    # Given: jsonBody with compartmentId, name, description, freeformTags, and definedTags
    # When:  GET
    # Then:  Create compartment with details
    # + jsonBody - compartmentId, name, description, freeformTags, definedTags
    # + return - If successful, return OciCompartment, else logs error
    public remote function createCompartment(json jsonBody) returns OciCompartment {
        return getCompartment(ociPostRequest(self.ociConfig, self.ociClient, COMPARTMENTS, "", "", jsonBody));
    }

    # Given: compartmentId of interest and jsonBody with name, description, freeformTags, and definedTags
    # When:  GET
    # Then:  Update compartment with content
    # + compartmentId - ocid of compartment to update
    # + jsonBody - name, description, freeformTags, and definedTags
    # + return - If successful, return OciCompartment, else logs error
    public remote function updateCompartment(string compartmentId, json jsonBody) returns OciCompartment {
        return getCompartment(ociPutRequest(self.ociConfig, self.ociClient, COMPARTMENTS, compartmentId, jsonBody));
    }
};

