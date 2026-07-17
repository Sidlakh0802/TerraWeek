# 🌱 TerraWeek – Day 6: Terraform Workspaces

## 📌 What are Terraform Workspaces?

Terraform Workspaces are one of the most crucial features of Terraform as they help in **isolating infrastructure state** while using the same Terraform configuration.

In organizations, there are usually multiple environments such as:
- Development (Dev)
- Staging
- Production (Prod)

Workspaces allow you to create, test, or modify infrastructure for one environment without disturbing another environment.

---

# Terraform Workspace Commands

## List all Workspaces

```bash
terraform workspace list
```

This command displays all the available Terraform workspaces.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/026dd3e1-2e69-4919-b889-b0d349648d9f" />

---

## Create a New Workspace

```bash
terraform workspace new staging
```

This command creates a new workspace named **staging**.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/50f58ed9-13a1-41a6-aa63-74b10332d6f2" />

---

## Select a Workspace

```bash
terraform workspace select staging
```

This command switches Terraform to the **staging** workspace.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/d4aaac41-a601-46f4-b7d3-35c43abfe0a7" />

---

## Show Current Workspace

```bash
terraform workspace show
```

This command displays the currently active Terraform workspace.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/d5b925d1-0872-43bd-ba28-6165125d0829" />

---

# Using Terraform Workspace with Locals

Terraform workspaces can also be used inside `locals` to provision different infrastructure based on the selected workspace.

Example:

```hcl
locals {
  instance_type = terraform.workspace == "prod" ? "t3.micro" : "t3.small"
}
```
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/21549416-c8e0-4efa-9ac2-409638542270" />


### Explanation

The above local block checks the currently selected workspace.

- If the workspace is **prod**, Terraform uses:

```text
t3.micro
```

- Otherwise, Terraform uses:

```text
t3.small
```
I also added count function to multiplicate instances based on condition of workspace 
This allows different environments to have different resource configurations while using the same Terraform code.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/b02ad386-68f3-40b6-8da4-9a86e3554468" />
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/d272a126-1fa9-402c-a37a-ac38e6d7ecd9" />

---

# Terraform Workspaces vs Separate Directories

There are two common approaches for managing multiple environments:

- Terraform Workspaces
- Separate Directories

---

# Terraform Workspaces

Terraform Workspaces are technically designed for environments that are **identical or nearly identical**.

### Common Use Case

- Temporary feature branches for testing
- Spinning up temporary environments
- Identical Dev, QA, and Staging environments

---

## Pros

- Very high reusability.
- Uses a single Terraform codebase.
- Easy to manage when environments are almost identical.
- Less code duplication.

---

## Cons

- Higher risk of accidental disruption.
- Since every workspace shares the same configuration, someone may accidentally execute Terraform in the wrong workspace.
- Forgetting to switch workspaces before running Terraform commands may result in applying testing changes directly to the production environment.
- Shared backend access can also become a security concern if permissions are not managed properly.

---

# Shared Backend

One concern with Terraform Workspaces is that they generally share the same backend configuration.

If backend permissions are compromised, an attacker could potentially gain access to multiple environments that use the same backend.

---

# Separate Directories

Separate Directories are the recommended approach for production environments because each environment maintains its own Terraform configuration and backend.

Each environment has its own:

- Backend
- State file
- Configuration
- Infrastructure

This provides much stronger isolation between environments.

---

## Pros

- Strong environment isolation.
- Different AWS accounts can be used.
- Different IAM Roles can be configured.
- Separate remote S3 backends can be maintained for each environment.
- Better security and reduced risk of accidental changes.

---

## Cons

- Code duplication is the biggest drawback.
- Multiple `main.tf` files need to be maintained.
- Managing changes across environments requires additional effort.

### Solution

Terraform **Modules** can be used to eliminate most code duplication while still keeping environments isolated.

This provides:

- Better maintainability
- Reduced code duplication
- Faster time to market

---
Harshicop generally preferred for production environments.
- Terraform Modules help reduce code duplication when using Separate Directories.


### Security & Testing

Terraform provides built-in testing capabilities that help validate infrastructure before and after deployment. These tests improve confidence in your Terraform configuration and ensure that your infrastructure behaves as expected.

> **Note:** Additional test cases can always be added to make the module more robust and to verify whether the infrastructure matches the expected configuration.

---

## Types of Terraform Tests

Terraform testing can be broadly classified into two types:

```text
                Test
               /    \
          Plan       Apply
```

---

## 1. Plan-Based Test

A **Plan-Based Test** creates a hypothetical execution plan in memory without provisioning any real infrastructure. Terraform evaluates the configuration and checks assertions against the generated plan.

### How it Works

- Generates an execution plan in memory.
- Validates assertions against the planned infrastructure.
- Does **not** create any cloud resources.
- Ideal for validating configuration logic and resource definitions.

### Advantages

- ✅ Lightweight and fast.
- ✅ 100% safe.
- ✅ Zero infrastructure cost since no resources are created.

### Limitations

- ❌ Cannot validate values that are generated only after infrastructure creation (for example, Public IP addresses, DNS names, or other runtime attributes).

---

## 2. Apply-Based Test

An **Apply-Based Test** provisions real infrastructure in the cloud, validates the deployed resources, and automatically destroys them after the test completes.

### How it Works

- Creates actual cloud infrastructure.
- Runs assertions against live resources.
- Automatically destroys the created resources after testing.

### Advantages

- ✅ Verifies real-world infrastructure behavior.
- ✅ Can validate generated attributes and runtime values.
- ✅ Provides the highest level of confidence.

### Limitations

- ❌ Takes longer to execute.
- ❌ Requires valid AWS credentials.
- ❌ May incur a small cloud cost while resources exist.

---

## Which Test Was Used?

For this project, the infrastructure consists of a simple **AWS EC2 instance** created using **Terraform Workspaces** with a basic configuration.

Since there are no runtime-generated values that needed validation, a **Plan-Based Test** was sufficient and was used for the test report.

<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/0d46cfe9-2fcd-4070-8181-6e1dfd49a7b2" />
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/bb630626-516d-414a-be27-8e98d1861a74" />

---


## Summary

| Feature | Plan Test | Apply Test |
|----------|-----------|------------|
| Creates Infrastructure | ❌ No | ✅ Yes |
| Execution Speed | ⚡ Fast | 🐢 Slower |
| Cloud Cost | ✅ None | ⚠️ Small Cost Possible |
| AWS Credentials Required | ❌ No | ✅ Yes |
| Tests Runtime Values | ❌ No | ✅ Yes |
| Best Use Case | Configuration Validation | Real Infrastructure Validation |

---

## Validation Commands

Format the Terraform configuration:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Initialize the example configuration:

```bash
cd example
terraform init
```

Run the Terraform native tests:

```bash
terraform test
```

These commands ensure that the Terraform configuration is properly formatted, syntactically valid, and behaves as expected before deployment.
````

