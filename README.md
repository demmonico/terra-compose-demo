# Terra Compose Demo

This repository is created as a demo source of the [Terra Compose tool](https://github.com/demmonico/terra-compose) usage.

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

## Demo run

Here are a few demos covering different aspects of `Terra Compose`'s usage.

### Demo screencast

**Note**: 
- **we need** to export AWS_DEFAULT_PROFILE env var in order to let Terraform connect to AWS (for sure, only when you're using AWS)
- **we have** a good visibility on what project and workspace we are and which var files are we using
- **we have** a full transparency on what commands are we running
- **we do not depend** on the internal project's structure or it's path; alias handle that for us

#### Plan demo

![](_demo/ignite/tc-usage-ignite-plan.gif)

#### Apply demo

![](_demo/ignite/tc-usage-ignite-apply.gif)

#### Full demo

![](_demo/full/tc-usage-full.gif)

### Demo script

#### Demo preparation and clean-up

```shell
# clean terminal
history -p && clear
# remove previous installation if exists
sudo rm -rf /usr/local/bin/tc tc-demo
# check AWS credentials and export AWS profile
cat ~/.aws/credentials | grep -A 3 demmonico | sed 's/ = .*$/ = \*\*\*/'
export AWS_DEFAULT_PROFILE=demmonico && echo $AWS_DEFAULT_PROFILE
# prepare useful aliases
alias aws-describe-vpcs="aws ec2 describe-vpcs --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==\`Name\`].Value|[0],CidrBlock:CidrBlock}' --no-cli-pager"
alias aws-describe-sgs="aws ec2 describe-security-groups --output text --query \"SecurityGroups[*].[GroupName, VpcId]\" --no-cli-pager | sort"
```

#### Demo installation

```shell
# install Terra Compose
wget -q https://raw.githubusercontent.com/demmonico/terra-compose/master/tc \
  && chmod +x tc \
  && sudo mv -f ${PWD}/tc /usr/local/bin/tc \
  && which tc
# clone repo with demo projects
git clone https://github.com/demmonico/terra-compose-demo.git tc-demo && cd tc-demo
# list of available commands
tc | grep -B 15 '>>>'
# list of available aliases
tc | grep -E '^(\s)+[A-Za-z0-9_]+:(\s)*$' | sed -e 's/^[[:space:]]*//' | awk -F ":" '{print $1}'

# now we are able to run any Terraform command against any project we have
# we can check available actions and aliases using 'help' action
tc help
```

#### Demo usage


<details><summary open>
##### Full demo script (Terra Compose v1.3)
</summary>

```shell
### common >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# creates a VPCs used by all other projects
# use-cases: simplest and with custom tfvars file
tree common && tc | grep -A 4 'common_'

# check that we have only default VPC
aws-describe-vpcs

# the simplest use-case
tc plan common_STG
tc workspaces common_STG
tc apply common_STG
# also we can proxy any call via 'run' action
tc run common_STG terraform state list

# use-case: custom tfvars file
tc plan common_PROD
tc apply common_PROD

# check that we have +2 VPCs
aws-describe-vpcs


### environments/docs >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# use-cases: env-based code structure with default WS and no tfvars file
tree environments/docs && tc | grep -A 5 'docs:'

# check that we have only default SGs
aws-describe-sgs

tc plan docs
tc apply docs

# check that we have +1 SGs
aws-describe-sgs


### projects/portal/platform >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# use-cases: nested folder structure, debug mode and run command in container
tree projects/portal
tree projects/portal/platform && tc | grep -A 3 'portal_platform_'

# use-case: nested folder structure and debug mode
tc plan portal_platform_INT
# init and validation steps can be skipped by adding '-debug' suffix to the 'plan' and 'apply' actions
tc apply-debug portal_platform_INT

# use-case: run command in container
tc run portal_platform_LIVE terraform init
tc run portal_platform_LIVE terraform workspace select live
tc plan-debug portal_platform_LIVE
tc apply-debug portal_platform_LIVE

# check that we have +2 SGs
aws-describe-sgs


### projects/portal/app >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# use-cases: backend-config, hooks and shell into container
tree projects/portal/app && tc | grep -A 5 'portal_app_'

# use-case: backend-config and hooks
tc plan portal_app_INT
tc apply-debug portal_app_INT

# check that experiment state has been changed
tree projects/portal/app
# check that we have +1 SGs
aws-describe-sgs

# use-case: hook usage and shell into container
# still contains info about the experiment state
tree projects/portal/app/.terraform
# proving that, shelling into container
tc shell portal_app_LIVE

### inside container ###
terraform workspace list
terraform init
terraform workspace list
exit
###

tc plan portal_app_LIVE
tc apply-debug portal_app_LIVE

# check that we have +1 SGs
aws-describe-sgs
```

</details>


<details><summary>
##### Full demo script (Terra Compose v1.0)
</summary>

```shell
echo "We must provide a \$AWS_PROFILE env variable" >/dev/null
export AWS_PROFILE=demmonico

aws ec2 describe-vpcs --region eu-central-1 --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==`Name`].Value|[0],CidrBlock:CidrBlock}' --no-cli-pager
aws ec2 describe-security-groups --region eu-central-1 --output text --query "SecurityGroups[*].[GroupName, VpcId]" --no-cli-pager

echo "Then we can run any Terraform command against any project we have" >/dev/null
echo "We can use a shortcuts for 'plan', 'apply' and 'workspaces'..." >/dev/null
tree common
tc run common_STG terraform init
tc workspaces common_STG
tc plan common_STG
echo "Or we can proxy calls via 'run' command..." >/dev/null
tc run common_STG state list
tc apply common_STG
tc run common_STG state list

tree projects/portal/platform
tc plan-debug portal_platform_INT
tc apply-debug portal_platform_INT

echo "Or we can have a full control over jumping into shell..." >/dev/null
tree environments/docs
tc shell docs
terraform workspace list
terraform plan
exit

aws ec2 describe-vpcs --region eu-central-1 --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==`Name`].Value|[0],CidrBlock:CidrBlock}' --no-cli-pager
aws ec2 describe-security-groups --region eu-central-1 --output text --query "SecurityGroups[*].[GroupName, VpcId]" --no-cli-pager

echo "For sure, we can check commands list and aliases using 'help' command..." >/dev/null
tc help
```

</details>


<details><summary>
##### Short demo script (Terra Compose v1.0)
</summary>

```shell
export AWS_PROFILE=demmonico
aws ec2 describe-vpcs --region eu-central-1 --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==`Name`].Value|[0],CidrBlock:CidrBlock}' --no-cli-pager
tc workspaces common_STG
tc plan common_STG
tc apply common_STG
aws ec2 describe-vpcs --region eu-central-1 --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==`Name`].Value|[0],CidrBlock:CidrBlock}' --no-cli-pager

export AWS_PROFILE=demmonico
tc plan common_STG

tc apply common_STG
```

</details>



## Misc

Useful for development\presentation
```shell
# to clear: rm -rf ~/Documents/tc-install

ttyrec ~/Documents/tc-install
# OR ttyrec -a ~/Documents/tc-install
ttygif ~/Documents/tc-install -f
```

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
