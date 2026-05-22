┌─────────────────────────────────────────────────────────┐
│  AWS Account (ap-southeast-2 — Sydney)                  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  VPC (10.0.0.0/16)                               │  │
│  │                                                  │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │  Public Subnet (10.0.1.0/24)               │  │  │
│  │  │                                            │  │  │
│  │  │  ┌──────────────────┐                      │  │  │
│  │  │  │  EC2 (t2.micro)  │◄── Security Group    │  │  │
│  │  │  │  Amazon Linux 2  │    (port 80)         │  │  │
│  │  │  │  IAM Profile     │                      │  │  │
│  │  │  └──────────────────┘                      │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  │            │                                      │  │
│  │  Internet Gateway ──► Route Table                │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  S3 (remote state) + DynamoDB (state lock)             │
└─────────────────────────────────────────────────────────┘

---

## Repository Structure
aws-terraform/
├── bootstrap/                  # One-time setup: S3 + DynamoDB for remote state
│   └── main.tf
│
├── environments/
│   └── dev/                    # Dev environment — wires all modules together
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
│
├── modules/
│   ├── vpc/                    # VPC, subnet, internet gateway, route table
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ec2/                    # Security group + EC2 instance
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── iam/                    # EC2 role, instance profile, optional CI/CD user
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── .github/
└── workflows/
├── plan.yml            # Runs terraform plan on every PR
└── apply.yml           # Runs terraform apply manually 


