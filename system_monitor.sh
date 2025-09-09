#!/bin/bash

# Define the threshold values for CPU, memory, and disk usage (in percentage)
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Function to send an alert
send_alert() {
  echo "ALERT: $1 usage is above threshold! Current value: $2%"
}

while true; do
  # Calculate resource usage
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
  MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//')

  # Get current timestamp
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

  # Log the usage values into resource_usage.log
  echo "$TIMESTAMP | CPU: ${CPU_USAGE}% | Memory: ${MEMORY_USAGE}% | Disk: ${DISK_USAGE}%" >> /home/labex/project/resource_usage.log

  # Check thresholds and send alerts
  if (( ${CPU_USAGE%.*} > CPU_THRESHOLD )); then
    send_alert "CPU" "$CPU_USAGE"
  fi

  if (( ${MEMORY_USAGE%.*} > MEMORY_THRESHOLD )); then
    send_alert "Memory" "$MEMORY_USAGE"
  fi

  if (( DISK_USAGE > DISK_THRESHOLD )); then
    send_alert "Disk" "$DISK_USAGE"
  fi

  # Wait 5 seconds before the next check
  sleep 5
done
