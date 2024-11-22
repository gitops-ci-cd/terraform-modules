# Public Cluster

This module creates a public Kubernetes cluster in AWS using EKS. The cluster is designed to be accessible from the public internet, with public-facing load balancers and other resources.

The following diagram illustrates the resources created by this module, and how they interact with one another

```mermaid
flowchart TB
    user[User] --> dns[DNS Record]
    subgraph Hosted Zone
       dns
    end
    internet[Internet]

    dns --> lb[Load Balancer]

    subgraph VPC
        subgraph Public Subnet
            lb[Load Balancer]
            lb <--> cert[Certificate]
        end

        subgraph Private Subnet
            subgraph Kubernetes Cluster
                iam[IAM]
                lb --> k8s[Pods/Services]
            end
            k8s --> nat[NAT Gateway]
        end
    end

    nat --> internet
```
