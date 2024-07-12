# Terra Compose Demo

This repository is created as a demo source of the [Terra Compose tool](https://github.com/demmonico/terra-compose) usage.

`Terra Compose` is a wrapper for calling Terraform commands in the Docker.
It aims to simplify the management of multiple Terraform projects within a single mono-repo.
By solving problems with fragile and long maintenance and uncertainty about the correctness changes, caused by low visibility of the workspace.

For that, it follows the approach of the Docker Compose and puts all the needed information into the YAML config, which is visible and trackable by any VCS within the codebase.
This way it gets rid of human involvement as much as possible, minimizing the risk of human error.

**Important links, that might be useful:**
- _[An article in Medium](https://medium.com/@demmonico/multiple-terraform-projects-in-a-mono-repo-how-to-survive-a-mess-e1ec5a136d17), explaining the tool and idea behind it._
- _[A Conf42 DevOps 2024 presentation](https://youtu.be/R7Ias3EeIYI?si=uotLrdORP6SqO8ew), doing the same._

## Content

It contains different subprojects in its structure within vary Terraform versions, naming patterns and workspaces. 
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

## Demo

Here are a few demos covering different aspects of `Terra Compose`'s usage.

Pre-requisites and assumptions:
- usage AWS as a cloud provider
- keep TF state locally for simplicity, **don't do that in production!!!**
- all projects just creates VPCs and SGs for simplicity and speed

**Note**: 
- **we need** to export AWS_DEFAULT_PROFILE env var in order to let Terraform connect to AWS (for sure, only when you're using AWS)
- **we have** a good visibility on what project and workspace we are and which var files are we using
- **we have** a full transparency on what commands are we running
- **we do not depend** on the internal project's structure or it's path; alias handle that for us



<details open>
<summary>

### Installation demo

</summary>

![](_demo/screencasts/tc-install.gif)

##### Demo preparation and clean-up

```shell
# remove previous installation if exists
sudo rm -rf /usr/local/bin/tc tc-demo
# clean terminal
history -p && clear
# checking AWS credentials and export AWS profile
cat ~/.aws/credentials | grep -A 3 demmonico | sed 's/ = .*$/ = \*\*\*/'
export AWS_DEFAULT_PROFILE=demmonico && echo $AWS_DEFAULT_PROFILE
# preparing useful aliases
alias list-aws-vpcs="aws ec2 describe-vpcs --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==\`Name\`].Value|[0],CidrBlock:CidrBlock}' --no-cli-pager"
alias list-aws-sgs="aws ec2 describe-security-groups --output text --query \"SecurityGroups[*].[GroupName, VpcId]\" --no-cli-pager | sort"
list-aws-vpcs && list-aws-sgs
```

##### Demo installation

```shell
# installing Terra Compose
wget -q https://raw.githubusercontent.com/demmonico/terra-compose/master/tc \
  && chmod +x tc \
  && sudo mv -f ${PWD}/tc /usr/local/bin/tc \
  && which tc
# cloning the demo repo
git clone https://github.com/demmonico/terra-compose-demo.git tc-demo && cd tc-demo

# now we are able to run any Terraform command against any project we have locally
# we can check available actions and aliases using 'help' action
tc help
```

</details>



<details open>
<summary>

### Simple usage demo

</summary>

Recorded for _Terra Compose v1.3_

![](_demo/screencasts/tc-simple.gif)

```shell
### common >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
### example: simple plan and apply actions
# let's create a VPCs that will be used by all other projects
tree common && tc | grep -A 4 'common_'

# check that we have only default VPC
list-aws-vpcs

# plan action
# note that it automatically runs TF init and validation and shows info about the workspace and tfvars file 
tc plan common_STG
# list workspaces action
tc workspaces common_STG
# apply action based on the pre-built plan
tc apply common_STG

### example: tfvars file overriding, debug mode and run action
# plan action
tc plan common_PROD
# init and validation steps can be skipped by adding '-debug' suffix to the 'plan' and 'apply' actions
tc apply-debug common_PROD
# also we can proxy any call via 'run' action
tc run common_STG terraform state list

# check that we have +2 VPCs
list-aws-vpcs
```

</details>



<details>
<summary>

### Advanced usage demo

</summary>

Recorded for _Terra Compose v1.3_

![](_demo/screencasts/tc-advanced.gif)

```shell
### projects/portal/app >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
### example: nested project structure, backend-config option, hooks and shell action

# let's check the project structure
tree projects/portal

# we will use app component of the portal project for the demo
tree projects/portal/app && tc | grep -A 5 'portal_app_'

### example: backend-config and hooks
# plan action
tc plan portal_app_INT
# apply action, skipping init and validation steps
tc apply-debug portal_app_INT

# check that experiment state has been changed
tree projects/portal/app
# check that we have +1 SGs
list-aws-sgs

### example: hook usage and shell into container
# still contains info about the experiment state
tree projects/portal/app/.terraform
# let's prove that, shelling into container
tc shell portal_app_LIVE

### inside the container ###
terraform workspace list
exit
### END ###

# simple plan action run will handle that for us
tc plan portal_app_LIVE
tc apply-debug portal_app_LIVE

# check that we have +1 SGs
list-aws-sgs
```

</details>



<details>
<summary>

### Snippets for presentation

</summary>

Useful for development/presentation

```shell
# list of available commands
tc | grep -B 15 '>>>'
# list of available aliases
tc | grep -E '^(\s)+[A-Za-z0-9_]+:(\s)*$' | sed -e 's/^[[:space:]]*//' | awk -F ":" '{print $1}'

# record term
ttyrec /tmp/tc-install
# OR ttyrec -a /tmp/tc-install

# play records
ttyplay /tmp/tc-install
# or better way (supports playback controls) - termplay
# installs via brew, source - https://github.com/kilobyte/termrec
termplay /tmp/tc-install

# create a gif out of it
ttygif /tmp/tc-install -f
```

</details>



<details>
<summary>

## Misc

</summary>

**[!!! IMPORTANT !!!]** Following instructions should be used **VERY CAREFULLY!**

```shell
# remove existing non-default VPCs if needed
for id in $( \
  aws ec2 describe-vpcs --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==`Name`].Value|[0]}' --no-cli-pager | \
  grep -v -E 'default|None' | \
  awk '{print $2}' \
); do echo -n "Removing '$id' VPC... " && aws ec2 delete-vpc --vpc-id $id && echo "Done"; done

# list all project resources that were involved in demo
for ws in $( \
  tc | grep -E '^(\s)+[A-Za-z0-9_]+:(\s)*$' | sed -e 's/^[[:space:]]*//' | awk -F ":" '{print $1}' | grep -E 'common_|docs|portal_' \
); do echo "$ws"; done

### portal_app_LIVE destroy example ###
# check workspace
tc workspaces portal_app_LIVE
# change workspace if needed
tc run portal_app_LIVE terraform workspace select live
# destroy resources
tc run portal_app_LIVE terraform destroy --auto-approve -var-file=live.tfvars

# clean-up TF backend cache
find . -type d -name '.terraform' -exec sudo rm -rf {} \;

# find all TF state changes
find . -type f -name '*.tfstate.backup'
```

</details>
