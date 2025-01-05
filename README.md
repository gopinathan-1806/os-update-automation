# System Health Check and OS Update Automation Script

## Overview
This script automates the process of checking the health of services on a list of remote hosts and performing OS updates only if the services are healthy. The script performs the following actions:

## 1. Pod Health Check:

A. It retrieves the pod health status for each service (e.g., POD01, sc, proxy, as, etc.) from a health-check script (health_check.sh) executed remotely on each host.
B. The script checks the health status of the pods and prints it in a formatted output.
C. If any service is not healthy, the script retries the check every 60 seconds, up to a maximum of two attempts. If the health status is still not 'Good', it stops the execution and asks for manual intervention.

## 2. OS Update:

A. Once the pod health is confirmed as "Good," the script proceeds with an OS update on the remote host using apt update && apt upgrade.
B. After the update, the script re-checks the pod health to ensure everything remains stable.

## 3. Infra part
I created three VMs for this automation, one VM as master VM / host VM and rest of the two VMs as worker machines.

<img width="994" alt="Screenshot 2025-01-05 at 11 10 29 PM" src="https://github.com/user-attachments/assets/f6eb608a-ea8e-4e53-b0d7-d44d70d4bfee" />


## Requirements
A list of remote hosts with SSH access.
The health_check.sh script installed on the remote hosts for checking pod health.
The jq tool for parsing JSON files (podResource.json) that contain host names.
SSH keys for passwordless authentication to remote hosts.
apt package manager (for OS updates).




