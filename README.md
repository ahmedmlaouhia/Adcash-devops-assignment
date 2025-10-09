# Adcash-devops-assignment

## Step 1

**Tasks**

- Create web server in express with typescript serving Gandalf’s picture at `/gandalf`.
- Return current Colombo time at `/colombo`.
- Expose Prometheus metrics tracking requests to `/gandalf` and `/colombo`.
- Deploy to K8s with static IP address (Load Balancer).
- Restrict ingress to TCP port 80 only.

## Step 2

**Tasks**

- Provision a virtual machine on cloud with terraform .
- Install and configure a Prometheus server on the VM with ansible.
- Configure Prometheus server to scrape app metrics.

## Technology choice & decision

- I have chosen Express with TypeScript because it is my most used stack and simple to set up.
- I have used Luxon because it provides timezone-aware date and time without many configuration.
