function aws-instances-list() {
    aws ec2 describe-instances --region us-east-1 | jq -r '.Reservations[].Instances[]|.InstanceId+" "+.InstanceType+" "+(.Tags[] | select(.Key == "Name").Value)'
}

function aws-instance-id() {
    aws-instances-list | grep "$1" | awk '{print $1}'
}

function aws-instance() {
    aws-instance-id $1 | xargs aws ec2 $2-instances --instance-ids
}

function ec2-launch-instance()
{
    # This image corresponds to ubuntu 20.04
    aws ec2 run-instances \
        --image-id ami-04505e74c0741db8d \
        --count 1 \
        --instance-type t2.xlarge \
        --key-name existing-key-pair-name \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=meaningful-name}]' \
        --block-device-mapping '[ {"DeviceName": "/dev/sda1", "Ebs": {"VolumeSize": 128}} ]'
}
