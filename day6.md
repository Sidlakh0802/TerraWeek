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
