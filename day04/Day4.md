# Day 4 – State & Remote Backend

## Task 1

### Q1. What is Terraform State File and what does it store?

**Ans:**

It is a JSON file which contains an architecture map of infrastructure created in any cloud platform, which is used to track metadata, dependencies, and resource ID.


### Q2. Why you never commit or edit this file?

**Ans:**

- Manually editing can be dangerous for the Terraform mapping, which may lead to corrupt the structure, which makes your Terraform unable to manage infrastructure.

- Similarly, committing to Git can be a serious security threat as there might be multiple engineers working on the same infrastructure, and Git doesn't allow to lock the file.

---

### Q3. State drift and refreshing

**Ans:**

State drift refers to changing of infrastructure outside the Terraform, for e.g. manually editing a Security Group directly in AWS Console.

---

### Q4. What does Terraform Plan or Refresh will?

**Ans:**

When you run these commands, it compares the environment against your state file and highlights the differences.

---

### Q5. Why is State sensitive?

**Ans:**

This also relates to why it is very important to store this file safely because it is very sensitive. It contains all your data in plain text, meaning all your files including your Database password, private keys, TLS certificate and API token.

---

# Task 2

## Cheatsheet for the State Commands

### 1. `terraform state list`

This command simply lists all the resource addresses used to verify what Terraform is actively managing.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/7c12c688-42a4-472c-ad52-2ce7e9841d09" />


---

### 2. `terraform state show <resource address>`

This will provide detailed structure of resources, which is used for debugging.

<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/383522ae-89f1-4b36-9796-f744fe796b04" />


---

### 3. `terraform state mv  <src> <dest>`

It is used to rename or move a resource within a state file without destroying the actual infrastructure.

<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/58dbc4b6-8399-4cbc-a773-012c525af083" />


---

### 4. `terraform state rm <resource address>`

This is used to delete the resource from the state list but leaves the infrastructure untouched.

<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/d58594c0-1bee-44d6-bb18-08f302dc8abd" />


---

### 5. `terraform show`

This is used to provide output of the current state or specific plan file.
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/65b07d77-a165-4e7d-a1d6-037a6f7f7dbf" />

---
# Learning - If you do state rm it will delete the resource only form state file but in aws it will exist now you need to delete it manually or you need to import

# Task 3

We created 4 files in Backend.

## 1. `variables.tf`

- This file contains all the variables like AWS region for bucket and name for bucket.

---

## 2. `terraform.tf`

- This file contains configuration of Terraform as well as configuration of AWS.

---

## 3. `resource.tf`

In this file the main configuration is there.

1. Bucket is the state or the name of the bucket.

2. Versioning is enabled with:

```hcl

versioning_configuration {
  status = "Enabled"
}
```

> Versioning is important to recover the state file if by any chance someone accidentally corrupts it.

3. Add the configuration to convert text files into lock file.

```hcl
apply_server_side_encryption_by_default {
  sse_algorithm = "AES256"
}
```

4. Block all the public access for security.

## 4. `output.tf`

- State bucket name
- ARN of the state bucket

- <img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/8be34ea9-55a1-49fa-b999-f81b37c7bdc3" />
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/0a703550-3922-43d6-9aac-bc4c8d05a531" />


