function aws-instances-list() {
    aws ec2 describe-instances --region us-east-1 | jq -r '.Reservations[].Instances[]|.InstanceId+" "+.InstanceType+" "+(.Tags[] | select(.Key == "Name").Value)'
}

function aws-instance-id() {
    aws-instances-list | grep "$1" | awk '{print $1}'
}

function ec2-instance() {
    aws-instance-id $1 | xargs aws ec2 $2-instances --instance-ids
}
