# File structures

Following file structures snippets are useful for doing a demo/presentation 


## Structures

```tree
├── ...
├── common
│   └── *.tf
├── environments
│   ├── docs
│   │   └── *.tf
│   └── images
│       ├── prod
│       │   └── *.tf
│       └── staging
│           └── *.tf
├── modules
│   └── common
│       └── sg
│           └── *.tf
└── projects
    ├── cms
    │   └── *.tf
    ├── portal
    │   ├── app
    │   │   └── *.tf
    │   └── platform
    │       └── *.tf
    └── runners
        └── *.tf
```

## Naming

```tree
├── ...
├── common
│   ├── nonprod.tfvars
│   ├── prod.tfvars
│   └── ...
└── projects
    ├── cms
    │   ├── production.tfvars
    │   ├── release.tfvars
    │   ├── staging.tfvars
    │   ├── training.tfvars
    │   └── ...
    ├── portal
    │   ├── app
    │   │   ├── integration.tfvars
    │   │   ├── live.tfvars
    │   │   └── ...
    │   └── platform
    │       ├── integration.tfvars
    │       ├── live.tfvars
    │       └── ...
    └── ...
```


## Full

```tree
├── LICENSE
├── README.md
├── _demo
│   └── screencasts
│       ├── tc-advanced
│       ├── tc-advanced.gif
│       ├── tc-install
│       ├── tc-install.gif
│       ├── tc-simple
│       └── tc-simple.gif
├── aliases.yaml
├── common
│   ├── nonprod.tfvars
│   ├── outputs.tf
│   ├── prod.tfvars
│   ├── terraform.tfstate.d
│   │   ├── nonprod
│   │   │   └── terraform.tfstate
│   │   └── production
│   │       └── terraform.tfstate
│   ├── variables.tf
│   ├── versions.tf
│   └── vpc.tf
├── config
│   └── providers.tf
├── environments
│   ├── docs
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── plan.tfplan
│   │   ├── terraform.tfstate
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── images
│       ├── prod
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── terraform.tfstate
│       │   ├── variables.tf
│       │   └── versions.tf
│       └── staging
│           ├── main.tf
│           ├── outputs.tf
│           ├── terraform.tfstate
│           ├── variables.tf
│           └── versions.tf
├── modules
│   └── common
│       └── sg
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
└── projects
    ├── cms
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── production.tfvars
    │   ├── release.tfvars
    │   ├── staging.tfvars
    │   ├── terraform.tfstate.d
    │   │   ├── production
    │   │   │   └── terraform.tfstate
    │   │   ├── release
    │   │   │   └── terraform.tfstate
    │   │   ├── staging
    │   │   │   └── terraform.tfstate
    │   │   └── training
    │   │       └── terraform.tfstate
    │   ├── training.tfvars
    │   ├── variables.tf
    │   └── versions.tf
    ├── portal
    │   ├── app
    │   │   ├── experiment.terraform.tfstate.d
    │   │   │   └── integration
    │   │   │       └── terraform.tfstate
    │   │   ├── integration.tfvars
    │   │   ├── live.tfvars
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── terraform.tfstate.d
    │   │   │   ├── integration
    │   │   │   │   └── terraform.tfstate
    │   │   │   └── live
    │   │   │       └── terraform.tfstate
    │   │   ├── variables.tf
    │   │   └── versions.tf
    │   └── platform
    │       ├── integration.tfvars
    │       ├── live.tfvars
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── plan.tfplan
    │       ├── terraform.tfstate.d
    │       │   ├── integration
    │       │   │   └── terraform.tfstate
    │       │   └── live
    │       │       └── terraform.tfstate
    │       ├── variables.tf
    │       └── versions.tf
    └── runners
        ├── main.tf
        ├── nonprod.tfvars
        ├── outputs.tf
        ├── production.tfvars
        ├── terraform.tfstate.d
        │   ├── production
        │   │   └── terraform.tfstate
        │   └── staging
        │       └── terraform.tfstate
        ├── variables.tf
        └── versions.tf
```