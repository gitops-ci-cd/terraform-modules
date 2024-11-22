# Public Cluster

This module creates a public Kubernetes cluster in AWS using EKS. The cluster is designed to be accessible from the public internet, with public-facing load balancers and other resources.

The following diagram illustrates the resources created by this module, and how they interact with one another

```mermaid
flowchart TB
    user[User]
    dns[DNS Record]
    internet[Internet]

    subgraph Hosted Zone
       dns
    end

    user --> dns
    dns --> igw

    subgraph VPC
        subgraph Public Subnet
            igw[Internet Gateway]
            lb[Load Balancer]
            cert[Certificate]
            nat[NAT Gateway]
            
            igw --> lb
            lb <--> cert
        end

        subgraph Private Subnet
            subgraph Kubernetes Cluster
                k8s[Pods/Services]
                iam[IAM Policies/Roles]

                lb --> k8s
            end
        end
        k8s --> nat
    end

    nat --> igw
    igw --> internet
```
