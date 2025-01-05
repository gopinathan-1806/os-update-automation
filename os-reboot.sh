#!/bin/bash

# Path to the podResource.json file
POD_RESOURCE_FILE="podResource.json"

# Parse JSON to extract the hostnames (using jq)
hosts=$(jq -r '.swarm[].name, .sc[].name, .as[].name' "$POD_RESOURCE_FILE")

# Function to check System health
check_pod_health() {
    local host=$1
    while true; do
        pod_health=$(ssh -i ~/.ssh/chaos-customer-pvt -o ConnectTimeout=3 \
            -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=ERROR \
            root@$host "bash /tmp/health_check.sh")

        if echo "$pod_health" | grep -q "Good"; then
            echo "All pod statuses are 'Good' on $host."
            return 0
        else
            echo "Pod health not 'Good' on $host. Retrying in 60 seconds..."
            sleep 60
        fi
    done
}

# Loop through each host
for host in $hosts; do
    echo "Checking pod health on $host before starting update..."
    check_pod_health $host

    echo "Pod health is 'Good' on $host. Proceeding with update."

    # SSH to the host and run the OS update
    echo "Starting OS update on $host..."
    ssh -i ~/.ssh/chaos-customer-pvt -o ConnectTimeout=3 \
        -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=ERROR \
        root@$host "apt update && apt upgrade -y"

    echo "Waiting for update to complete on $host..."
    sleep 90  # Simulate update process

    echo "OS update completed on $host. Re-checking pod health..."

    # Check pod health again after update
    check_pod_health $host

    echo "Pod health is stable on $host. Proceeding to next host."
done

echo "OS updates completed on all hosts."

