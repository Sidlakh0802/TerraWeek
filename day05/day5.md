

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


Absolutely! Here's a much more **human-written** version that sounds like something you would actually write in your README after completing the task.

---

# 🔁 Creating Multiple EC2 Instances Using `for_each`

After creating a reusable EC2 module, I enhanced the implementation by using Terraform's **`for_each`** meta-argument to provision multiple EC2 instances with a single module block.

Instead of writing separate module blocks for each server, I used `for_each` to iterate over a list of server names. This allowed Terraform to automatically create one EC2 instance for each server while reusing the same module.

### Module Configuration

```hcl
module "servers" {
  source   = "./modules"
  for_each = toset(["app", "worker", "cache"])

  name                   = each.key
  instance_type          = "t3.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}
```

---

## 📖 Understanding the Code

The `for_each` meta-argument was used to loop through the following server names:

```hcl
toset(["app", "worker", "cache"])
```

Terraform treated each value in the set as a separate module instance.

The `each.key` expression was then used to assign the current server name to the `name` variable inside the module. As a result, three EC2 instances were created with the names:

* **app**
* **worker**
* **cache**

All three instances shared the same configuration, including:

* Instance Type: `t3.micro`
* Environment: `dev`
* Amazon Linux 2023 AMI
* Default Subnet
* Default Security Group

Only the instance name changed for each deployment.

---

## ✅ What I Implemented

During this task, I:

* Converted a reusable EC2 module into a scalable solution using the **`for_each`** meta-argument.
* Created three EC2 instances (`app`, `worker`, and `cache`) from a single module block.
* Used `each.key` to assign a unique name to every EC2 instance.
* Passed common values such as the AMI ID, instance type, subnet ID, environment, and security group IDs to each module.
* Eliminated duplicate code by reusing the same Child Module for multiple deployments.
* Learned how Terraform automatically creates multiple module instances from a single configuration, making the infrastructure easier to scale and maintain.

---

## 🎯 Outcome

By implementing `for_each`, I was able to provision multiple EC2 instances without duplicating module blocks. This made the Terraform configuration cleaner, more scalable, and much easier to maintain. Instead of managing separate configurations for each server, I reused a single module and allowed Terraform to handle the iteration automatically.

---
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/1d95ef06-003e-412c-a627-3ab5c338ff72" />
<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/cb93e2f0-cf31-46ec-a41d-4eb5adbd48e4" />



---

# 📚 Key Learnings

Throughout Day 5, I gained hands-on experience in organizing Terraform configurations using reusable modules. Instead of keeping all resources in a single file, I separated the infrastructure into Root and Child Modules, making the project cleaner and easier to manage.

Some of the key concepts I learned include:

* Understood the purpose and benefits of Terraform Modules.
* Learned the difference between **Root Module** and **Child Module**.
* Created a reusable EC2 module using `main.tf`, `variables.tf`, and `outputs.tf`.
* Passed input values from the Root Module to the Child Module.
* Implemented variable validation to ensure correct user inputs.
* Worked with different Terraform variable types such as `string`, `list(string)`, and `map(string)`.
* Used Terraform Data Sources to retrieve existing AWS resources like the default VPC, subnet, security group, and Amazon Linux 2023 AMI.
* Created local values to simplify the Terraform configuration.
* Used the `merge()` function to combine default and custom tags.
* Learned how outputs expose important resource information after deployment.
* Implemented the `for_each` meta-argument to provision multiple EC2 instances from a single reusable module.
* Used `each.key` to assign unique names to each EC2 instance.
* Reduced code duplication by reusing the same Child Module for multiple server deployments.

---

# 👀 Things I Noticed

While working on this task, I observed several things that highlighted why Terraform Modules are considered a best practice for Infrastructure as Code.

* Modules significantly reduce duplicate code.
* A well-structured project becomes much easier to read and maintain.
* Variable validation helps catch incorrect inputs before infrastructure is provisioned.
* Data Sources make it easy to reference existing AWS resources instead of hardcoding their values.
* Local values improve readability by avoiding repeated expressions.
* Outputs provide quick access to important resource details after deployment.
* Using `for_each` is much cleaner than creating multiple identical module blocks manually.
* A single reusable module can be used to deploy multiple resources with only a few input changes.
* Separating reusable logic from the Root Module keeps the overall project organized and scalable.

---

# 💡 Key Takeaways

Day 5 reinforced the importance of writing reusable and maintainable Infrastructure as Code. Instead of focusing only on creating resources, I learned how to structure Terraform projects in a way that supports scalability, consistency, and easier collaboration.

My biggest takeaways from this task were:

* **Modules are the foundation of reusable Terraform code.**
* **The Root Module should focus on orchestration, while Child Modules should contain reusable infrastructure logic.**
* **Input variables make modules flexible and reusable across different environments.**
* **Variable validation improves reliability by preventing invalid configurations.**
* **Data Sources allow existing cloud resources to be reused instead of recreated.**
* **Outputs make it easier to reference important resource attributes across configurations.**
* **The `for_each` meta-argument is an efficient way to create multiple similar resources without duplicating code.**
* **A modular Terraform project is easier to maintain, extend, and collaborate on than a monolithic configuration.**

---

# 🎉 Day 5 Summary

Day 5 was focused on transforming Terraform configurations into reusable, modular, and scalable Infrastructure as Code. I created a reusable EC2 module, organized the project into Root and Child Modules, implemented variable validation and outputs, worked with Data Sources and local values, and finally used the `for_each` meta-argument to provision multiple EC2 instances from a single module. This approach reduced code duplication, improved maintainability, and demonstrated how Terraform modules simplify infrastructure management in real-world projects.

---

