# Terra Compose Demo

This repository is created as a demo source of the [Terra Compose tool](https://github.com/demmonico/terra-compose) usage.

## Content

It contains different sub-projects in its structure within vary Terraform versions, naming patterns and workspaces. 
Besides that, there is an example of the aliases file, that is required for correct work of the [Terra Compose tool](https://github.com/demmonico/terra-compose).

**Note**: for simplicity and demo consistency it includes all Terraform states. But, for sure, for production usage it's **NOT RECOMMENDED**! 

## Installation

- follow the [Terra Compose tool's](https://github.com/demmonico/terra-compose#installation) installation steps
- since this example is based on AWS -> [setup AWS CLI access](https://github.com/demmonico/terra-compose#aws-credentials)
- `cd` to the root of your repo and create the configuration file `aliases.yaml` in the [following format](https://github.com/demmonico/terra-compose#configuration):
  ```yaml
  aliases:
    alias_name:                           # [allowed only A-Za-z0-9_ symbols]
      path: "path/to/project/base/dir"    # [required]
      workspace: "live"                   # [optional, "default" will be used if exists and no more choice OR ask]
      tfvars: "nonprod"                   # [optional, workspace name will be used if skip OR ask]
      tfversion: "x.x.x"                  # [optional, from the default section will be used if omitted]
  ```
- done!
