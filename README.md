# Kubernetes Service Principal

A complementary module to Kubernetes (AKS) module to create the service principal and assign roles required. It will output the application id and password required as input parameters to `avinor/kubernetes/azurerm` module.

This module requires elevated access to be able to create the application in AzureAD and assign roles to resources. It is therefore not recommended to be run as any CI/CD pipeline, but instead manually before running any automated process. The output can still be used by reading remote state.

## Usage

Examples use [tau](https://github.com/avinor/tau).

```terraform
module {
    source = "avinor/kubernetes-service-principal/azurerm"
    version = "1.0.0"
}

inputs {
    name = "aks-sp"
    end_date = "2020-01-01T00:00:00Z"

    subnet_id = [
        "/subscriptions/xxxxx/.../subnet-id"
    ]
}
```

If using tau to deploy the vnet it can also be used to retrieve the subnet_id by using a dependency

```terraform
dependency "vnet" {
    source = "./vnet.hcl"
}

inputs {
    subnet_id = [
        dependency.vnet.outputs.subnet_id
    ]
}
```

Output from this module can then be used when deploying Kubernetes cluster.
