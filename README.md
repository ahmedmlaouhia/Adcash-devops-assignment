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
- Install and configure a Prometheus server on the VM with ansible.
- Configure Prometheus server to scrape app metrics.
- Add Grafana as dashboard (Bonus: it needs visualization)

## Technology choice & decision

- **Express + TypeScript** for a familiar, productive web stack with static typing.
- **Luxon** to manage timezone-aware date formatting without manual offset logic.
- **prom-client** for first-class Prometheus metrics in Node.js.
- **GKE** (or any Kubernetes) for deployment parity between local and cloud environments.
