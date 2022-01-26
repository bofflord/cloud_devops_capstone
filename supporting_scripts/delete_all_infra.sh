############# CONFIGURATION #############
AWS_PROFILE=$1
EKS_CLUSTER_NAME="ML-APP-CLUSTER"
AWS_REGION="us-east-1"
############# DELETION #############
# delete Cloudfront stack
aws cloudformation delete-stack \
--stack-name CloudFrontStack  \
--region ${AWS_REGION} \
--profile ${AWS_PROFILE}
# get VPC_ID
VPC_ID=$(aws eks describe-cluster \
        --name ${EKS_CLUSTER_NAME} \
        --query "cluster.resourcesVpcConfig.vpcId" \
        --region ${AWS_REGION} \
        --output text --profile ${AWS_PROFILE})
# Fetch the fargate profiles
PROFILES=($(aws eks list-fargate-profiles \
--cluster-name ${EKS_CLUSTER_NAME} \
--region ${AWS_REGION} \
--no-paginate \
--output text --profile ${AWS_PROFILE} | awk '{print $2}'))
# remove default profile from list
PROFILES=(${PROFILES[@]/fp-default})
echo profile names: "${PROFILES[@]}"
if [ ! -z "$PROFILES" ] # if variable is not null
    then
        for PROFILE in "${PROFILES[@]}"
        do
            echo "removing AWS Fargate profile: ${PROFILE}"
            eksctl delete fargateprofile \
            --name ${PROFILE} \
            --cluster ${EKS_CLUSTER_NAME} \
            --region ${AWS_REGION}
            # wait for 3 minutes since only one fargate profile can be deleted at the same time
            echo "Wait for 3 minutes to ensure deletion is complete before next profile is tackled..."
            sleep 3m
        done
fi
# Delete all Load Balancers
ALBS=($(aws elbv2 describe-load-balancers \
--query "LoadBalancers[].{LoadBalancerArn: LoadBalancerArn, VpcId: VpcId}[?VpcId == '${VPC_ID}']" \
--output text \
--region ${AWS_REGION} \
--profile ${AWS_PROFILE} | awk '{print $1}'))
if [ ! -z "$ALBS" ] # if variable is not null
    then
        for ALB in "${ALBS[@]}"
        do
            echo "removing application load balancer: ${ALB}"
            aws elbv2 delete-load-balancer \
            --load-balancer-arn ${ALB} \
            --region ${AWS_REGION} \
            --profile ${AWS_PROFILE}
        done
fi
# Delete EKS Cluster
eksctl delete cluster --name ${EKS_CLUSTER_NAME} --region ${AWS_REGION} --profile ${AWS_PROFILE}
sleep 1m
# Delete Network Interfaces
# NIS=($(aws ec2 describe-network-interfaces \
# --query "NetworkInterfaces[].{NetworkInterfaceId: NetworkInterfaceId, VpcId: VpcId}[?VpcId == '${VPC_ID}']" \
# --output text \
# --region ${AWS_REGION} --profile ${AWS_PROFILE} | awk '{print $1}'))
# if [ ! -z "$NIS" ] # if variable is not null
#     then
#         for NI in "${NIS[@]}"
#         do
#             echo "removing network interface: ${NI}"
#             aws ec2 delete-network-interface \
#             --network-interface-id ${NI} \
#             --region ${AWS_REGION} \
#             --profile ${AWS_PROFILE}
#         done
# fi
# Delete NAT gateways
# TODO --network-interface-id
# Delete VPC
# aws ec2 delete-vpc --vpc-id ${VPC_ID} --region ${AWS_REGION} --profile ${AWS_PROFILE}
# Get array of CloudFormation stacks with Key 'alpha.eksctl.io/cluster-name' and Value 'ML-APP-CLUSTER'
# STACKS=($(aws cloudformation describe-stacks \
# --query "Stacks[].{StackName: StackName, Value: Tags[0].Value}[?Value == '${EKS_CLUSTER_NAME}']" \
# --output text \
# --region ${AWS_REGION} --profile ${AWS_PROFILE} | awk '{print $1}'))
# # Delete Cloudformation stacks if they still exist
# if [ ! -z "$STACKS" ] # if variable is not null
#     then
#         for STACK in "${STACKS[@]}"
#         do
#             echo "removing application load balancer: ${STACK}"
#             aws cloudformation delete-stack \
#             --stack-name ${STACK} \
#             --region ${AWS_REGION} \
#             --profile ${AWS_PROFILE}
#         done
# fi