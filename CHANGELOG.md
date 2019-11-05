# CHANGELOG

*Copyright © 2019 Oracle and/or its affiliates. All rights reserved.*

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)

## 0.1.0 - 2019-11-05 Initial Release

Support for Ballerina 1.0.1

### Added

Module Core
- Support for Core services
    
    Instance
        - GetInstance
        - InstanceAction
        - LaunchInstance
        - ListInstances
        - TerminateInstance
        - UpdateInstance
    
    VCN
        - CreateVcn
        - DeleteVcn
        - GetVcn
        - ListVcns
        - UpdateVcn

    RouteTable
        - CreateRouteTable
        - DeleteRouteTable
        - GetRouteTable
        - ListRouteTables
        - UpdateRouteTable

    ServiceGateway
        - ListServices
        - CreateServiceGateway
        - DeleteServiceGateway
        - GetServiceGateway
        - ListServiceGateway
        - UpdateServiceGateway
        - ChangeServiceGatewayCompartment
        - AttachServiceId
        - DetachServiceId

    InternetGateway
        - CreateInternetGateway
        - DeleteInternetGateway
        - GetInternetGateway
        - ListInternetGateway
        - UpdateInternetGateway

    NatGateway
        - CreateNatGateway
        - DeleteNatGateway
        - GetNatGateway
        - ListNatGateway
        - UpdateNatGateway

    SecurityList
        - CreateSecurityList
        - DeleteSecurityList
        - GetSecurityList
        - ListSecurityList
        - UpdateSecurityList

    Subnet
        - CreateSubnet
        - DeleteSubnet
        - GetSubnet
        - ListSubnet
        - UpdateSubnet


Module IAM
- Support for Identity and Access Management services
    
    User
        - CreateUser
        - DeleteUser
        - GetUser
        - ListUser
        - UpdateUser

    Group
        - CreateGroup
        - DeleteGroup
        - GetGroup
        - ListGroup
        - UpdateGroup

    Compartment
        - CreateCompartment
        - DeleteCompartment
        - GetCompartment
        - ListCompartment
        - UpdateCompartment


Module Object Storage
- Support for Object Storage services

    Bucket
        - CreateBucket
        - DeleteBucket
        - GetBucket
        - ListBucket

    Object
        - CreateObject
        - DeleteObject
        - GetObject
        - ListObject
