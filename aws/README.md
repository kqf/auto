# Shortcuts for AWS
These are the scripts related to the most routine tasks done with EC2 instances.

## Install
Update your `.bashrc` (for `ubuntu`) or `.bash_profile`  (for Arch, OSX):

```bash
cat <(curl -s https://raw.githubusercontent.com/kqf/auto/master/aws/ec2.sh) > ~/.bashrc
```

## Usage
Now one can manipulate the instances using just it's name.
Start instances:
```bash
aws-instance-id NAME | xargs aws ec2 start-instances --instance-ids
```
Stop instances:
```bash
aws-instance-id NAME | xargs aws ec2 stop-instances --instance-ids
```
Check state
```
aws-instance-id NAME | xargs aws ec2 describe-instance-status --instance-ids
```
Where `NAME` refers to the instance name or label.

## PS
While solving the main issue this still looks ugly

