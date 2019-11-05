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

    # Given: Instance requirements in json body { Compartment Id - Availability Domain - Display Name - Shape - Image Id - Subnet Id }
    # When:  GET 
    # Then:  Launch and return instance within compartment
    # + instanceId - OCID of instance
    # + return - If successful, returns an OCI Instance, else logs the error
    public remote function getInstance(string instanceId) returns OciInstance {
        return getInstance(ociGetRequest(self.ociConfig, self.ociClient, INSTANCES, instanceId, {}));
    }

    # Given: Instance Id and new instance action[START/STOP/SOFTRESET/SOFTSTOP/RESET]
    # When:  POST 
    # Then:  Update and return instance to new status
    # + instanceId - OCID of instance
    # + instanceAction - constant string for updated instance status
    # + return - If successful, returns an OCI Instance, else logs the error
    public remote function instanceAction(string instanceId, string instanceAction) returns OciInstance {
        return getInstance(ociPostRequest(self.ociConfig, self.ociClient, INSTANCES, 
                            instanceId, instanceAction, {}));
    }

    # Given: Compartment ID and instance creation details
    # When:  POST 
    # Then:  Launches and returns instance with specific requirements
    # + jsonBody - create instance: availabilityDomain, compartmentId, createVnicDetails, definedTags, displayName, 
    #                               extendedMetadata, faultDomain, freeformTags, hostnameLabel, imageId, ipxeScript, 
    #                               metadata, shape, sourceDetails, subnetId, isPvEncryptionInTransitEnabled
    # + return - If successful, returns an OCI Instance, else logs the error
    public remote function launchInstance(json jsonBody) returns OciInstance {
        return getInstance(ociPostRequest(self.ociConfig, self.ociClient, INSTANCES, 
                            "", "", jsonBody));
    }
 
    # Given: Dictionary of query items
    #   Required: compartmentId 
    #   Optional: availabilityDomain, displayName, limit, page, sortBy, sortOrder, lifecycleState
    # When:  GET 
    # Then:  Return list of instances that match query.
    # + queries - Map of query strings for filtering list of instances
    # + return - If successful, returns OciInstance[] with zero or more instances, else logs the error
    public remote function listInstances(map<string> queries) returns OciInstance[] {
        return getListInstances(ociGetRequest(self.ociConfig, self.ociClient, INSTANCES, "", queries));
    }

    # Given: Instance Id.
    # When:  DELETE 
    # Then:  Terminate instance with instance id
    # + instanceId - OCID of instance
    public remote function terminateInstance(string instanceId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, INSTANCES, instanceId);
    }

    # Given: Instance Id and json for updated instance information
    # When:  PUT 
    # Then:  Update and return instance with updated information
    # + instanceId - OCID of instance
    # + jsonBody - change instance: definedTags, displayName, freeformTags, metadata, extendedMetadata
    # + return - If successful, returns an OCI Instance, else logs the error
    public remote function updateInstance(string instanceId, json jsonBody) returns OciInstance {
        return getInstance(ociPutRequest(self.ociConfig, self.ociClient, INSTANCES, 
                            instanceId, jsonBody));

    }

    # Given: Json body with cidrBlock, compartmentId and displayName
    # When:  POST 
    # Then:  Create and return vcn with cidr block and display name.
    # + jsonBody - cidrBlock: IPv4 CIDR blck, compartmentId, displayName
    # + return - If successful, returns an OCI VCN, else logs the error
    public remote function createVcn(json jsonBody) returns OciVcn {
        return getVcn(ociPostRequest(self.ociConfig, self.ociClient, VCNS, "", "", jsonBody));
    }

    # Given: VCN ID
    # When:  DELETE 
    # Then:  Delete VCN with given vcn id
    # + vcnId - VCN id
    public remote function deleteVcn(string vcnId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, VCNS, vcnId);
    }

    # Given: VCN ID
    # When:  GET 
    # Then:  Returns VCN with given vcn id
    # + vcnId - OCID of vcn
    # + return - If successful, returns an OCI VCN, else logs the error
    public remote function getVcn(string vcnId) returns OciVcn {
        return getVcn(ociGetRequest(self.ociConfig, self.ociClient, VCNS, vcnId, {}));
    }

    # Given: Dictionary of query items
    #   Required: compartmentId 
    #   Optional: limit, page, displayName, sortBy, sortOrder, lifecycleState
    # When:  GET 
    # Then:  Return list of vcns that match query
    # + queries - Map of query strings for filtering list of instances
    # + return - If successful, returns OciVcn[] with zero or more VCNs, else logs the error
    public remote function listVcns(map<string> queries) returns OciVcn[] {
        return getListVcns(ociGetRequest(self.ociConfig, self.ociClient, VCNS, "", queries));
    }

    # Given: Instance Id and json body for updated instance information.
    # When:  PUT 
    # Then:  Update and return vcn with updated information
    # + vcnId - OCID of vcn
    # + jsonBody - body updating VCN: definedTags, displayName, freeFormTags
    # + return - If successful, returns an OCI VCN, else logs the error
    public remote function updateVcn(string vcnId, json jsonBody) returns OciVcn {
        return getVcn(ociPutRequest(self.ociConfig, self.ociClient, VCNS, vcnId, jsonBody));
    }

    # Given: Route Table ID
    # When:  GET
    # Then:  Returns Route Table with given rtId
    # + rtId - route table ID
    # + return - If succesful, returns an OCI Route Table, else logs the error
    public remote function getRouteTable(string rtId) returns OciRouteTable {
        return getRouteTable(ociGetRequest(self.ociConfig, self.ociClient, ROUTE_TABLES, rtId, {}));
    }

    # Given: Json body with displayName, vcnId, RouteRules[Cidr block and network identity OCID] and compartmentId
    # When:  POST 
    # Then:  Create and return route table
    # + jsonBody - cidrBlock, displayName, vcnId, routeRules, compartmentId
    # + return - If successful, returns an OCI Route Table, else logs the error
    public remote function createRouteTable(json jsonBody) returns OciRouteTable {
        return getRouteTable(ociPostRequest(self.ociConfig, self.ociClient, ROUTE_TABLES, "", "", jsonBody));
    }

    # Given: Route Table ID
    # When:  DELETE 
    # Then:  Delete Route Table with given rtId
    # + rtId - route table ID
    public remote function deleteRouteTable(string rtId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, ROUTE_TABLES, rtId);
    }

    # Given: Dictionary of query items
    #   Required: compartmentId, vcnId
    #   Optional: limit, page, displayName, sortBy, sortOrder, lifecycleState
    # When:  GET 
    # Then:  Return list of route tables that match query
    # + queries - Map of query strings for filtering list of route tables
    # + return - If successful, returns OciRouteTable[] with zero or more RouteTables, else logs the error
    public remote function listRouteTables(map<string> queries) returns OciRouteTable[] {
        return getListRouteTables(ociGetRequest(self.ociConfig, self.ociClient, ROUTE_TABLES, "", queries));
    }

    # Given: Route Table Id and json body for updated route table information.
    # When:  PUT 
    # Then:  Update and return route table with updated information
    # + rtId - OCID of route table
    # + jsonBody - body updating Route Table: displayName, routeRules
    # + return - If successful, returns an OCI Route Table, else logs the error
    public remote function updateRouteTable(string rtId, json jsonBody) returns OciRouteTable {
        return getRouteTable(ociPutRequest(self.ociConfig, self.ociClient, ROUTE_TABLES, rtId, jsonBody));
    }

    # Given: None
    # When:  GET
    # Then: Return list of OCI services in the region
    # + return - If successful, returns a list of OCI services, else logs the error
    public remote function listServices() returns OciService[] {
        return getListServices(ociGetRequest(self.ociConfig, self.ociClient, SERVICE, "", {}));
    }

    # Given: Dictionary of queries
    #   Required: compartmentId
    #   Optional: vcnId, limit, page, sortBy, sortOrder, lifecycleState
    # When:  GET
    # Then: Return list of OCI service gateways in compartment
    # + queries - map of queries
    # + return - If successful, returns a list of OCI service gateways, else logs the error
    public remote function listServiceGateways(map<string> queries) returns OciServiceGateway[] {
        return getListServiceGateways(ociGetRequest(self.ociConfig, self.ociClient, SERVICE_GATEWAY, "", queries));
    }

    # Given: service gateway id
    # When:  GET
    # Then: Return specified OCI service gateway
    # + sGId - service gateway id
    # + return - If successful, returns particular OCI service gateway, else logs the error
    public remote function getServiceGateway(string sGId) returns OciServiceGateway {
        return getServiceGateway(ociGetRequest(self.ociConfig, self.ociClient, SERVICE_GATEWAY, sGId, {}));
    }

    # Given: create service gateway details
    #   Required: compartmentId, services, vcnId
    #   Optional: definedTags, displayName, freeformTags, routeTableId
    # When:  POST
    # Then: Create specified OCI service gateway
    # + jsonBody - body for creating SG
    # + return - If successful, returns created OCI service gateway, else logs the error
    public remote function createServiceGateway(json jsonBody) returns OciServiceGateway {
        return getServiceGateway(ociPostRequest(self.ociConfig, self.ociClient, SERVICE_GATEWAY, "", "", jsonBody));
    }

    # Given: service gateway id
    # When:  DELETE
    # Then: Delete specified OCI service gateway
    # + sGId - service gateway id
    public remote function deleteServiceGateway(string sGId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, SERVICE_GATEWAY, sGId);
    }

    # Given: service gateway id and update service gateway details
    #   Optional: blockTraffic, definedTags, displayName, freeformTags, routeTableId, services
    # When:  PUT
    # Then: Update specified OCI service gateway
    # + sGId - service gateway id
    # + jsonBody - body for updating SG
    # + return - If successful, returns updated OCI service gateway, else logs the error
    public remote function updateServiceGateway(string sGId, json jsonBody) returns OciServiceGateway {
        return getServiceGateway(ociPutRequest(self.ociConfig, self.ociClient, SERVICE_GATEWAY, sGId, jsonBody));
    }

    # Given: service gateway id and change service gateway compartment details
    #   Required: compartmentId
    # When:  POST
    # Then: Change specified OCI service gateway's compartment
    # + sGId - service gateway id
    # + jsonBody - body for changing SG's compartment
    public remote function changeServiceGatewayCompartment(string sGId, json jsonBody) {
        string res_str = SERVICE_GATEWAY + "/" + sGId + "/" + ACTIONS + "/" + CHANGE_COMPARTMENT;
        json response = ociPostRequest(self.ociConfig, self.ociClient, res_str, "", "", jsonBody);
    }

    # Given: service gateway id and attach service id request details
    #   Required: serviceId
    # When:  POST
    # Then: Attach service to specified OCI service gateway
    # + sGId - service gateway id
    # + jsonBody - body for attaching service to SG
    # + return - If successful, returns changed OCI service gateway, else logs the error
    public remote function attachServiceId(string sGId, json jsonBody) returns OciServiceGateway{
        string res_str = SERVICE_GATEWAY + "/" + sGId + "/" + ACTIONS + "/" + ATTACH_SERVICE;
        return getServiceGateway(ociPostRequest(self.ociConfig, self.ociClient, res_str, "", "", jsonBody));
    }
    
    # Given: service gateway id and detach service id request details
    #   Required: serviceId
    # When:  POST
    # Then: Detach service from specified OCI service gateway
    # + sGId - service gateway id
    # + jsonBody - body for detaching service from SG
    # + return - If successful, returns changed OCI service gateway, else logs the error
    public remote function detachServiceId(string sGId, json jsonBody) returns OciServiceGateway {
        string res_str = SERVICE_GATEWAY + "/" + sGId + "/" + ACTIONS + "/" + DETACH_SERVICE;
        return getServiceGateway(ociPostRequest(self.ociConfig, self.ociClient, res_str, "", "", jsonBody));
    }

    # Given: Internet Gateway requirements in json body { InternetGateway Id }
    # When:  GET 
    # Then:  Return internet gateway details.
    # + igId - OCID of internet gateway
    # + return - If successful, returns an OCI internet gateway, else logs the error
    public remote function getInternetGateway(string igId) returns OciInternetGateway {
        return getInternetGateway(ociGetRequest(self.ociConfig, self.ociClient, INTERNET_GATEWAYS, igId, {}));
    }

    # Given: Dictionary of query items
    #   Required: compartmentId, vcnId 
    #   Optional: displayName, limit, page, sortBy, sortOrder, lifecycleState
    # When:  GET 
    # Then:  Return list of internet gateways that match query.
    # + queries - Map of query strings for filtering list of internet gateways
    # + return - If successful, returns OciInternetGateway[] with zero or more internet gateways, else logs the error
    public remote function listInternetGateways(map<string> queries) returns OciInternetGateway[] {
        return getListInternetGateways(ociGetRequest(self.ociConfig, self.ociClient, INTERNET_GATEWAYS, "", queries));
    }

    # Given: InternetGateway Id.
    # When:  DELETE 
    # Then:  Terminate internet gateway with internet gateway id.
    # + igId - OCID of internet gateway
    public remote function deleteInternetGateway(string igId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, INTERNET_GATEWAYS, igId);
    }

    # Given: Nat Gateway Id and json for updated nat gateway information.
    # When:  PUT 
    # Then:  Update and return nat gateway with updated information.
    # + IgId - OCID of nat gateway
    # + jsonBody - change nat gateway: definedTags, displayName, freeformTags, isEnabled
    # + return - If successful, returns an OCI nat gateway, else logs the error
    public remote function updateInternetGateway(string IgId, json jsonBody) returns OciInternetGateway {
        return getInternetGateway(ociPutRequest(self.ociConfig, self.ociClient, INTERNET_GATEWAYS, IgId, jsonBody));

    }

    # Given: Json body with displayName, compartmentId, isEnabled and vcnId
    # When:  POST 
    # Then:  Create and return internet gateway with displayName, isEnabled and vcnId.
    # + jsonBody - compartmentId, displayName, vcnId, isEnabled
    # + return - If successful, returns an OCI Internet Gateway, else logs the error
    public remote function createInternetGateway(json jsonBody) returns OciInternetGateway{
        return getInternetGateway(ociPostRequest(self.ociConfig, self.ociClient, INTERNET_GATEWAYS, "", "", jsonBody));
    }

    # Given: Nat Gateway requirements in json body { NatGateway Id }
    # When:  GET 
    # Then:  Return Nat gateway details.
    # + natGatewayId - OCID of Nat gateway
    # + return - If successful, returns an OCI nat gateway, else logs the error
    public remote function getNatGateway(string natGatewayId) returns OciNatGateway {
        return getNatGateway(ociGetRequest(self.ociConfig, self.ociClient, NAT_GATEWAYS, natGatewayId, {}));
    }
    
    # Given: Dictionary of query items
    #   Required: compartmentId, vcnId 
    #   Optional: displayName, limit, page, sortBy, sortOrder, lifecycleState
    # When:  GET 
    # Then:  Return list of nat gateways that match query.
    # + queries - Map of query strings for filtering list of nat gateways
    # + return - If successful, returns OciNatGateway[] with zero or more nat gateways, else logs the error
    public remote function listNatGateways(map<string> queries) returns OciNatGateway[] {
        return getListNatGateways(ociGetRequest(self.ociConfig, self.ociClient, NAT_GATEWAYS, "", queries));
    }
    
    # Given: NatGateway Id.
    # When:  DELETE 
    # Then:  Terminate nat gateway with nat gateway id.
    # + natGatewayId - OCID of nat gateway
    public remote function deleteNatGateway(string natGatewayId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, NAT_GATEWAYS, natGatewayId);
    }

    # Given: Nat Gateway Id and json for updated nat gateway information.
    # When:  PUT 
    # Then:  Update and return nat gateway with updated information.
    # + natGatewayId - OCID of nat gateway
    # + jsonBody - change nat gateway: definedTags, displayName, freeformTags, isEnabled
    # + return - If successful, returns an OCI nat gateway, else logs the error
    public remote function updateNatGateway(string natGatewayId, json jsonBody) returns OciNatGateway {
        return getNatGateway(ociPutRequest(self.ociConfig, self.ociClient, NAT_GATEWAYS, natGatewayId, jsonBody));

    }

    # Given: Json body with displayName, compartmentId, isEnabled and vcnId
    # When:  POST 
    # Then:  Create and return nat gateway with displayName, isEnabled and vcnId.
    # + jsonBody - compartmentId, displayName, vcnId, isEnabled
    # + return - If successful, returns an OCI Nat Gateway, else logs the error
    public remote function createNatGateway(json jsonBody) returns OciNatGateway{
        return getNatGateway(ociPostRequest(self.ociConfig, self.ociClient, NAT_GATEWAYS, "", "", jsonBody));
    }

    # Given: Security List ID
    # When:  GET
    # Then:  Returns Security List with given slId
    # + securityListId - security list ID
    # + return - If succesful, returns an OCI Security List, else logs the error
    public remote function getSecurityList(string securityListId) returns OciSecurityList {
        return getSecurityList(ociGetRequest(self.ociConfig, self.ociClient, SECURITY_LISTS, securityListId, {}));
    }

    # Given: Json body with compartmentId, displayName, egressSecurityRules[destination, protocol], ingressSecurityRules[], vcnId
    # When:  POST 
    # Then:  Create and return security list
    # + jsonBody - compartmentId, displayName, egressSecurityRules, ingressSecurityRules, vcnId
    # + return - If successful, returns an OCI Security List, else logs the error
    public remote function createSecurityList(json jsonBody) returns OciSecurityList {
        return getSecurityList(ociPostRequest(self.ociConfig, self.ociClient, SECURITY_LISTS, "", "", jsonBody));
    }

    # Given: Security List ID
    # When:  DELETE 
    # Then:  Delete Security List with given slId
    # + securityListId - security list ID
    public remote function deleteSecurityList(string securityListId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, SECURITY_LISTS, securityListId);
    }

    # Given: Dictionary of query items
    #   Required: compartmentId, vcnId
    #   Optional: limit, page, displayName, sortBy, sortOrder, lifecycleState
    # When:  GET 
    # Then:  Return list of security lists that match query
    # + queries - Map of query strings for filtering list of security lists
    # + return - If successful, returns OciSecurityList[] with zero or more SecurityLists, else logs the error
    public remote function listSecurityList(map<string> queries) returns OciSecurityList[] {
        return getListSecurityLists(ociGetRequest(self.ociConfig, self.ociClient, SECURITY_LISTS, "", queries));
    }

    # Given: Security List Id and json body for updated security list information
    # When:  PUT 
    # Then:  Update and return security list with updated information
    # + securityListId - OCID of security list
    # + jsonBody - body updating Security List: displayName, egressSecurityRules
    # + return - If successful, returns an OCI Security List, else logs the error
    public remote function updateSecurityList(string securityListId, json jsonBody) returns OciSecurityList {
        return getSecurityList(ociPutRequest(self.ociConfig, self.ociClient, SECURITY_LISTS, securityListId, jsonBody));
    }

    # Given: Json body with displayName, cidrBlock, availabilityDomain, routeTableId, list of security list OCIDS,
    #        dhcpOptionsId, vcnId and compartmentId
    # When:  POST 
    # Then:  Create and return subnet.
    # + jsonBody - displayName, cidrBlock, availabilityDomain, routeTableId, list of security list OCIDS
    #              dhcpOptionsId, vcnId, compartmentId
    # + return - If successful, returns an OCI Subnet, else logs the error
    public remote function createSubnet(json jsonBody) returns OciSubnet {
        return getSubnet(ociPostRequest(self.ociConfig, self.ociClient, SUBNETS, "", "", jsonBody));
    }

    # Given: Subnet ID
    # When:  DELETE 
    # Then:  Delete subnet with given subnetId
    # + subnetId - subnet ID
    public remote function deleteSubnet(string subnetId) {
        ociDeleteRequest(self.ociConfig, self.ociClient, SUBNETS, subnetId);
    }

    # Given: Subnet Id
    # When:  GET
    # Then:  Return subnet with given subnet id
    # + subnetId - subnet ID
    # + return - If successful, returns an OCI Subnet, else logs the error
    public remote function getSubnet(string subnetId) returns OciSubnet {
        return getSubnet(ociGetRequest(self.ociConfig, self.ociClient, SUBNETS, subnetId, {}));
    }

    # Then:  Return list of subnets that match query.
    # + queries - Map of query strings for filtering list of route tables
    # + return - If successful, returns OciSubnet[] with zero or more subnets, else logs the error
    public remote function listSubnets(map<string> queries) returns OciSubnet[] {
        return getListSubnets(ociGetRequest(self.ociConfig, self.ociClient, SUBNETS, "", queries));
    }

    # Given: Subnet Id and json body for updated subnet information.
    # When:  PUT 
    # Then:  Update and return route table with updated information.
    # + subnetId - OCID of subnet
    # + jsonBody - body updating Subnet: definedTags, dhcpOptionsId, displayName, freeformTags,
    #                                    routeTableId, securityListIds[]
    # + return - If successful, returns an OCI Subnet, else logs the error
    public remote function updateSubnet(string subnetId, json jsonBody) returns OciSubnet {
        return getSubnet(ociPutRequest(self.ociConfig, self.ociClient, SUBNETS, subnetId, jsonBody));
    }
};