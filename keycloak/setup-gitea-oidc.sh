#!/usr/bin/env bash

export MSYS_NO_PATHCONV=1
set -e

KC="/opt/keycloak/bin/kcadm.sh"
REALM="iam-in-practice"
CONTAINER="iam-keycloak"

echo "============================================"
echo " IAM in Practice - Gitea OIDC Setup"
echo "============================================"

echo "[1] Logging in to Keycloak..."

docker exec "$CONTAINER" "$KC" config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user admin \
  --password admin123


echo "[2] Checking for existing Gitea client..."

CLIENT_ID=$(docker exec "$CONTAINER" "$KC" get clients \
  -r "$REALM" \
  -q clientId=gitea \
  --fields id \
  --format csv \
  --noquotes | tail -1)


if [ -z "$CLIENT_ID" ]; then

  echo "[3] Creating Gitea OIDC client..."

  docker exec "$CONTAINER" "$KC" create clients \
    -r "$REALM" \
    -s clientId=gitea \
    -s enabled=true \
    -s publicClient=false \
    -s standardFlowEnabled=true \
    -s directAccessGrantsEnabled=false \
    -s 'redirectUris=["http://localhost:3001/user/oauth2/keycloak/callback"]' \
    -s 'webOrigins=["http://localhost:3001"]'

else

  echo "Gitea client already exists."

fi


echo "[4] Getting client ID..."

CLIENT_ID=$(docker exec "$CONTAINER" "$KC" get clients \
  -r "$REALM" \
  -q clientId=gitea \
  --fields id \
  --format csv \
  --noquotes | tail -1)


echo "[5] Getting client secret..."

CLIENT_SECRET=$(docker exec "$CONTAINER" "$KC" get \
  clients/"$CLIENT_ID"/client-secret \
  -r "$REALM" \
  --fields value \
  --format csv \
  --noquotes | tail -1)


echo ""
echo "============================================"
echo " Gitea OIDC client ready!"
echo "============================================"
echo ""
echo "Client ID:"
echo "gitea"
echo ""
echo "Client Secret:"
echo "$CLIENT_SECRET"
echo ""
echo "Discovery URL:"
echo "http://keycloak:8080/realms/iam-in-practice/.well-known/openid-configuration"
echo ""