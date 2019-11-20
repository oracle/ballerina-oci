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

//import ballerina/io;

# GetUser 
# + response - json User
# + return - OciUser
function getUser(json response) returns OciUser {
    OciUser user = createOciUser();
    OciUser|error ociUser = OciUser.constructFrom(response);
    if (ociUser is OciUser) {
        user = ociUser;
    }
    return user;
}


# ListUsers 
# + response - json User
# + return - list of OciUser
function getListUsers(json response) returns OciUser[] {
    OciUser [] list = [];
    int i = 0;
    int j = 0;
    json user;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        user = responseList[i];
        OciUser|error ociUser = OciUser.constructFrom(user);
        if (ociUser is OciUser) {
            list[j] = ociUser;
            j = j + 1;
        }
        i = i + 1;
     }

    return list;
}


# GetGroups 
# + response - json Group
# + return - OciGroups
function getGroups(json response) returns OciGroups {
    OciGroups groupi = createOciGroup();
    OciGroups|error ociGroup = OciGroups.constructFrom(response);
    if (ociGroup is OciGroups) {
        groupi = ociGroup;
    }
    return groupi;
}


# ListGroups 
# + response - json Group
# + return - list of OciGroups
function getListGroups(json response) returns OciGroups[] {
    OciGroups [] list = [];
    int i = 0;
    int j = 0;
    json groupi;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        groupi = responseList[i];
        OciGroups|error ociGroup = OciGroups.constructFrom(groupi);
        if (ociGroup is OciGroups) {
            list[j] = ociGroup;
            j = j + 1;
        }
        i = i + 1;
    }
    return list;
}


# GetCompartment 
# + response - json Compartment
# + return - OciCompartment
function getCompartment(json response) returns OciCompartment {
    OciCompartment compartment = createOciCompartment();
    OciCompartment|error ociCompartment = OciCompartment.constructFrom(response);
    if (ociCompartment is OciCompartment) {
        compartment = ociCompartment;
    }
    return compartment;
}


# ListCompartments 
# + response - json Compartment
# + return - list of OciCompartment
function getListCompartments(json response) returns OciCompartment[] {
    OciCompartment[] list = [];
    int i = 0;
    int j = 0;
    json compartment;
    boolean inactiveStatusExists;
    boolean isAccessibleExists;
    string[] compartmentKeys;
    json[] responseList = <json[]> response;
    while (i < responseList.length()) {
        compartment = responseList[i];
        OciCompartment|error ociCompartment = OciCompartment.constructFrom(compartment);
        if (ociCompartment is OciCompartment) {
            list[j] = ociCompartment;
            j = j + 1;
        }
        i = i + 1;
    }
    return list;
}
