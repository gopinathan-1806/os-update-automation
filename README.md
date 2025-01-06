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

## Running the code from master VM, which is performing the health checks on worker VM and then starting the OS update
```
root@test-vsi:~/reboot# ./latest.sh 
Checking pod health on 10.240.0.6 before starting update...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good

All service statuses are 'Good' on 10.240.0.6.
Pod health is 'Good' on 10.240.0.6. Proceeding with update.
Starting OS update on 10.240.0.6...

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://mirrors.adn.networklayer.com/ubuntu noble InRelease [256 kB]
Get:2 http://mirrors.adn.networklayer.com/ubuntu noble-updates InRelease [126 kB]
Get:3 http://mirrors.adn.networklayer.com/ubuntu noble-backports InRelease [126 kB]
Get:4 http://mirrors.adn.networklayer.com/ubuntu noble-security InRelease [126 kB]
Fetched 634 kB in 1s (688 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Waiting for update to complete on 10.240.0.6...
OS update completed on 10.240.0.6. Re-checking pod health...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good

All service statuses are 'Good' on 10.240.0.6.
Pod health is stable on 10.240.0.6. Proceeding to next host.
Checking pod health on 10.240.0.7 before starting update...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good

All service statuses are 'Good' on 10.240.0.7.
Pod health is 'Good' on 10.240.0.7. Proceeding with update.
Starting OS update on 10.240.0.7...

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://mirrors.adn.networklayer.com/ubuntu noble InRelease [256 kB]
Get:2 http://mirrors.adn.networklayer.com/ubuntu noble-updates InRelease [126 kB]
Get:3 http://mirrors.adn.networklayer.com/ubuntu noble-backports InRelease [126 kB]
Get:4 http://mirrors.adn.networklayer.com/ubuntu noble-security InRelease [126 kB]
Fetched 634 kB in 1s (662 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Waiting for update to complete on 10.240.0.7...
OS update completed on 10.240.0.7. Re-checking pod health...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good

All service statuses are 'Good' on 10.240.0.7.
Pod health is stable on 10.240.0.7. Proceeding to next host.
OS updates completed on all hosts.
````



## Intentionally causing the POD-health to fail for testing the code.

```
root@test-vsi:~/reboot# ./latest.sh
Checking pod health on 10.240.0.6 before starting update...
Checking pod health on 10.240.0.6 (Attempt 1)...
POD01::           Good
sc::           Unhealthy
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good
Pod health not 'Good' on 10.240.0.6. Retrying in 60 seconds...

Checking pod health on 10.240.0.6 (Attempt 2)...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good
All service statuses are 'Good' on 10.240.0.6.
Pod health is 'Good' on 10.240.0.6. Proceeding with update.

Starting OS update on 10.240.0.6...

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://mirrors.adn.networklayer.com/ubuntu noble InRelease [256 kB]
Get:2 http://mirrors.adn.networklayer.com/ubuntu noble-updates InRelease [126 kB]
Get:3 http://mirrors.adn.networklayer.com/ubuntu noble-backports InRelease [126 kB]
Get:4 http://mirrors.adn.networklayer.com/ubuntu noble-security InRelease [126 kB]
Fetched 634 kB in 1s (688 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Waiting for update to complete on 10.240.0.6...
OS update completed on 10.240.0.6. Re-checking pod health...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good

All service statuses are 'Good' on 10.240.0.6.
Pod health is stable on 10.240.0.6. Proceeding to next host.
Checking pod health on 10.240.0.7 before starting update...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good

All service statuses are 'Good' on 10.240.0.7.
Pod health is 'Good' on 10.240.0.7. Proceeding with update.
Starting OS update on 10.240.0.7...

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://mirrors.adn.networklayer.com/ubuntu noble InRelease [256 kB]
Get:2 http://mirrors.adn.networklayer.com/ubuntu noble-updates InRelease [126 kB]
Get:3 http://mirrors.adn.networklayer.com/ubuntu noble-backports InRelease [126 kB]
Get:4 http://mirrors.adn.networklayer.com/ubuntu noble-security InRelease [126 kB]
Fetched 634 kB in 1s (662 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Waiting for update to complete on 10.240.0.7...
OS update completed on 10.240.0.7. Re-checking pod health...
POD01::           Good
sc::           Good
proxy::           Good
as::           Good
swarm::           Good
tm::           Good
fileshipper::           Good
ping::           Good
DStore1::           Good
Metadata::           Good

All service statuses are 'Good' on 10.240.0.7.
Pod health is stable on 10.240.0.7. Proceeding to next host.
OS updates completed on all hosts.
```





