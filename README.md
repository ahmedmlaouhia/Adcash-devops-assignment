# Adcash DevOps Assignment

## Step 1

**Tasks**

- Create web server in express with typescript serving Gandalf’s picture at `/gandalf`.
- Return current Colombo time at `/colombo`.
- Expose Prometheus metrics tracking requests to `/gandalf` and `/colombo`.
- Deploy to K8s with static IP address (Load Balancer).
- Restrict ingress to TCP port 80 only.

### Kubernetes deployment steps

1. Build and tag the container image locally:

   ```bash
   docker build -t masterbohmid/gandalf:latest step1
   ```

2. Push the image to DockerHub so GKE can pull it:

   ```bash
   docker login --username masterbohmid
   docker push masterbohmid/gandalf:latest
   ```

3. Point `kubectl` at the target Google Kubernetes Engine cluster with the kubeconfig file in ~/.kube/config.

4. Apply the manifests from the repo root to create the namespace, deployment, service, and network policy:

   ```bash
   kubectl apply -f step1/k8s/namespace.yaml
   kubectl apply -f step1/k8s/deployment.yaml
   kubectl apply -f step1/k8s/service.yaml
   kubectl apply -f step1/k8s/networkpolicy.yaml
   ```

5. Verify that the load balancer service received an external IP and that pods are healthy:

   ```bash
   kubectl get pods -n gandalf
   kubectl get svc gandalf -n gandalf
   ```

The service manifest includes the annotation `cloud.google.com/load-balancer-type: "External"`, so GKE provisions a public HTTP load balancer.

## Step 2

**Tasks**

- Provision a virtual machine on aws cloud with terraform.
- Install and configure a Prometheus server on the VM with ansible with docker.
- Configure Prometheus server to scrape app metrics.
- Add Grafana as dashboard (Bonus: it needs visualization)

### Terraform VM provisioning

The Terraform setup in `step2/terraform` creates:

- An EC2 key pair sourced from a provided public key.
- A security group that allows SSH (22/tcp) and HTTP (80/tcp).
- A single EC2 instance (default `t3.micro`) in a specified VPC/subnet, tagged for the Gandalf project.

**Prerequisites**

- Terraform 1.6 or newer
- AWS CLI with credentials that can manage EC2, security groups, and key pairs
- Existing VPC and subnet IDs
- SSH public key available locally

**Repository layout**

```
step2/
   terraform/
      main.tf        # Core AWS resources
      variables.tf   # Input variables and defaults
      outputs.tf     # Exposed instance details
      terraform.tfvars.example  # Template for local overrides (copy to terraform.tfvars)
```

**Usage**

```bash
cd step2/terraform
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with real IDs, paths, CIDR ranges, and optional extra tags
terraform init
terraform plan -out gandalf.plan
terraform apply gandalf.plan
```

Terraform prints the instance ID and public IP (`instance_public_ip` output). That address will be referenced by upcoming Ansible Prometheus playbooks.

When done, destroy the VM and related resources:

```bash
terraform destroy
```

### Ansible Prometheus deployment

The configuration in `step2/ansible` installs Docker on the VM and runs Prometheus in a container.

**File layout**

```
step2/
   ansible/
      inventory.ini        # Define the VM public IP / DNS and SSH settings
      prometheus.yml       # Playbook that installs Docker and runs Prometheus
      templates/
         prometheus.yml.j2  # Prometheus scrape configuration template
```

**Prerequisites**

- Ansible 2.15+ on the control machine
- Python SSH access to the EC2 instance (same key pair used for Terraform)
- Ansible collection `community.docker` installed locally:

  ```bash
  ansible-galaxy collection install community.docker
  ```

**Usage**

1. Edit `step2/ansible/inventory.ini` with the VM IP/DNS and SSH private key path.
2. Supply the Gandalf metrics endpoint (host:port) via `prometheus_targets`, e.g.:

   ```bash
   ansible-playbook -i step2/ansible/inventory.ini \
      step2/ansible/prometheus.yml \
      -e prometheus_targets='["IP:80"]'
   ```

Prometheus will be reachable on the VM at `http://<vm-ip>:9090` once the play completes.

## Technology choice & decision

- **Express + TypeScript** for a familiar, productive web stack with static typing.
- **Luxon** to manage timezone-aware date formatting without manual offset logic.
- **prom-client** for Prometheus metrics in Node.js.
- **GKE** I use GKE because i have a friend that have credits that expires soon and he wants to use them.
