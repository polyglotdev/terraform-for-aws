# Terraform for AWS

## What is Terraform?

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It allows users to define and provision data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

## What us Infrastructure as Code?

Infrastructure as code (IaC) is the process of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

## Check on Learning - Why do we need a VPC?

When deploying an EC2 instance in AWS, placing it within a subnet is crucial for several reasons related to networking, security, and resource management within a Virtual Private Cloud (VPC). Here's a breakdown of why a subnet is necessary:

1. **Network Partitioning and Organization**

- Subnetting allows you to divide a large network (your VPC) into smaller, manageable networks (subnets). This is useful for organizing and managing resources logically based on patterns of use, security requirements, or compliance needs.
- Each subnet can be configured to handle a specific type of workload or to service a particular department or application, enhancing organizational clarity and control.
2. **IP Address Management**
- Subnets enable effective management of IP address ranges within a VPC. When you create a subnet, you assign it a specific CIDR block, which is a subset of the VPC’s CIDR block. This determines how many IP addresses are available for resources within that subnet.
- Managing IP addresses efficiently helps in optimizing network architectures, ensuring that resources are appropriately grouped and that address space is utilized effectively.
3.** Control of Network Traffic**
- Network traffic control is facilitated through subnets in conjunction with route tables, network access control lists (NACLs), and security groups. This control is crucial for directing traffic flow securely and efficiently across your AWS environment.
- Each subnet can be associated with a route table that specifies the allowed routes for inbound and outbound traffic. Subnets can be designed to route traffic directly to the Internet using an Internet Gateway, or they can be isolated for internal use only.
3. **Security and Isolation**
- Subnets provide a layer of security by segregating parts of your network and limiting access to and from other parts of the network. For example, you can have a public subnet for servers that need to be accessible from the Internet and private subnets for backend systems like databases or application servers that should not be directly accessible from the Internet.
- Security groups and NACLs can be applied specifically to subnets to enforce security policies at the subnet level, providing granular security controls.
4. **Availability and High Availability**
- Subnets can be created in different Availability Zones (AZs) within a region. This means you can deploy EC2 instances across multiple AZs to ensure high availability and fault tolerance. If one AZ goes down, your application can continue running from instances in another AZ.
- By strategically placing instances in different subnets across AZs, you can design resilient and highly available architectures that are robust against a range of failure scenarios, including data center failures.
5. **Regulatory Compliance**
- For compliance with various regulations, it might be necessary to ensure that data does not leave a geographic region or is handled within certain controlled network segments. Subnets help in enforcing compliance by physically and logically isolating resources as required by such regulations.