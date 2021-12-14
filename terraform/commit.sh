#!/bin/bash

#
# Commit to PAN-OS firewall
#
# Usage: commit.sh <host> <admin username> <admin password>
#

# Variables
host=$1
adminusername=$2
adminpassword=$3

# Get API key
keyresponse=$(curl -skd "type=keygen&user=$adminusername&password=$adminpassword" https://$host/api)
key=$(xmllint --xpath 'string(//response/result/key)' - <<< $keyresponse)

# Start commit
response=$(curl -skd "key=$key&type=commit&cmd=<commit></commit>" https://$host/api)

# Get commit job ID
job=$(xmllint --xpath 'string(//response/result/job)' - <<< $response)

# Get commit job status
joboutput=$(curl -skd "key=$key&type=op&cmd=<show><jobs><id>$job</id></jobs></show>" https://$host/api)
jobstatus=$(xmllint --xpath 'string(//response/result/job/status)' - <<< $joboutput)

# If job's not FINished, loop until it is...
while [ $jobstatus != "FIN" ]
do
    echo "Commit status: "$jobstatus
    sleep 5
    joboutput=$(curl -skd "key=$key&type=op&cmd=<show><jobs><id>$job</id></jobs></show>" https://$host/api)
    jobstatus=$(xmllint --xpath 'string(//response/result/job/status)' - <<< $joboutput)
done

# Final commit job status
echo "Final commit status: "$jobstatus
