#!/bin/bash
set -e

/portainer/portainer &
PORTAINER_PID=$!


echo "$PORTAINER_USER_PASS"

until curl --silent --fail http://localhost:9000 > /dev/null; do
    echo "Waiting for Portainer to start..."
    sleep 1
done


curl -X POST "http://localhost:9000/api/users/admin/init" \
     -H "Content-Type: application/json" \
     --data "{\"Username\":\"$PORTAINER_USER\",\"Password\":\"$PORTAINER_USER_PASS\"}"

wait $PORTAINER_PID
