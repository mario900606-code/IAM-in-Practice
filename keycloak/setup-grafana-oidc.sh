#!/usr/bin/env bash

export MSYS_NO_PATHCONV=1
set -e

KC="/opt/keycloak/bin/kcadm.sh"
REALM="iam-in-practice"
CONTAINER="iam-keycloak"

echo "Logging in to Keycloak..."

docker exec "$CONTAINER" "$KC" config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user admin \
  --password admin123

CLIENT_UUID=$(docker exec "$CONTAINER" "$KC" get clients \
  -r "$REALM" \
  -q clientId=grafana \
  --fields id \
  --format csv \
  --noquotes | tail -1)

if [ -z "$CLIENT_UUID" ]; then

  echo "Creating Grafana client..."

  docker exec "$CONTAINER" "$KC" create clients \
    -r "$REALM" \
    -s clientId=grafana \
    -s enabled=true \
    -s publicClient=false \
    -s standardFlowEnabled=true \
    -s directAccessGrantsEnabled=false \
    -s 'redirectUris=["http://localhost:3000/login/generic_oauth"]' \
    -s 'webOrigins=["http://localhost:3000"]'

else

  echo "Grafana client already exists - updating it..."

  docker exec "$CONTAINER" "$KC" update clients/"$CLIENT_UUID" \
    -r "$REALM" \
    -s enabled=true \
    -s publicClient=false \
    -s standardFlowEnabled=true \
    -s 'redirectUris=["http://localhost:3000/login/generic_oauth"]' \
    -s 'webOrigins=["http://localhost:3000"]'
fi

CLIENT_UUID=$(docker exec "$CONTAINER" "$KC" get clients \
  -r "$REALM" \
  -q clientId=grafana \
  --fields id \
  --format csv \
  --noquotes | tail -1)

SECRET=$(docker exec "$CONTAINER" "$KC" get \
  clients/"$CLIENT_UUID"/client-secret \
  -r "$REALM" \
  --fields value \
  --format csv \
  --noquotes | tail -1)

echo ""
echo "========================================"
echo "Grafana OIDC client ready"
echo "========================================"
echo "Client ID: grafana"
echo "Client Secret: $SECRET"
echo ""
echo "$SECRET" > grafana-client-secret.txt
