
Day 1 – Task 1

Q. What is Infrastructure as Code (IaC)?

* It is the practice of managing and provisioning infrastructure (such as servers) with code for automation, without the need of intervening in the console.
* Services can be created such as networks, databases, networking, and storage.

What problems does this solve?

Automation

* Resources can be created, updated, and deleted automatically, saving a lot of time.

Reduced Errors

* Automation reduces human effort and also reduces human errors.

Scalability and Collaboration

* The biggest advantage is scalability and collaboration, where large and complex infrastructure can be managed efficiently with less effort.
* Teams can collaborate using the same workflows they use for application code, improving collaboration and code reuse.

Q. What is Terraform?

* It is basically an IaC tool used to manage, create, and delete infrastructure in cloud platforms, which works on HCL language.
* It uses a declarative method to create resources.
    * Declarative method means instead of manually creating resources one by one in cloud platforms, it can create them using code.
* Terraform is so popular because it can work on all cloud platforms.

            Terraform
           /    |    \
        AWS   Azure   GCP
                    \
                  Any Other

Terraform vs Others

1. OpenTofu

* It works similar to Terraform, but it is like a fork of Terraform and it is an open-source tool.

2. CloudFormation

* This tool is specially designed for AWS only, so it can’t be used with other platforms.

3. Ansible

* It is used to manage already existing infrastructure/resources.

4. Pulumi

* You need to learn different programming language in order to write code, but in Terraform you just need to learn the HCL language.


Q. What are the key concepts of Terraform?

1. Provider

* It usually provides configuration to Terraform to use a particular platform like AWS, GCP, etc.

2. Resource

* It is like a service which we want to run in Terraform, such as EC2, S3, RDS, etc.

3. State

* It is basically an outline of what Terraform has created or is managing, including the configuration of your instance.

4. Plan

* It is like a roadmap of changes which will be performed by Terraform.

5. HCL

* This is the language which Terraform listens to.

6. Module

* It is basically reusable workflows.

<img width="3420" height="2214" alt="image" src="https://github.com/user-attachments/assets/50dfa00d-a7a9-43d5-ac00-4be3c586c1e6" />
