function aws-instances-list() {
    aws ec2 describe-instances --region us-east-1 | jq -r '.Reservations[].Instances[]|.InstanceId+" "+.InstanceType+" "+(.Tags[] | select(.Key == "Name").Value)'
}

function aws-instance-id() {
    aws-instances-list | grep "$1" | awk '{print $1}'
}

function aws-instance() {
    aws-instance-id $1 | xargs aws ec2 $2-instances --instance-ids
}


function aws-address-allocate() {
    local name=$1
    aws ec2 allocate-address \
    --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=${name}}]"
}

function aws-sgroup {
    local gname=${1:-ssh-only}
    local desc="ssh only access"

    local sgid=$(
        aws ec2 create-security-group \
            --description ${desc} \
            --group-name ${gname} \
        | jq -r ".GroupId"
    )
    aws ec2 authorize-security-group-ingress \
        --group-id ${sgid} \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0
    echo ${sgid}
}

function aws-instance-launch() {
    # This image corresponds to ubuntu 20.04
    local name=$1
    local keyname=$2
    local sgroup=$3

    # Image ids
    # ubuntu
    #     --image-id ami-04505e74c0741db8d \
    # ubuntu deep learning
    #     --image-id ami-0403bb4876c18c180 \
    # Instance types:
    #     --instance-type g4dn.xlarge \
    #     --instance-type t2.xlarge \

    # Check the security group id
    local sgid=$(aws ec2 describe-security-groups --group-names $(sgroup) | jq -r ".SecurityGroups[0].GroupId")

    aws ec2 run-instances \
        --image-id ami-0403bb4876c18c180 \
        --count 1 \
        --instance-type t2.xlarge \
        --key-name ${keyname} \
        --security-group-ids ${sgid} \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${name}}]" \
        --block-device-mapping '[ {"DeviceName": "/dev/sda1", "Ebs": {"VolumeSize": 256}} ]'

    # Wait until initialized
    sleep 10

    # Allocate the address
    local alid=$(aws-address-allocate ${name} | jq -r ".AllocationId")

    # Associate it with the instance
    (set -x; aws ec2 associate-address --instance-id $(aws-instance-id ${name}) --allocation-id $alid)
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
