# Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools
![mlops](https://miro.medium.com/max/2174/1*DkbNb7ohIQIahvn1dRphDQ.gif)
Hello guys, back with another project which will talks about a creation of Web App using `flask` and `MLOps` tools. So lets start by provisioning ec2-instances and other services using [terraform](https://www.terraform.io/downloads.html).

You can download terraform using this link terraform. check terraform version with `terraform -version` command.

<p align="center">
  <img width="900" height="200" src="https://miro.medium.com/max/708/1*ID2fUFoQibV5kIfhVIzFRg.png">
</p>
# Initializing terraform code

The terraform init command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times. You can initialize using `terraform-init`.

<p align="center">
  <img width="700" height="800" src="https://miro.medium.com/max/792/1*iVmuZ0lP86mzd_7RZxa7AQ.png">
</p>

# Running Terraform Apply

The terraform apply command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan. You can apply the terraform code using `terraform-apply`.

<p align="center">
  <img width="900" height="200" src="https://miro.medium.com/max/792/1*SWaEzkz6U1MjNTLQWkZcLg.png">
</p>

<p align="center">
  <img width="900" height="500" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/1.gif">
</p>
```
provider "aws" {
  region     = "ap-south-1"
  access_key = "XXXXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXX"
  profile    = "Amit"
}
```
The terraform code will be starting by taking the user name which you have created in your AWS account. You need to give the region also in the provider block. `provier → aws` (else your cloud name). You also need to provide `access key` and `secret key` of your user.
# Creating Variables:
```
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "192.168.0.0/16"
}variable "cidr_subnet1" {
  description = "CIDR block for the subnet"
  default = "192.168.1.0/24"
}variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "ap-south-1"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Production"}
```

Above i have created variable with the name `cidr_vpc`, `cidr_subnet1`, `availability_zone`, `environment_tag`. The terraform code will be starting by taking the user name which you have created in your AWS account. You need to give the region also in the provider block. `provier → aws` (else your cloud name). You also need to provide `access key` and `secret key` of your user.

# Creating VPC:
Amazon Virtual Private Cloud (*Amazon VPC*) enables you to launch AWS resources into a virtual network that you’ve defined. This virtual network closely resembles a traditional network that you’d operate in your own data center, with the benefits of using the scalable infrastructure of AWS.
```
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = truetags ={
    Environment = "${var.environment_tag}"
    Name= "TerraformVpc"
  }
}
```
The above code will create VPC. The above vpc block accept the `cidr_block`. you can enable dns support given to ec2 instances after launching. You can give the tag name to the above vpc. Here i have given “*TerraformVpc*”.
![vpc](https://miro.medium.com/max/792/1*kOQ27W71o7OH6Y5Kye4FFw.jpeg)

# Creating Subnets:
Subnetwork or subnet is a logical subdivision of an IP network. The practice of dividing a network into two or more networks is called subnetting. AWS provides two types of subnetting one is Public which allow the internet to access the machine and another is private which is hidden from the internet.

```
resource "aws_subnet" "subnet_public1_Lab1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_subnet1}"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags ={
    Environment = "${var.environment_tag}"
    Name= "TerraformPublicSubnetLab1"
    }
  }
  ```
  
The above code will create subnet. The subnet block accepts `vpc_id`, `cidr_block`, `map_public_ip_on_launch`(assign public IP to instance after launching), availability_zone. You can give tags for easy recognition after creating subnets.
![subnets](https://miro.medium.com/max/792/1*QjWFMA0onG5q30RxUKH16w.jpeg)
  
# Creating Security Group

A security group acts as a virtual firewall for your EC2 instances to control incoming and outgoing traffic. If you don’t specify a security group, Amazon EC2 uses the default security group. You can add rules to each security group that allow traffic to or from its associated instances.
```
resource "aws_security_group" "TerraformSG" {
  name = "TerraformSG"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags ={
    Environment = "${var.environment_tag}"
    Name= "TerraformSG"
  }
}
```
The above block of code will create a security group. It accepts the respective parameters name(name of the security group), `vpc_id`, `ingress`(inbound rule) here i have given “*all traffic*”. “-1” means all. *from_port= 0* *to_port=0* (0.0.0.0) that means we have disabled the firewall. you need to mention the range of IP’s you want have in inbound rule.
The egress rule is the outbound rule. I have taken (0.0.0.0/0) means all traffic i can able to access from this outbound rule. You can give the name of respective Security Group.
![sg](https://miro.medium.com/max/792/1*xt_vYNZogjGT3_4cd_wtDQ.jpeg)
# Creating InternetGateway:
An internet gateway serves two purposes: to provide a target in your VPC route tables for internet-routable traffic, and to perform network address translation (NAT) for instances that have been assigned public IPv4 addresses.
```
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"
tags = {
    Name = "Terraform_IG"
  }
}
```
the above code will create you respective internet gateway. you need to specify on which vpc you want to create internet gateway. Also you can give name using tag block.
![ig](https://miro.medium.com/max/792/1*0r67Qq1XzZjLfOST5GEsjQ.jpeg)
# Creating Route Table:
A route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.
```
resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.vpc.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "TerraformRoteTable"
  }
}
```
You need to create a route table for the internet gateway you have created above. Here, i am allowing all the IP rage. So my ec2 instances can connect to the internet world. we need to give the vpc_id so that we can easily allocate the routing table to respective vpc. You can specify the name of the routing table using tag block.
![rt](https://miro.medium.com/max/792/1*6Fxfdop0OVHCcZiydegeSg.jpeg)

# Route Table Association To Subnets
We need to connect the route table created for internet gateways to the respective subnets inside the vpc.
```
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  route_table_id = "${aws_route_table.r.id}"
}
```
You need to specify which subnets you want to take to the public world. As if the subnets gets associated(connected) to the  `Internet Gateway` it will be a public subnet. But if you don’t associate subnets to the Internet gateway routing table then it will known as private subnets. The instances which is launched in the private subnet is not able to connected from outside as it will not having public IP, also it will not be connected to the Internet Gateway.
You need to specify the routing table for the association of the subnets. If you don’t specify the routing table in the above association block then subnet will take the vpc’s route table. So if you want to take the ec2 instances to the public world then you need to specify the router in the above association block. Its upon you which IP range you want you ec2 instances to connect. Here i have give 0.0.0.0/0 means i can access any thing from the ec2 instances.

# Creating Ec2 Instances:

An EC2 instance is nothing but a virtual server in Amazon Web services terminology. It stands for Elastic Compute Cloud. It is a web service where an AWS subscriber can request and provision a compute server in AWS cloud. … AWS provides multiple instance types for the respective business needs of the user.
```
resource "aws_instance" "Ansible_Controller_Node" {
  ami           = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "Ansible_Controller_Node"
  }}
resource "aws_instance" "K8S_Master_Node" {
  ami           = "ami-0d758c1134823146a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "K8S_Master_Node"
  }}
resource "aws_instance" "K8S_Slave1_Node" {
  ami           = "ami-0d758c1134823146a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "K8S_Slave1_Node"
  }}
resource "aws_instance" "K8S_Slave2_Node" {
  ami           = "ami-0d758c1134823146a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "K8S_Slave2_Node"
  }}
resource "aws_instance" "JenkinsNode" {
  ami           = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "JenkinsNode"
  }}
resource "aws_instance" "DockerNode" {
  ami           = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "DockerNode"
  }
}
```
<p align="center">
  <img width="900" height="100" src="https://miro.medium.com/max/792/1*zepMP7rSkFCScnN_2cYYew.jpeg">
</p>
instances you can see this video to launch the instances using terraform. https://youtu.be/N4FJayHG0hs

# Creating Machine learning Model:

Here now, we have to create a machine learning model. As the dataset is of classification problem then we have to choose classification algorithms. Here i trained the model with `Logistic Regression`, `RandomForestClassifier`, `DecisionTree Classsifier`, `GradientBoostingClassifier`.
# Logistic Regression:
```
from sklearn.linear_model import LogisticRegression
lr_model=LogisticRegression()
lr_model.fit(X_train, y_train)
lr_y_model= lr_model.predict(X_test)
lr_y_model
from sklearn.metrics import accuracy_score
print("Logistic Regression Accuracy: ", accuracy_score(y_test, lr_y_model))
```

```
Logistic Regression Accuracy:  0.9180327868852459/opt/conda/lib/python3.7/site-packages/sklearn/linear_model/_logistic.py:765: ConvergenceWarning: lbfgs failed to converge (status=1):
STOP: TOTAL NO. of ITERATIONS REACHED LIMIT.

Increase the number of iterations (max_iter) or scale the data as shown in:
    https://scikit-learn.org/stable/modules/preprocessing.html
Please also refer to the documentation for alternative solver options:
    https://scikit-learn.org/stable/modules/linear_model.html#logistic-regression
  extra_warning_msg=_LOGISTIC_SOLVER_CONVERGENCE_MSG)
```
# RandomForestClassifier:
```
from sklearn.ensemble import RandomForestClassifier
rfc_model = RandomForestClassifier(n_estimators=10000, max_depth=100)
rfc_model
rfc_model.fit(X_train, y_train)
rfc_y_pred = rfc_model.predict(X_test)
rfc_y_pred
from sklearn.metrics import accuracy_score
print("Random Forest Accuracy: ", accuracy_score(y_test, rfc_y_pred))
```
`Random Forest Accuracy: 0.7704918032786885`
# DecisionTreeClasssifier:
```
from sklearn.tree import DecisionTreeClassifier
dt_model = DecisionTreeClassifier()
dt_model.fit(X_train, y_train)
dt_y_pred=dt_model.predict(X_test)dt_y_pred
from sklearn.metrics import accuracy_score
print("Decision Tree Accuracy: ", accuracy_score(y_test, dt_y_pred))
```
`Decision Tree Accuracy: 0.6721311475409836`
# GradientBoostingClassifier:
```
from sklearn.ensemble import GradientBoostingClassifier
GB_model = GradientBoostingClassifier(n_estimators=1000)
GB_model.fit(X_train, y_train)
y_pred_GB = GB_model.predict(X_test)
y_pred_GB
from sklearn.metrics import accuracy_score
accuracy_score(y_test, y_pred_GB)
```
`GradientBoostingClassifer Accuracy: 0.7868852459016393`
From the above model creation and comparision `Logistic Regression` is giving much accuracy but i am taking model of `Random Forest` and saving it to `.h5` extension.

<p align="center">
     <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/2.gif">
</p>

# Saving RandomForestClassifier Model:
```
import joblib
joblib_file = "RandomForest_Heart_Prediction.h5"
joblib.dump(lr_model, joblib_file)
```
This above code will create a file named `RandomForest_Heart_Prediction.h5` and we have to use this model while create a docker image in which flask we have to install. Below is the code for `dockerfile`. `Code link`→ https://colab.research.google.com/drive/1_PkhVlrW5rC45Ehccxloosl2-gYPcklN?usp=sharing

You can watch below video to for refernce for creating Machine learning model. https://youtu.be/Du9mFr226I4
Now we need to build the image using below `dockerfile code`.
```
FROM centos:latestRUN yum install python3  python3-devel   gcc-c++ -y && \
    python3 -m pip install --upgrade --force-reinstall pip && \
    yum install sudo -y && \
    yum install --assumeyes  python3-pip && \
    pip install keras && \
    pip install tensorflow --no-cache-dir  tensorflow && \
    pip install --upgrade pip tensorflow && \
    pip3 install flask && \
    pip3 install joblib && \
    pip3 install sklearn && \
    mkdir  /heart_app &&  \
    mkdir /heart_app/templatesCOPY  Randorm_Forest_Heart_Prediction.h5    /heart_app
COPY  app.py  /heart_app
COPY  myform.html  /heart_app/templates
COPY  result.html   /heart_app/templates
EXPOSE  4444WORKDIR  /heart_app
CMD export FLASK_APP=app.pyENTRYPOINT flask  run --host=0.0.0.0    --port=4444
```
To build the docker image use below command.  `docker build -t image_name:version   .` You can watch enlow video for reference https://youtu.be/bUBOI-5Ya6U
Now we need to configure epel repository so that ansible installation would be easy.

`dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm`

<p align="center">
    <img width="900" height="400" src="https://miro.medium.com/max/792/1*2rFJvM_lRZiSbkFaQFZf7Q.jpeg">
</p>

Now the above epel has created your repo ready to install ansible. Now you can use `yum install ansible -y` to install ansible.

<p align="center">
    <img width="900" height="400" src= "https://miro.medium.com/max/792/1*A3MqtBYaNnwJPL4FYOhpvQ.jpeg">
</p>
As you can see i have launched 6 instances and those are `Ansible Controller node`, `Kubernetes Master`, `Slave1` and `Slave2` nodes, `Jenkins` node and `docker node`.

## Ansible Controller Node: 
In this node we have to install ansible and to use Dynamic Inventory to configure `Kubernetes Cluster`, `jenkins` and `docker image`. We need to write the playbook for the same. For installing ansible you can use this `epel release repo` .

## Creating playbook for configuring kubernetes cluster:
Before creating playbooks we have create roles to manage the code properly. So, here i am creating three roles i.e master, slaves and jenkins configuration. you can create roles via below commands:
```
ansible-galaxy init master     # master role
ansible-galaxy init slaves     # slave role
ansible-galaxy init jenkins    # jenkins role
```
<p align="center">
    <img width="900" height="300" src="https://miro.medium.com/max/792/1*XgS3ik7RdhcH6Vvb4R5vBg.jpeg">
</p>

Now create a directory eg. `/myinventory` in Ansible controller node. and you need use dynamic inventory plugins. using `wget` command download the `ec2.py` and `ec2.ini` plugins inside `/myinventory` folder.
```
This 👇 command will create a ec2.py dynamic inventory file 
wget   https://raw.githubusercontent.com/ansible/ansible/stable-2.9/contrib/inventory/ec2.py
This 👇 command will create a ec2.ini dynamic inventory file
wget   https://raw.githubusercontent.com/ansible/ansible/stable-2.9/contrib/inventory/ec2.ini
You need to make executable those two above files
chmod  +x ec2.py 
chmod  +x ec2.ini
```
<p align="center">
    <img width="900" height="400" src="https://miro.medium.com/max/792/1*-WsGvmv5mIO__cM6seL5mA.jpeg">
</p>

```
You need to give below inputs inside ec2.ini file.
aws_region='ap-south-1' 
aws_access_key=XXXX
aws_secret_access_key=XXXX          

After that export all these commands so boto can use this commands freely.
export AWS_REGION='ap-south-1'
export AWS_ACCESS_KEY_ID=XXXX
export AWS_ACCESS_SECRET_KEY=XXXX

Now we have to edit inside ec2.py file. This file written in python 2 but we are using python 3 so we need to edit the header.

#!/usr/bin/python3
```

![ec.ini](https://miro.medium.com/max/792/1*uUZTGYviA7sEfaOBqMzD-g.jpeg)

![ec2.ini](https://miro.medium.com/max/792/1*TpPvv-HGO2oawgUQahhXKg.jpeg)

Updating `ec2.py` file from python to python3.

![ec2.py](updating ec2.py file from python to python3..)

Install `boto` and `boto3` libraries so ansible can connect to aws services and launch the respective services. To install `boto` and `boto3` using below command.

```
pip3 install boto           # installing boto
pip3 install boto3          # installing boto3
```

<p align="center">
    <img width="900" height="400" src="https://miro.medium.com/max/792/1*fqM8DO2PImcqZ5LRd_VXaw.jpeg">
</p>
Now we can create configuration file of ansible. Your ansible.cdf file must include below configuration codes.

```
[defaults]
inventory= /my_inventory
host_key_checking=false
ask_pass=false
remote_user=ubuntu
private_key_file=/root/mykey.pem
command_warnings=False
[privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False
```
Note: Here, we have given `remote_user=ubuntu` because the master and slaves of the kuberenetes cluster is launched via ubuntu image. The main reson to use ubuntu image is due to we are using crio as a intermediate `container runtime engine`. Only ubuntu supports the repo for `crio` installation. Therefore we are using `ubuntu image`.

Now this `ansible.cfg` file will helps us to configure instances on AWS dynamically. `inventory=/myinventory` (it includes ec2.ini and ec2.py) files. `private_key_file` should be the key in `.pem` format of the instances. `host_key_checking=false` will allow to give proper ssh connection. `privilege_escalation` should be concluded in the ansible.cfg file to configure the system using `sudo` power. Your `ansible.cfg` file will look like this below snip.
<p align="center">
    <img width="900" height="400" src="https://miro.medium.com/max/792/1*fqM8DO2PImcqZ5LRd_VXaw.jpeg">
</p>
Now we are ready to go and configure instanes on aws. use `ansible all --list-hosts` to check the dynamic inventory is working or not.
<p align="center">
    <img width="900" height="200" src="https://miro.medium.com/max/792/1*A9nxto6shUV3WWm9BRYJRA.jpeg">
</p>
If you see the ip’s then your instanes are running on aws and it ansible dynamic inventory is successfully connect to aws.

# Configuring Crio repository:
Now first we have to configure Master node and then slave nodes. To configure crio in ubuntu i have created a script from below codes and saved into `crio.sh` and save in a `/root/` directory.
```
OS=xUbuntu_20.04
VERSION=1.20cat >>/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list<<EOF
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOFcat >>/etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list<<EOF
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOFcurl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers-cri-o.gpg add -
```
<p align="center">
    <img width="900" height="400" src="https://miro.medium.com/max/792/1*tZ9xk5Um7RLUElqwAjLzzg.jpeg">
</p>
Now to configure master you need to go inside `master/tasks/main.yml` file to create tasks for configuration.
# Configuring master node:
```
# First we have to copy the crio.sh cript to master node and run it to configure crio in master.
- name: "Copying Script to K8S Master Node"
  copy:
     src: "/root/crio.sh"
     dest: "/root/"
# Running crio.sh script
- name: "running script"
  shell: "bash /root/crio.sh"
  register: crioscript
- debug:
    var: crioscript.stdout_lines# updating packages
- name: "Updating apt"
  shell: "apt update"
  ignore_errors: yes
  register: yumupdate
- debug:
    var: yumupdate.stdout_lines# installing crio
- name: "Instlling CRIO"
  shell: "apt install -qq -y cri-o cri-o-runc cri-tools"
  ignore_errors: yes
  register: crioinstall
- debug:
   var: crioinstall.stdout_lines# reloading daemon
- name: "Reloading System and CRIO"
  shell: "systemctl daemon-reload"# enabling and starting crio 
- name: "enabling CRIO"
  shell: "systemctl enable --now crio"
  ignore_errors: yes
  register: criostart
- debug:
   var: criostart.stdout_lines# Configuring repo for Kubeadm Installing Kubeadm 
- name: "Installing KubeAdm"
  shell: |
   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
   apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
   apt install -qq -y kubeadm=1.20.5-00 kubelet=1.20.5-00 kubectl=1.20.5-00
  ignore_errors: yes
  register: kubeadminstall
- debug:
   var: kubeadminstall.stdout_lines# Creating a overlay network
- name: "Adding Overlay Network"
  shell: |
   cat >>/etc/modules-load.d/crio.conf<<EOF
   overlay
   br_netfilter
   EOF
  ignore_errors: yes
  register: overlay# adding filters to overlay network 
- name: "Creating Overlay and Netfilter"
  shell: "modprobe overlay"
- shell: "modprobe br_netfilter"
  ignore_errors: yes# enabling iptables by changing values to 1
- name: "Chnaging Iptables values to 1"
  shell: |
   cat >>/etc/sysctl.d/kubernetes.conf<<EOF
   net.bridge.bridge-nf-call-ip6tables = 1
   net.bridge.bridge-nf-call-iptables  = 1
   net.ipv4.ip_forward                 = 1
   EOF
  ignore_errors: yes# running sysctl --system
- name: "Running sysctl --system"
  shell: "sysctl --system"
  register: sysctl
- debug:
     var: sysctl.stdout_lines# changing cgroup drivers to pod
- name: "Chnaging group drivers"
  shell: |
   cat >>/etc/crio/crio.conf.d/02-cgroup-manager.conf<<EOF
   [crio.runtime]
   conmon_cgroup = "pod"
   cgroup_manager = "cgroupfs"
   EOF# reloading daemon
- name: "Reloading System and CRIO"
  shell: "systemctl daemon-reload"
  ignore_errors: yes# enabling crio
- name: "enabling crio"
  shell: "systemctl enable --now crio"
  ignore_errors: yes# restarting crio
- name: "Restarting CRIO"
  shell: "systemctl restart crio"
  ignore_errors: yes# changing fstab and disabling firewall
- name: "Changing Fstab and disable ufw"
  shell: |
     sed -i '/swap/d' /etc/fstab
     swapoff -a
     systemctl disable --now ufw
  ignore_errors: yes# Restarting kubelet
- name: "restarting kubelet"
  shell: "systemctl restart kubelet"# initializing master node with cidr 192.168.0.0/16
- name: "Initilaizing Master"
  shell: "kubeadm init --apiserver-advertise-address=192.168.1.86  --pod-network-cidr=192.168.0.0/16    --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem"
  ignore_errors: yes
  register: master
- debug:
   var: master.stdout_lines- name: "Creating .kube directory"
  shell: "mkdir -p $HOME/.kube"- name: "Copying /etc/kubernetes/admin.conf $HOME/.kube/config"
  shell: "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config"- name: "changing owner permission"
  shell: "sudo chown $(id -u):$(id -g) $HOME/.kube/config"# creating calico overlay network to create a connection between the master and slave nodes
- name: "Using Calico as Overlay Network"
  shell: "kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml"
  ignore_errors: yes
  register: callico
- debug:
    var: callico.stdout_lines# generating token
- name: "Printing token"
  shell: "kubeadm token create --print-join-command"
  register: token- debug:
    var: token.stdout_lines
```

# Configuring slave nodes:
```
# First we have to copy the crio.sh cript to master node and run it to configure crio in slaves.
- name: "Copying Script to K8S Master Node"
  copy:
     src: "/root/crio.sh"
     dest: "/root/"# running crio.sh script
- name: "running script"
  shell: "bash /root/crio.sh"
  register: crioscript
- debug:
    var: crioscript.stdout_lines# updating packages
- name: "Updating apt"
  shell: "apt update"
  ignore_errors: yes
  register: yumupdate
- debug:
    var: yumupdate.stdout_lines# Installing Crio
- name: "Instlling CRIO"
  shell: "apt install -qq -y cri-o cri-o-runc cri-tools"
  ignore_errors: yes
  register: crioinstall- debug:
   var: crioinstall.stdout_lines# Reloading Deamon
- name: "Reloading System and CRIO"
  shell: "systemctl daemon-reload"# enabling crio
- name: "enabling CRIO"
  shell: "systemctl enable --now crio"
  ignore_errors: yes
  register: criostart
- debug:
   var: criostart.stdout_lines# installing and configuring repo for kubeadm
- name: "Installing KubeAdm"
  shell: |
   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
   apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
   apt install -qq -y kubeadm=1.20.5-00 kubelet=1.20.5-00 kubectl=1.20.5-00
  ignore_errors: yes
  register: kubeadminstall
- debug:
   var: kubeadminstall.stdout_lines# creating overlay network
- name: "Adding Overlay Network"
  shell: |
   cat >>/etc/modules-load.d/crio.conf<<EOF
   overlay
   br_netfilter
   EOF
  ignore_errors: yes
  register: overlay# adding filters to overlay network
- name: "Creating Overlay and Netfilter"
  shell: "modprobe overlay"
- shell: "modprobe br_netfilter"
  ignore_errors: yes# enabling iptables by changing values to 1
- name: "Chnaging Iptables values to 1"
  shell: |
   cat >>/etc/sysctl.d/kubernetes.conf<<EOF
   net.bridge.bridge-nf-call-ip6tables = 1
   net.bridge.bridge-nf-call-iptables  = 1
   net.ipv4.ip_forward                 = 1
   EOF
  ignore_errors: yes# running sysctl --system
- name: "Running sysctl --system"
  shell: "sysctl --system"
  register: sysctl
- debug:
     var: sysctl.stdout_lines# changing cgroup drivers to pod
- name: "Changing group drivers"
  shell: |
   cat >>/etc/crio/crio.conf.d/02-cgroup-manager.conf<<EOF
   [crio.runtime]
   conmon_cgroup = "pod"
   cgroup_manager = "cgroupfs"
   EOF# pulling images using kubeadm
- name: "Pulling Images using KubeAdm"
  shell: "kubeadm config  images pull"
  changed_when: false
  register: kubeadm
- debug:
    var: kubeadm.stdout_lines# reloading daemon
- name: "Reloading System and CRIO"
  shell: "systemctl daemon-reload"
  ignore_errors: yes# enabling crio
- name: "enabling crio"
  shell: "systemctl enable --now crio"
  ignore_errors: yes# restarting crio
- name: "Restarting CRIO"
  shell: "systemctl restart crio"
  ignore_errors: yes# changing fstab and disabling firewall
- name: "Changing Fstab and disable ufw"
  shell: |
     sed -i '/swap/d' /etc/fstab
     swapoff -a
     systemctl disable --now ufw
  ignore_errors: yes# Restarting kubelet
- name: "restarting kubelet"
  shell: "systemctl restart kubelet"# Joining Slaves with token
- name: "Joining Slaves to Master Node"
  shell: "{{ master_token  }}"
  ignore_errors: yes
  register: init
- debug:
    var: init.stdout_lines  
```
# Configuring Jenkins Node::
```
---
# tasks file for jenkins# copying jdk file in jenkins node 
- name: "Copying Jdk file to jenkins Node"
  copy:
    src: "/root/jdk-8u281-linux-x64.rpm"
    dest: "/root/"
  ignore_errors: yes# copying jenkins file to jenkins node
- name: "Copying Jenkins file to jenkins Node"
  copy:
    src: "/root/jenkins-2.282-1.1.noarch.rpm"
    dest: "/root/"
  ignore_errors: yes# Installing JDK
- name: "Installing JDK"
  shell: "rpm -ivh /root/jdk-8u281-linux-x64.rpm"
  ignore_errors: yes
  register: jdk
- debug:
     var: jdk.stdout_lines# Installing Jenkins
- name: "Installing Jenkins"
  shell: "rpm -ivh /root/jenkins-2.282-1.1.noarch.rpm"
  ignore_errors: yes
  register: jenkins
- debug:
     var: jenkins.stdout_lines# Staring jenkins
- name: "Starting Jenkins Server"
  shell: "systemctl start jenkins"# enabling jenkins
- name: "enabling Jenkins Server"
  shell: "systemctl enable jenkins"
```
Now the `mainplaybook` will contains the roles of `master`, `slaves` and `jenkins` respectively.

# Main Playbook:
```
# Configuring master node
- hosts: ["tag_Name_K8S_Master_Node"]
  roles:
  - name: "Configuring Master Node"
    role:  "/root/roles/master"# Configuring slaves node
- hosts: ["tag_Name_K8S_Slave1_Node", "tag_Name_K8S_Slave2_Node"]
  vars_prompt:
  - name: "master_token"
    prompt: "Enter Token To Join To Master: "
    private: no
  roles:
  - name: "Configuring Slave Node"
    role:  "/root/roles/slaves"# Configuring jenkins node
- hosts: ["tag_Name_JenkinsNode"]
  remote_user: "ec2-user"
  roles:
  - role: "/root/roles/jenkins"
```
# Running Main Playbook:

<p align="center">
    <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/3.gif">
</p>

<p align="center">
    <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/3.gif">
</p>

<p align="center">
    <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/5.gif">
</p>

You can run the `mainplaybook.yml` using `ansible-playbook mainplaybook.yml`


You can check this video for the complete configuration process. https://youtu.be/xTBN1ArNbP8
Now login to jenkins jenkins node using `public_ip:8080`. We need to set the password for jenkins node intially. This process needed to be done only once. You will be landed on this page and it will ask for password.

<p align="center">
    <img width="900" height="300" src="https://miro.medium.com/max/792/1*nYJPAJAXfkeOKUvNuzRUCQ.jpeg">
</p>

copy the `/var/lib/jenkins/secrets/initialAdminPassword` the location and using cat command you can take the passowrd like this in the below image.

![jenkinspass](https://miro.medium.com/max/792/1*uSivwOLfi4z8Nm4016lH4A.jpeg)

Now copy the password and pate in the `Administrator password` section and then click on `continue`.

<p align="center">
    <img width="900" height="300" src="https://miro.medium.com/max/792/1*QZ_QH2s8_RTRYae68Y8QpQ.jpeg">
</p>

After that you need to create a password because this password is too long and hard to remember. So below are the steps shown in the video to create the password and to install the restive plugins. Ensure that you have to install below plugins. watch this video for reference https://youtu.be/1spUYaUKaao

Plugins from below lists needed to be installed:

   1. `ssh`: ssh plugins need to install for connecting the kubernetes servers.
   2. `Gihub`: Github plugins need to install to us *SCM services*.
   3. `Pipeline`: Pipline plugin will helps you to automate the jobs and make your setup easy.
   4. `Multibranch pipeline`: Multibranch pipeline plugin will helps you to pulls the code from different branches. In this project i have created two branch i.e main(default) and developer branch. The code should be in both the branch in `Jenkinsfile` named file. So multibranch will scan the repository and both the branches and will pull the code and create jobs with names “*main*” job and “*developer*” job. If developer branch job run successfully then and if main branch wants to commit then they can.

Now you have to create a repository in github and add the pipeline code in that repo inside `Jenkinsfile`.


<p align="center">
    <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/7.gif">
</p>

```
pipeline {     
    agent any      
       stages { 
         stage('BuildingHeartPrectionPod'){   
           steps {                   
           sh 'sudo kubectl create deployment mlopsheartpred  --image=docker123kubernetes123/heartprediction_mlops:v1   --kubeconfig /root/admin.conf'
           sh 'sudo kubectl expose deployment mlopsheartpred --type=NodePort  --port=4444   --kubeconfig /root/admin.conf'                          
           sh 'sudo kubectl get pod -o wide   --kubeconfig /root/admin.conf'                                
    }       
 }         
       stage('gettingpod'){   
           steps {                     
              sh 'sudo kubectl get pod -o wide  --kubeconfig /root/admin.conf'                  
              sh 'sudo kubectl get svc    --kubeconfig /root/admin.conf'           
          } 
       }   
 }
}
```
<p align="center">
    <img width="900" height="400" src="https://miro.medium.com/max/792/1*KFL_5ydL407-37FnyeM-YQ.jpeg">
</p>

Now we need to copy the url of repository and you have to create a new job with `multibranch pipeline` and you need to to add source “git” and paste the url and save the job.

<p align="center">
    <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/8.gif">
</p>
Now you have to just and it will create two `jobs` one for `main branch` and another for `developer branch`. As soon as the developer branch succeed it will create a deployment in the `Kubernetes cluster` and behind the scene it will launch pod and it also expose that `deployment` so any client can access the page.

<p align="center">
    <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/9.gif">
</p>

Now you can access the webapp with the public ip of the slave node and with the exposed port.

<p align="center">
    <img width="900" height="400" src="https://raw.githubusercontent.com/amit17133129/Heart_Diseases_Prediction_App_Creation_Using_MLOps_Tools/main/Images/9.gif">
</p>
