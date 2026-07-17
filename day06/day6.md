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

Security Scanning with Trivy

Security scanning is an essential step in Infrastructure as Code (IaC). During this project, **Trivy** was used to scan the Terraform configuration and identify security risks before deployment.

## Scan Results

The initial scan detected **11 security issues**, including **1 Critical** vulnerability.

Instead of attempting to resolve every issue at once, the focus was shifted towards fixing the **Critical** issue first, following a risk-based remediation approach.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/24cb3973-0c9f-49eb-8c9b-ff01ee36381b" />

---

## Why Were These Security Issues Detected?

The scan highlighted the following major findings:

### 1. Default VPC Usage

The infrastructure was deployed using the **AWS Default VPC**.

Since the default VPC comes with several predefined configurations, security scanners often flag it because it may not follow security best practices.

---

### 2. Open Egress Security Group Rule

The Security Group allowed **outbound (egress) traffic to every IP address and every port**.

This creates a potential security risk because workloads can communicate with any external destination.

---

### 3. Root Block Device Configuration

The EC2 instance **Root Block Device** (storage configuration) was not explicitly defined.

Security tools recommend defining storage configuration manually to enforce encryption, volume size, deletion behavior, and other security settings.

---

## For this task we took severity as critical and ran 


```bash
trivy config --severity CRITICAL .
```

This command analyzes the Terraform files and reports configuration Critical security issues before infrastructure is deployed.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/b9744145-ac62-47bf-b9cc-d83ed8efd804" />

Then we worked on the critical issues and fixed the code 
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/75375128-ac3a-40e0-a5e7-200aa3533b1b" />

# Infrastructure Cost Estimation with Infracost

**Infracost** is a cost estimation tool that predicts the expected cloud cost of Terraform infrastructure **before deployment**.

It helps developers understand the financial impact of infrastructure changes during the planning stage.

---

## How It Works

### Step 1 – Generate a Terraform Plan

Generate a Terraform execution plan and save it as a binary file.

```bash
terraform plan -out=tfplan.binary
```
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/c42bae82-ed31-407a-baf1-c9955d56541f" />

---

### Step 2 – Convert the Plan into JSON

Convert the binary Terraform plan into a readable JSON file.

```bash
terraform show -json tfplan.binary > plan.json
```
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/7b242790-efdd-4bdd-befd-487c4ad3bb7d" />

---

### Step 3 – Run Infracost

Run Infracost against the generated JSON plan to estimate infrastructure costs.

```bash
infracost breakdown --path plan.json
```

This command analyzes the Terraform plan and provides a detailed cost estimate before any infrastructure is created.

---

## Benefits of Infracost

- Estimate cloud costs before deployment.
- Detect unexpected cost increases early.
- Improve infrastructure budgeting.
- Integrate cost estimation into CI/CD pipelines.
- Make cost-aware infrastructure decisions before provisioning resources.
