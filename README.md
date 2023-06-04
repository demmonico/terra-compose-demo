# Terra Compose Demo

This repository is created as a demo source of the [Terra Compose tool](https://github.com/demmonico/terra-compose) usage.

## Content

It contains different sub-projects in it's structure within vary Terraform versions, naming patterns and workspaces. 
Besides that, there is an example of the aliases file, that is required for correct work of the [Terra Compose tool](https://github.com/demmonico/terra-compose).

**Note**: for simplicity and demo consistency it includes all Terraform states. But, for sure, for production usage it's **NOT RECOMMENDED**! 

## Installation

- follow [Terra Compose tool](https://github.com/demmonico/terra-compose) installation steps
- since this example is based on AWS -> setup AWS CLI access
  - get `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` env vars for your user from the AWS Console 
  - configure AWS CLI: `aws configure --profile <your_profile_name>` (see [docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for details)
  - export `AWS_PROFILE` env var containing selected profile name `export AWS_PROFILE=<your_profile_name>`
- cd to the root of your repo and create aliases file with projects aliases in the following format:
  ```yaml
  aliases:
  alias_name:                           # [allowed only A-Za-z0-9_ symbols]
    path: "path/to/project/base/dir"    # [required]
    workspace: "live"                   # [optional, "default" will be used if exists and no more choice OR ask]
    tfvar: "nonprod"                    # [optional, workspace name will be used if skip OR ask]
  ```
- done!
