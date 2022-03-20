#!/bin/sh

# Start the first process
npm start &
  
# Start the second process
bin/launcher-disbalancer-go-client-linux-amd64 &
  
# Wait for any process to exit
wait -n
  
# Exit with status of process that exited first
exit $?