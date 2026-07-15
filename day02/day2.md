# 🚀 TerraWeek - Day 2 Theory & Learnings

> 📚 **Topic:** Terraform Fundamentals
>
> Learn the core building blocks of Terraform including Blocks, Arguments, Expressions, Variables, Locals, Outputs, Built-in Functions, and more.

---

# 📖 Table of Contents

- [1. What is a Block?](#-1-what-is-a-block)
- [2. What is an Argument?](#-2-what-is-an-argument)
- [3. Expressions](#-3-expressions)
- [4. References](#-4-references)
- [5. Operators](#-5-operators)
- [6. Variables](#-6-variables)
- [7. Locals](#-7-locals)
- [8. Merge Tags](#-8-merge-tags)
- [9. Outputs](#-9-outputs)
- [10. Built-in Functions](#-10-built-in-functions)

---

# 📦 1. What is a Block?

A **Block** is the primary building component in Terraform.

It tells Terraform **what needs to be created or configured**.

Terraform uses different types of blocks such as:

- 📦 Resource
- 🌐 Provider
- 🔤 Variable
- 📤 Output
- 📍 Local
- 📁 Module

### Example

```terraform
resource "docker_container" "nginx" {

}
```

### 📝 Explanation

| Part | Meaning |
|------|----------|
| `resource` | Block Type |
| `docker_container` | Resource Type |
| `nginx` | Resource Name |

> 💡 Think of a block as a "container" that holds configuration.

---

# 📝 2. What is an Argument?

An **Argument** is a key-value pair written inside a block.

It provides configuration details to Terraform.

### Example

```terraform
resource "docker_container" "nginx" {
  image = "nginx:latest"
  name  = "web-container"
}
```

### Here,

```terraform
image = "nginx:latest"
```

is an **argument**.

Likewise,

```terraform
name = "web-container"
```

is also an argument.

---

# 🧮 3. Expressions

Expressions are used to create **dynamic values** instead of hardcoding them.

Suppose:

```terraform
variable "environment" {
  default = "dev"
}
```

Instead of writing:

```terraform
name = "dev-server"
```

Use an expression:

```terraform
name = "${var.environment}-server"
```

### Output

```
dev-server
```

---

## ✅ Benefits

- Reusable
- Dynamic
- Easy to maintain
- Less hardcoding

---

# 🔗 4. References

References allow Terraform to use values from other objects.

You can reference:

- Variables
- Resources
- Outputs
- Locals
- Modules

### Example

```terraform
variable "container_name" {
  default = "tws-web"
}
```

Reference it like:

```terraform
var.container_name
```

Output

```
tws-web
```

---

# ⚙️ 5. Operators

Terraform supports multiple operators.

---

## Comparison Operator (`==`)

Used to compare two values.

```terraform
var.environment == "prod"
```

If

```terraform
var.environment = "prod"
```

Output

```
true
```

Otherwise

```
false
```

---

## Arithmetic Operator (`+`)

Used for mathematical calculations.

Example

```
5 + 3 = 8
```

---

## Logical AND (`&&`)

Returns **true** only if **both conditions** are true.

Example

```terraform
enable_logs && enable_monitoring
```

| Condition 1 | Condition 2 | Output |
|-------------|-------------|--------|
| True | True | ✅ True |
| True | False | ❌ False |
| False | True | ❌ False |
| False | False | ❌ False |

---

# 📚 6. Variables

Variables make Terraform code reusable.

---

## Primitive Types

### 🔤 String

Stores text values.

```terraform
"default"
```

Example

```terraform
"dev"
```

---

### 🔢 Number

Stores numeric values.

Example

```terraform
8080
```

Used for

- Port Numbers
- CPU Count
- Memory Size

---

### ✅ Boolean

Stores either

```terraform
true
```

or

```terraform
false
```

---

## Collection Types

### 📋 List

Stores multiple values.

Example

```terraform
["dev","test","prod"]
```

---

### 🗂️ Map

Stores key-value pairs.

Example

```terraform
{
  owner = "Siddharth"
  team  = "DevOps"
}
```

---

### 🎯 Set

Similar to a list but removes duplicate values automatically.

Example

```terraform
toset(["dev","dev","prod"])
```

Output

```
["dev","prod"]
```

---

## Structural Types

### 📦 Object

Groups related values together.

Example

```terraform
{
  name = "server"
  cpu  = 2
  ram  = 4
}
```

---

### 📌 Tuple

Stores multiple values with different data types.

Example

```terraform
["server",2,true]
```

---

## 🔒 Sensitive Variables

Sensitive variables hide their values from Terraform output.

Example

```terraform
variable "db_password" {
  sensitive = true
}
```

Useful for

- Passwords
- API Keys
- Secrets
- Tokens

---

# 📍 7. Locals

Locals are reusable values calculated by Terraform.

Instead of writing the same expression multiple times,

```terraform
"${var.environment}-server"
```

Create a local.

```terraform
locals {
  name_prefix = "${var.environment}-server"
}
```

Now use

```terraform
local.name_prefix
```

---

## ✅ Why Use Locals?

✔ Reduce repetition

✔ Improve readability

✔ Easier maintenance

---

# 🏷️ 8. Merge Tags

Terraform's `merge()` function combines multiple maps.

Suppose

```terraform
variable "tags" {
  default = {
    Owner   = "Siddharth"
    Project = "TerraWeek"
  }
}
```

Now add another tag.

```terraform
Environment = "dev"
```

Use

```terraform
locals {
  merged_tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}
```

### Result

```terraform
{
  Owner = "Siddharth"
  Project = "TerraWeek"
  Environment = "dev"
}
```

---

# 📤 9. Outputs

Outputs display useful information after Terraform execution.

Example

```terraform
output "environment" {
  value = var.environment
}
```

Output

```
dev
```

Outputs are useful for:

- IP Addresses
- Resource IDs
- URLs
- DNS Names

---

# 🛠️ 10. Built-in Functions

Terraform provides many built-in functions.

| Function | Description | Example |
|----------|-------------|---------|
| `upper()` | Converts text to uppercase | `upper("dev")` → `DEV` |
| `join()` | Joins list elements | `join("-",["dev","server"])` |
| `merge()` | Combines two maps | `merge(map1,map2)` |
| `length()` | Returns number of elements | `length(["a","b"])` → `2` |
| `lookup()` | Retrieves a value from a map | `lookup(map,"owner")` |

---

# 🎯 Key Takeaways

✅ Blocks are the building blocks of Terraform.

✅ Arguments configure blocks.

✅ Expressions create dynamic values.

✅ References access values from other Terraform objects.

✅ Variables improve reusability.

✅ Locals reduce repeated code.

✅ Merge combines maps.

✅ Outputs display important information.

✅ Built-in functions simplify Terraform code.

---

# 📚 What I Learned Today

- Terraform Block Structure
- Arguments
- Expressions
- References
- Operators
- Variable Types
- Sensitive Variables
- Collection Types
- Structural Types
- Locals
- Merge Function
- Outputs
- Built-in Functions

---
# 🐳 Task 4: Build Something Real with Terraform & Docker

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform)
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker)
![Status](https://img.shields.io/badge/Task-Completed-success?style=for-the-badge)

**TerraWeek - Day 2 Practical Challenge**

</div>

---

# 📖 Overview

After learning Terraform fundamentals such as **Blocks, Variables, Locals, Outputs, Expressions, and Functions**, it was time to apply these concepts in a real-world project.

In this task, I used the **Docker Provider** with Terraform to provision a Docker container locally. Instead of deploying infrastructure on a cloud provider (AWS, Azure, or GCP), I used Docker to avoid cloud costs while still understanding Infrastructure as Code (IaC) concepts.

The project demonstrates how Terraform can automate the complete lifecycle of infrastructure—from pulling a Docker image to creating, managing, and destroying a running container.

---

# 🎯 Objective

The primary objective of this task was to:

- Understand how Terraform interacts with external providers.
- Learn how to provision infrastructure using the Docker Provider.
- Pass configuration values using Terraform variables.
- Explore different methods of supplying variable values.
- Practice the Terraform workflow (`init`, `plan`, `apply`, `output`, and `destroy`).
- Understand Terraform Variable Precedence.

---

# 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| Terraform | Infrastructure as Code |
| Docker | Container Runtime |
| Nginx | Web Server |
| HCL | Terraform Configuration Language |

---

# 📂 Project Structure

```text
example/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── terraform.tf
└── README.md
```

Each file has a specific responsibility, making the project organized and easy to maintain.

---

# 📦 Terraform Docker Provider

Terraform uses **Providers** to communicate with external platforms.

In this project, the Docker Provider was used to communicate with the local Docker Engine.

Example:

```terraform
provider "docker" {}
```

Once initialized, Terraform can:

- Pull Docker images
- Create containers
- Start containers
- Stop containers
- Destroy containers

---

# 🚀 Terraform Workflow

Terraform follows a simple workflow consisting of five major steps.

---

## Step 1 – Initialize Terraform

Initialize the working directory.

```bash
terraform init
```

### What happens?

- Downloads required providers.
- Creates `.terraform` directory.
- Generates dependency lock file.
- Prepares the project for execution.

---

## Step 2 – Preview Infrastructure

Generate an execution plan.

```bash
terraform plan \
-var="container_name=tws-web" \
-var="external_port=8080"
```

### Why use `terraform plan`?

Before creating infrastructure, Terraform compares:

Current State ➜ Desired State

Then displays:

- Resources to Create
- Resources to Modify
- Resources to Destroy

No changes are actually made during this step.

---

## Step 3 – Apply Configuration

Deploy the infrastructure.

```bash
terraform apply \
-var="container_name=tws-web" \
-var="external_port=8080"
```

Terraform performs the following actions:

- Pulls the latest Nginx Docker image.
- Creates a Docker container.
- Maps the external port.
- Starts the container automatically.

After completion, Terraform displays:

```
Apply complete!
```

---

## Step 4 – Verify the Deployment

Open your browser.

```
http://localhost:8080
```

If everything is configured correctly, the default **Nginx Welcome Page** should appear.

This confirms that Terraform successfully provisioned the Docker container.

---

## Step 5 – View Outputs

Terraform outputs provide useful information after deployment.

Run:

```bash
terraform output
```

Example Output:

```
container_name = "tws-web"
container_id = "3d12f4a..."
```

Outputs eliminate the need to manually inspect Docker resources.

---

## Step 6 – Destroy Infrastructure

Remove all resources created by Terraform.

```bash
terraform destroy \
-var="container_name=tws-web" \
-var="external_port=8080"
```

Terraform safely deletes:

- Docker Container
- Associated Resources

This demonstrates Terraform's ability to manage the **entire infrastructure lifecycle**.

---

# 📚 Passing Variables

Terraform allows multiple ways to provide variable values.

---

## Method 1 – Command Line Variables

```bash
terraform apply \
-var="container_name=tws-web" \
-var="external_port=8080"
```

Advantages:

- Great for testing.
- Overrides default values.
- Highest precedence.

Disadvantages:

- Difficult to manage when many variables exist.
- Requires typing every time.

---

## Method 2 – terraform.tfvars

Create a file:

```terraform
container_name = "tws-web"
external_port = 8080
```

Now simply run:

```bash
terraform apply
```

Terraform automatically loads values from the file.

Advantages:

- Cleaner configuration.
- Easier collaboration.
- Recommended for development environments.

---

# ⚖️ Variable Precedence

Terraform follows a precedence order when multiple values are provided.

Highest priority wins.

| Priority | Source |
|----------|---------|
| 🥇 Highest | `-var` / `-var-file` |
| 🥈 | `*.auto.tfvars` |
| 🥉 | `terraform.tfvars` |
| 4 | `TF_VAR_` Environment Variables |
| 5 | Variable Default Values |

Example:

Suppose

`terraform.tfvars`

```terraform
container_name = "terraform-file"
```

Command Line

```bash
terraform apply -var="container_name=cli-name"
```

Terraform chooses:

```
cli-name
```

because command-line variables have the highest precedence.

---

# 🎁 Bonus Concepts

## 1️⃣ For Expression

Terraform can transform collections.

Example:

```terraform
[for s in var.names : upper(s)]
```

Input:

```terraform
["dev","test","prod"]
```

Output:

```terraform
["DEV","TEST","PROD"]
```

---

## 2️⃣ Conditional Expression

Terraform supports conditional logic.

```terraform
var.environment == "prod" ? "t3.medium" : "t3.micro"
```

Meaning:

If environment is **Production**

➡️ Use

```
t3.medium
```

Otherwise

➡️ Use

```
t3.micro
```

This reduces duplication and makes configurations dynamic.

---

## 3️⃣ Optional Object Attributes

Terraform also supports optional object properties.

Example:

```terraform
variable "server" {
  type = object({
    name = string
    cpu  = optional(number)
  })
}
```

Now the CPU field becomes optional.

---

# 📤 Deliverables

As part of this challenge, I completed the following:

- ✅ Created Terraform configuration files.
- ✅ Initialized Terraform.
- ✅ Planned the infrastructure.
- ✅ Applied the configuration.
- ✅ Successfully deployed an Nginx Docker container.
- ✅ Verified the deployment in the browser.
- ✅ Viewed Terraform outputs.
- ✅ Destroyed the infrastructure.
- ✅ Practiced using `terraform.tfvars`.
- ✅ Explored variable precedence.
- ✅ Learned advanced Terraform expressions.

---

# 💡 Key Learnings

- Terraform can manage local infrastructure using Docker.
- Providers enable Terraform to interact with external platforms.
- Variables make configurations reusable.
- Outputs expose important resource information.
- `terraform.tfvars` simplifies configuration management.
- Variable precedence determines which value Terraform uses.
- Terraform manages the complete lifecycle of infrastructure.
- Expressions and functions make configurations dynamic and maintainable.

---

# 🎯 Conclusion

This task provided hands-on experience with **Infrastructure as Code (IaC)** by provisioning a real Docker container using Terraform. It reinforced the concepts learned in theory and demonstrated how Terraform can automate infrastructure deployment, configuration, and cleanup in a predictable and repeatable manner.

Completing this exercise strengthened my understanding of Terraform workflows, variable management, providers, outputs, and best practices, preparing me for deploying infrastructure on cloud platforms such as AWS, Azure, and Google Cloud in future projects.

---

<div align="center">

### 🚀 Task 4 Successfully Completed

**Happy Learning with Terraform!**

⭐ If you found this project useful, feel free to star the repository!

</div>

## ⭐ Quick Revision

| Topic | One-Line Summary |
|--------|------------------|
| Block | Main building unit of Terraform |
| Argument | Key-value pair inside a block |
| Expression | Creates dynamic values |
| Reference | Uses value from another object |
| Variable | Makes code reusable |
| Local | Stores reusable expressions |
| Output | Displays useful values |
| Merge | Combines maps |
| Function | Performs built-in operations |

---

<div align="center">

### 🌟 TerraWeek - Day 2 Complete 🌟

**Happy Learning! Lets got to day4 🚀**

</div>
