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

# Define the configurations for OCI connector
# + host - The OCI home region url
# + tenancyId - The tenancy OCID
# + authUserId - The user OCID
# + keyFingerprint - The user fingerprint
# + pathToKey - The full path to the private key
# + keyStorePassword - The keystore password
# + keyAlias - The name of the key
# + keyPassword - The key password
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
    http:ClientConfiguration clientConfig = {};
};


# User
# https://docs.cloud.oracle.com/iaas/api/#/en/identity/20160918/User/
# + id - The OCID of the user
# + compartmentId - The OCID of the tenancy containing the user
# + name - The name you assign to the user during creation
# + description - The description you assign to the user
# + timeCreated - Date and time the user was created, in the format defined by RFC3339
# + lifecycleState - The user's current state
# + isMfaActivated - Flag indicates if MFA has been activated for the user
public type OciUser record {
    string id;
    string compartmentId;
    // json definedTags;
    string name;
    // json extendedMetadata;
    string description;
    // json freeformTags;
    //string email;
    // string identityProviderId;
    // json ipxeScript;
    // string externalIdentifier;
    // json launchOptions;
    string timeCreated;
    // json metadata;
    string lifecycleState;
    //int inactiveStatus;
    // json sourceDetails;
    //json capabilities;
    // json timeMaintenanceRebootDue;
    boolean isMfaActivated;
};


# Group
# https://docs.cloud.oracle.com/iaas/api/#/en/identity/20160918/Group/
# + id - The OCID of the group
# + compartmentId - The OCID of the tenancy containing the group
# + name - The name you assign to the group during creation
# + description - The description you assign to the group
public type OciGroups record {
    string id;
    string compartmentId;
    string name;
    string description;
// string timeCreated;
// string lifecycleState;
// string inactiveStatus;
// string capabilities;
};


# Compartment
# https://docs.cloud.oracle.com/iaas/api/#/en/identity/20160918/Compartment/
# + id - ocid of compartment
# + compartmentId - ocid of parent compartment
# + name - assigned name of compartment
# + description - describes compartment
# + timeCreated - date and time created in RFC3339
# + lifecycleState - current state; possible values: [CREATING, ACTIVE, INACTIVE, DELETING, DELETED]
# + inactiveStatus - detailed status of INACTIVE lifecycleState
# + isAccessible - whether the requesting user can access, returns true when user has INSPECT permissions directly on resource in compartment or indirectly
# + freeformTags - free-form tags for this resource
# + definedTags - defined tags for this resource
public type OciCompartment record {
    string id;
    string compartmentId;
    string name;
    string description;
    string timeCreated;
    string lifecycleState;
    int inactiveStatus?;
    boolean isAccessible?;
    // OciFreeFormTags freeformTags?;
    json freeformTags?;
    // OciDefinedTags definedTags?;
    json definedTags?;
};


// # Mapped key value pair string typed rest field that holds all additional fields
// public type OciDefinedTags record {
//     map<string>...;
// };


// # Mapped key value pair string typed rest field that holds all additional fields
// public type OciFreeFormTags record {
//     map<string>...;
// };
