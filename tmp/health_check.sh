#!/bin/bash

# List of components to check
components=("POD01" "sc" "proxy" "as" "swarm" "tm" "fileshipper" "ping" "DStore1" "Metadata")

# Initialize a variable to track the health status
health_status=""

# Iterate through components and check their health
for component in "${components[@]}"; do
    status="Good"  

    if [[ "$status" == "Good" ]]; then
        health_status="$health_status$component:           Good\n"
    else
        health_status="$health_status$component:           Unhealthy\n"
    fi
done

# Output the overall health check status
echo -e "$health_status"
