

# 🌱 TerraWeek – Day 5: Terraform Modules

**Date:** 16 July 2026

Welcome to **Day 5** of the TerraWeek Challenge!

Today focused on one of Terraform's most important concepts—**Modules**. Instead of writing the same infrastructure code repeatedly, modules allow us to organize, reuse, and standardize Terraform configurations.

---

# 📚 What is a Terraform Module?

A **Terraform Module** is a collection of Terraform configuration files that are used together to provision a specific set of infrastructure resources.

Instead of defining resources repeatedly, we can create a reusable module and call it whenever required.

### Example

To create an EC2 instance, you generally need:

* EC2 Instance
* Security Group
* Tags
* Variables
* Outputs

Rather than writing all of this every time, we package everything into a **module** and reuse it across multiple environments.

---

# 🏗️ Root Module vs Child Module

## Root Module

The **Root Module** is the directory where you execute Terraform commands.

Examples:

```bash
terraform init
terraform plan
terraform apply
```

It acts as the entry point of your Terraform project and is responsible for calling child modules.

---

## Child Module

A **Child Module** is a separate directory that contains reusable Terraform code.

It usually contains the logic for creating a specific infrastructure component such as:

* EC2 Instance
* VPC
* Security Group
* S3 Bucket

The Root Module calls the Child Module whenever those resources are required.

---

# 📂 Module Structure

```
Root Module
│
├── Calls Child Module
│
└── Child Module
      ├── main.tf
      ├── variables.tf
      ├── outputs.tf
      └── README.md
```

---

# ✅ Benefits of Using Modules

## 1. Reusability

Write infrastructure code once and reuse it multiple times.

Example:

Instead of writing the EC2 configuration repeatedly, simply call the module whenever a new server is required.

---

## 2. Consistency

Modules ensure that every infrastructure deployment follows the same configuration.

This becomes especially useful when multiple engineers work on the same project.

---

## 3. Encapsulation

Modules hide the internal implementation.

Users only need to provide input variables without worrying about the underlying resource creation logic.

---

## 4. Versioning

Terraform modules can be versioned.

This allows teams to upgrade module versions safely without breaking existing infrastructure.

---

# 📁 Structure of a Well-Designed Module

A standard Terraform module generally contains the following files.

---

## 1. main.tf

Contains the actual resource definitions.

Example:

* EC2 Instance
* Security Groups
* Tags
* Resource logic

---

## 2. variables.tf

Defines all input variables accepted by the module.

Example:

```hcl
variable "instance_type" {
  type = string
}
```

Variables make modules flexible and reusable.

---

## 3. outputs.tf

Exports useful information after resource creation.

Common outputs include:

* Instance ID
* Public IP
* Private IP
* ARN

---

## 4. README.md

Contains documentation describing:

* Module purpose
* Inputs
* Outputs
* Usage examples

---

# 📝 Creating Reusable Modules

A reusable Terraform module primarily consists of:

```
main.tf
variables.tf
outputs.tf
```

Each file has a specific responsibility.

---

# 📥 Understanding variables.tf

Variables allow users to customize module behavior.

A variable can include:

* Name
* Description
* Type
* Default Value
* Validation

Example:

```hcl
variable "environment" {
  type = string

  validation {
    condition = contains(["dev", "stg", "prod"], var.environment)

    error_message = "Environment must be dev, stg or prod."
  }
}
```

---

## Variable Validation Example (AMI)

```hcl
validation {
  condition     = startswith(var.ami, "ami-")
  error_message = "AMI ID must start with 'ami-'."
}
```

---

## Other Common Variables

### Subnet ID

```hcl
variable "subnet_id" {
  type = string
}
```

---

### Security Groups

```hcl
variable "vpc_security_group_ids" {
  type = list(string)
}
```

---

### Tags

```hcl
variable "tags" {
  type    = map(string)
  default = {}
}
```

---

# 📤 outputs.tf

Outputs expose useful resource information after deployment.

Example outputs:

* Instance ID
* Public IP
* Private IP

Example:

```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

---

# 🏗️ Resource Creation Inside main.tf

The EC2 resource receives values through variables.

Example:

```hcl
resource "aws_instance" "this" {

  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = merge(
    {
      Name        = var.name
      Environment = var.environment
      Module      = "ec2"
    },
    var.tags
  )
}
```

---

# 📌 Terraform Project Files Created

During today's exercise, the project consisted of:

```
terraform.tf
main.tf
outputs.tf
```

---

## terraform.tf

Contains the basic Terraform configuration.

Typically includes:

* Terraform version
* Provider configuration

---

## main.tf

Contains the infrastructure logic.

It also includes:

* Data Sources
* Local Values
* Module Calls

Example:

```
Data Sources

├── aws_ami
├── aws_vpc
├── aws_subnet
└── aws_security_group

Locals

├── subnet_id
└── security_group_ids
```

---

# 📦 Calling a Child Module

The Root Module invokes the reusable EC2 module using the `module` block.

Example:

```hcl
module "web_server" {

  source = "./modules/ec2"

  name          = "web-server"
  instance_type = "t3.micro"
  environment   = "dev"

  ami                     = data.aws_ami.al2023.id
  subnet_id               = local.subnet_id
  vpc_security_group_ids  = local.security_group_ids

  tags = {
    Role = "frontend"
  }
}
```

---

<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/08f89e4d-1900-4838-9d55-dc0e477d44c7" />

<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/48218a64-359b-4555-80b5-ddd093c7b30b" />


