# Public Cluster

This module creates a public Kubernetes cluster in AWS using EKS. The cluster is designed to be accessible from the public internet, with public-facing load balancers and other resources.

The following diagram illustrates the resources created by this module, and how they interact with one another

```mermaid
flowchart TB
    user[User]
    dns[DNS Record]
    internet[Internet]

    subgraph Hosted Zone
       dns:::managed
    end

    user <==> dns <==> igw

    subgraph VPC
        subgraph Public Subnet
            tg[Target Group]:::managed
            cert[Certificate]:::managed
            igw[Internet Gateway]
            lb[Load Balancer]:::managed
            nat[NAT Gateway]

            igw ==> lb --o cert
        end

        subgraph Private Subnet
            cluster:::security-group

            subgraph cluster[Kubernetes Cluster]
                ext-dns[ExternalDNS]:::addon
                cm[Cert Manager]:::addon
                lbc[AWS Load Balancer Controller]:::addon

                iam[IAM Policies/Roles]
                gateway[Gateway]
                route[HTTPRoute]
                service[Service]
                node:::security-group

                subgraph node[Node]
                    pod[Pod]
                end
                ext-dns -.-> dns
                cm -.-> cert
                lbc -.-> lb
                lbc -.-> tg

                lb ==> tg ==> gateway ==> route ==> service ==> pod

            end

        end
        pod -.-> nat
    end

    nat -.-> igw -.-> internet

    classDef security-group stroke:green;
    classDef addon stroke:blue;
    classDef managed stroke:blue,stroke-dasharray:10
```
