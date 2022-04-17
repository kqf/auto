function aws-instances-list() {
    aws ec2 describe-instances --region us-east-1 | jq -r '.Reservations[].Instances[]|.InstanceId+" "+.InstanceType+" "+(.Tags[] | select(.Key == "Name").Value)'
}

function aws-instance-id() {
    aws-instances-list | grep "$1" | awk '{print $1}'
}

function aws-instance() {
    aws-instance-id $1 | xargs aws ec2 $2-instances --instance-ids
}

function aws-instance-launch() {
    # This image corresponds to ubuntu 20.04
    local name=$1
    local keyname=$2

    aws ec2 run-instances \
        --image-id ami-04505e74c0741db8d \
        --count 1 \
        --instance-type t2.xlarge \
        --key-name ${keyname} \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${name}}]" \
        --block-device-mapping '[ {"DeviceName": "/dev/sda1", "Ebs": {"VolumeSize": 128}} ]'

    local alid=$(aws ec2 allocate-address \
    --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=${name}}]" | \
    jq -r ".AllocationId")

    aws ec2 associate-address --instance-id $(aws-instance-id ${name}) --allocation-id $alid
}

function aws-instance-ssh-config() {
    local name=$1
    local iid=$(aws-instance-id ${name})
    local ip=$(aws ec2 describe-addresses | \
        jq -r ".Addresses[] | select( .InstanceId == \"${iid}\" ) | .PublicIp")

cat << EOF
Host $1
    HostName ${ip}
    User ubuntu
    ForwardAgent yes
    IdentityFile ~/.ssh/existing-key.pem
EOF
}
