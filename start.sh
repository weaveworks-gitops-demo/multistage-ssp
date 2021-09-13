echo "Weaveworks Workshop Setup"
echo "========================="
echo ""
echo "Installing required tools:"
echo "+ Installing kubectl"
echo ""
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo ""
echo "+ Installing aws-iam-authenticator"
echo ""
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo mv ./aws-iam-authenticator /usr/local/bin

echo ""
echo "+ Installing Weave GitOps CLI (wego)"
echo ""
curl -L https://github.com/weaveworks/weave-gitops/releases/download/v0.2.1/wego-$(uname)-$(uname -m) -o wego
chmod +x wego
sudo mv ./wego /usr/local/bin/wego

echo ""
echo "+ Installing terraform"
echo ""
TERRAFORM_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip
sudo yum -y install unzip
unzip terraform_${TERRAFORM_VER}_linux_amd64.zip -d /tmp
sudo mv /tmp/terraform /usr/local/bin/terraform
rm -rf terraform_${TERRAFORM_VER}_linux_amd64.zip

echo ""
echo "Generating key pair:"
ssh-keygen -t rsa -C "weaveworks.workshop" -f "./key.pem" -q -N ""
ssh-keyscan -H github.com > ./known_hosts