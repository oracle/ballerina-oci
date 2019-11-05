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

# Define the configurations for OCI connector.
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


# OCI instance
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/Instance/
# + availabilityDomain - AD which instance lives in 
# + compartmentId - compartment OCID
# + definedTags - defined tags
# + displayName - display name
# + faultDomain - which 1 of 3 fault domains 
# + freeformTags - free form tagss
# + id - instance OCID
# + imageId - image[linux/windows/etc.] OCID
# + launchMode - launch mode
# + lifecycleState - life cycle state [START/STOP/etc]
# + region - region [ashburn/etc]
# + shape - shape type
# + timeCreated - time created
public type OciInstance record {
    string availabilityDomain;
    string compartmentId;
    OciDefinedTags definedTags?;
    string displayName;
    // json extendedMetadata;
    string faultDomain;
    OciFreeFormTags freeformTags?;
    string id;
    string imageId;
    // json ipxeScript;
    string launchMode;
    // json launchOptions;
    string lifecycleState;
    // json metadata;
    string region;
    string shape;
    // json sourceDetails;
    string timeCreated;
    // json timeMaintenanceRebootDue;
};


# VCN
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/Vcn/
# + cidrBlock - cidrBlock   
# + compartmentId - compartmentId   
# + defaultDhcpOptionsId - defaultDhcpOptionsId   
# + defaultRouteTableId - defaultRouteTableId   
# + defaultSecurityListId - defaultSecurityListId   
# + displayName - displayName   
# + dnsLabel - dnsLabel
# + id - id   
# + lifecycleState - lifecycleState   
# + timeCreated - timeCreated  
# + vcnDomainName - VCN domain name
public type OciVcn record {
    string cidrBlock;
    string compartmentId;
    string defaultDhcpOptionsId;
    string defaultRouteTableId;
    string defaultSecurityListId;
    string displayName;
    string dnsLabel;
    string id;
    string lifecycleState;
    string timeCreated;
    string vcnDomainName;
};


# RouteTable
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/RouteTable/
# + compartmentId - The OCID of the compartment containing the route table
# + definedTags - Defined tags for this resource
# + displayName - A user-friendly name
# + freeformTags - Free-form tags for this resource
# + id - The route table's Oracle ID (OCID)
# + lifecycleState - The route table's current state 
# + routeRules - The collection of rules for routing destination IPs to network devices
# + timeCreated - The date and time the route table was created, in the format defined by RFC3339
# + vcnId - The OCID of the VCN the route table list belongs to  
public type OciRouteTable record {
    string compartmentId;
    OciDefinedTags definedTags?;
    string displayName;
    OciFreeFormTags freeformTags?;
    string id;
    string lifecycleState;
    OciRouteRule[] routeRules;
    string timeCreated;
    string vcnId;
};


# RouteRule
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/RouteRule
# + cidrBlock - optional cidrBlock
# + destination - Conceptually, this is the range of IP addresses used for matching when routing traffic   
# + destinationType - Type of destination for the rule   
# + networkEntityId - The OCID for the route rule's target  
public type OciRouteRule record {
    string cidrBlock?;
    string destination?;
    string destinationType?;
    string networkEntityId;
};


# ServiceGateway
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/ServiceGateway/
# + blockTraffic - whether the service gateway blocks all traffic through it
# + compartmentId -  OCID of the compartment that contains the service gateway
# + definedTags - defined tags
# + displayName - user-friendly name
# + freeformTags - free-form tags
# + id - OCID of the service gateway
# + lifecycleState - service gateway's current state
# + routeTableId - OCID of the route table the service gateway is using
# + services - list of the OCI services enabled for this service gateway
# + timeCreated - date and time the service gateway was created
# + vcnId - OCID of the VCN the service gateway belongs to
public type OciServiceGateway record {
    boolean blockTraffic;
    string compartmentId;
    json definedTags?;
    //OciDefinedTags definedTags?;
    string displayName;
    json freeformTags?;
    //OciFreeFormTags freeformTags?;
    string id;
    string lifecycleState;
    string routeTableId?;
    OciServiceIdResponseDetails[] services;
    string timeCreated?;
    string vcnId;
};


# ServiceIdResponseDetails
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/ServiceIdResponseDetails
# + serviceId - OCID of the service
# + serviceName - name of the service
public type OciServiceIdResponseDetails record {
    string serviceId;
    string serviceName;
};


# Service
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/Service/
# + cidrBlock - the regional public IP address ranges for the Oracle service or services covered
# + description - description of the Oracle service or services covered
# + id - OCID of the service
# + name - name of the service
public type OciService record {
    string cidrBlock;
    string description;
    string id;
    string name;
};


# SecurityList
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/SecurityList/
# + compartmentId - The OCID of the compartment containing the security list  
# + definedTags - optional Defined tags for this resource
# + displayName - A user-friendly name
# + egressSecurityRules - Rules for allowing egress IP packets
# + freeformTags - optional Free-form tags for this resource
# + id - The security list's Oracle Cloud ID (OCID)
# + ingressSecurityRules - Rules for allowing ingress IP packets
# + lifecycleState - The security list's current state  
# + timeCreated - The date and time the security list was created, in the format defined by RFC3339  
# + vcnId - The OCID of the VCN the security list belongs to  
public type OciSecurityList record {
    string compartmentId;
    OciDefinedTags definedTags?;
    string displayName;
    OciEgressSecurityRule[] egressSecurityRules;
    OciFreeFormTags freeformTags?;
    string id;
    OciIngressSecurityRule[] ingressSecurityRules;
    string lifecycleState;
    string timeCreated;
    string vcnId;
};


# EgressSecurityRule
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/EgressSecurityRule
# + destination - Conceptually, this is the range of IP addresses that a packet originating from the instance can go to  
# + destinationType - optional Type of destination for the rule. The default is CIDR_BLOCK
// # + icmpOptions - optional Optional and valid only for ICMP and ICMPv6
# + isStateless - optional A stateless rule allows traffic in one direction
# + protocol - The transport protocol  
// # + tcpOptions - Optional and valid only for TCP
// # + udpOptions - Optional and valid only for UDP
public type OciEgressSecurityRule record {
    string destination;
    string destinationType?;
    // leave the below commented as we will use it in future versions
    //OCiIcmpOptions[] icmpOptions?;
    boolean isStateless?;
    string protocol;
    //OciTcpOptions[] tcpOptions?;
    //OciUdpOptions[] udpOptions?;
};


# IngressSecurityRule
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/IngressSecurityRule
// # + icmpOptions - optional array of icmpOptions
// # + isStateless - optional isStateless parameter
// # + protocol - protocol  
// # + source - source  
// # + sourceType - optional sourceType
// # + tcpOptions - optional array of tcpOptions
// # + udpOptions - optional array of udpOptions
public type OciIngressSecurityRule record {
    // OCiIcmpOptions[] icmpOptions?;
    // boolean isStateless?;
    // string protocol;
    // string source;
    // string sourceType?;
    // OciTcpOptions[] tcpOptions?;
    // OciUdpOptions[] udpOptions?;
};


# IcmpOptions
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/IcmpOptions
# + code - optional ICMP code 
# + icmpType - The icmp Type  
public type OCiIcmpOptions record {
    int code?;
    int icmpType;
};


# TcpOptions
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/TcpOptions
# + destinationPortRange - optional inclusive range of allowed destination ports
# + sourcePortRange - optional inclusive range of allowed source ports
public type OciTcpOptions record {
    OciPortRange destinationPortRange?;
    OciPortRange sourcePortRange?;
};


# UdpOptions
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/UdpOptions
# + destinationPortRange - optional destination port range
# + sourcePortRange - optional source port range
public type OciUdpOptions record {
    OciPortRange destinationPortRange?;
    OciPortRange sourcePortRange?;
};


# PortRange
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/PortRange
# + max - maximum port number
# + min - minimum port number  
public type OciPortRange record {
    int max;
    int min;
};


# Subnet
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/Subnet/
# + availabilityDomain - The subnet's availability domain   
# + cidrBlock - The subnet's CIDR block   
# + compartmentId - The OCID of the compartment containing the subnet   
# + definedTags - Defined tags for this resource   
# + dhcpOptionsId - The OCID of the set of DHCP options that the subnet uses   
# + displayName - A user-friendly name   
# + dnsLabel - A DNS label for the subnet, used in conjunction with the VNIC's hostname and VCN's DNS label to form a fully qualified 
#              domain name (FQDN) for each VNIC within this subnet (for example, bminstance-1.subnet123.vcn1.oraclevcn.com)   
# + freeformTags - Free-form tags for this resource   
# + id - The subnet's Oracle ID (OCID)
# + ipv6CidrBlock - For an IPv6-enabled subnet, this is the IPv6 CIDR block for the subnet's private IP address space 
# + ipv6PublicCidrBlock - For an IPv6-enabled subnet, this is the IPv6 CIDR block for the subnet's public IP address space
# + ipv6VirtualRouterIp - For an IPv6-enabled subnet, this is the IPv6 address of the virtual router   
# + lifecycleState - The subnet's current state   
# + prohibitPublicIpOnVnic - Whether VNICs within this subnet can have public IP addresses   
# + routeTableId - The OCID of the route table that the subnet uses   
# + securityListIds - The OCIDs of the security list or lists that the subnet uses   
# subnetDomainName - The subnet's domain name, which consists of the subnet's DNS label, the VCN's DNS label, and the oraclevcn.com domain   
# + timeCreated - The date and time the subnet was created, in the format defined by RFC3339   
# + vcnId - The OCID of the VCN the subnet is in   
# + virtualRouterIp - The IP address of the virtual router   
# + virtualRouterMac - The MAC address of the virtual router  
public type OciSubnet record{
    string availabilityDomain;
    string cidrBlock;
    string compartmentId;
    OciDefinedTags definedTags?;
    string dhcpOptionsId;
    string displayName;
    string dnsLabel?;
    OciFreeFormTags freeformTags?;
    string id;
    string ipv6CidrBlock?;
    string ipv6PublicCidrBlock?;
    string ipv6VirtualRouterIp?;
    string lifecycleState;
    boolean prohibitPublicIpOnVnic;
    string routeTableId;
    string[] securityListIds;
    //string subnetDomainName?;
    string timeCreated;
    string vcnId;
    string virtualRouterIp;
    string virtualRouterMac;
};


# DefinedTags
# Mapped key value pair string typed rest field that holds all additional fields
public type OciDefinedTags record {|
    map<string>...;
|};


# FreeFormTags
# Mapped key value pair string typed rest field that holds all additional fields
public type OciFreeFormTags record {|
    map<string>...;
|};


# InternetGateway
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/InternetGateway/
# + compartmentId - The OCID of the compartment containing the internet gateway   
# + definedTags - Defined tags for this resource
# + displayName - A user-friendly name   
# + freeformTags - Free-form tags for this resource
# + id - The internet gateway's Oracle ID (OCID)   
# + isEnabled - Whether the gateway is enabled   
# + lifecycleState - The internet gateway's current state   
# + timeCreated - The date and time the internet gateway was created, in the format defined by RFC3339
# + vcnId - The OCID of the VCN the internet gateway belongs to  
public type OciInternetGateway record {
    string compartmentId;
    json definedTags;
    string displayName;
    json freeformTags;
    string id;
    boolean isEnabled;
    string lifecycleState;
    string timeCreated;
    string vcnId;
};


# NatGateway
# https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/NatGateway/
# + compartmentId - The OCID of the compartment that contains the NAT gateway   
# + definedTags - Defined tags for this resource
# + displayName - A user-friendly name   
# + freeformTags - Free-form tags for this resource
# + id - The OCID of the NAT gateway   
# + blockTraffic - Whether the NAT gateway blocks traffic through it. The default is false   
# + lifecycleState - The NAT gateway's current state   
# + natIp - The IP address associated with the NAT gateway   
# + timeCreated - The date and time the NAT gateway was created, in the format defined by RFC3339
# + vcnId - The OCID of the VCN the NAT gateway belongs to  
public type OciNatGateway record {
    string compartmentId;
    json definedTags;
    string displayName;
    json freeformTags;
    string id;
    boolean blockTraffic;
    string lifecycleState;
    string natIp;
    string timeCreated;
    string vcnId;
};