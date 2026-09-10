#!/usr/bin/env bash

export MSYS_NO_PATHCONV=1
set -e

KC="/opt/keycloak/bin/kcadm.sh"
REALM="iam-in-practice"
CONTAINER="iam-keycloak"

echo "============================================"
echo " IAM in Practice - Keycloak Setup"
echo "============================================"

echo "[1] Logging in to Keycloak..."

docker exec "$CONTAINER" "$KC" config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user admin \
  --password admin123


echo "[2] Creating roles..."

for ROLE in \
  hr-user \
  gitea-developer \
  glpi-agent \
  splunk-analyst \
  iam-admin
do

  docker exec "$CONTAINER" "$KC" create roles \
    -r "$REALM" \
    -s name="$ROLE" \
    2>/dev/null || echo "Role $ROLE already exists"

done


echo "[3] Creating groups..."

for GROUP in \
  HR \
  Developers \
  Helpdesk \
  Security \
  IAM-Admins
do

  docker exec "$CONTAINER" "$KC" create groups \
    -r "$REALM" \
    -s name="$GROUP" \
    2>/dev/null || echo "Group $GROUP already exists"

done


echo "[4] Creating users..."

create_user () {

  USERNAME="$1"
  FIRSTNAME="$2"
  LASTNAME="$3"
  EMAIL="$4"

  docker exec "$CONTAINER" "$KC" create users \
    -r "$REALM" \
    -s username="$USERNAME" \
    -s enabled=true \
    -s firstName="$FIRSTNAME" \
    -s lastName="$LASTNAME" \
    -s email="$EMAIL" \
    -s emailVerified=true \
    2>/dev/null || echo "User $USERNAME already exists"

  docker exec "$CONTAINER" "$KC" set-password \
    -r "$REALM" \
    --username "$USERNAME" \
    --new-password 'Password123!'
}

create_user emma.hr Emma HR emma.hr@example.local
create_user david.developer David Developer david.developer@example.local
create_user hanna.helpdesk Hanna Helpdesk hanna.helpdesk@example.local
create_user simon.security Simon Security simon.security@example.local
create_user adam.iamadmin Adam IAMAdmin adam.iamadmin@example.local


echo "[5] Assigning users to groups..."

assign_group () {

  USERNAME="$1"
  GROUPNAME="$2"

  USER_ID=$(docker exec "$CONTAINER" "$KC" get users \
    -r "$REALM" \
    -q username="$USERNAME" \
    --fields id \
    --format csv \
    --noquotes | tail -1)

  GROUP_ID=$(docker exec "$CONTAINER" "$KC" get groups \
    -r "$REALM" \
    -q search="$GROUPNAME" \
    --fields id,name \
    --format csv \
    --noquotes | grep ",$GROUPNAME" | head -1 | cut -d',' -f1)

  echo "$USERNAME -> $GROUPNAME"

  docker exec "$CONTAINER" "$KC" update \
    "users/$USER_ID/groups/$GROUP_ID" \
    -r "$REALM" \
    -n
}

assign_group emma.hr HR
assign_group david.developer Developers
assign_group hanna.helpdesk Helpdesk
assign_group simon.security Security
assign_group adam.iamadmin IAM-Admins


echo "[6] Assigning roles to groups..."

docker exec "$CONTAINER" "$KC" add-roles \
  -r "$REALM" \
  --gname HR \
  --rolename hr-user

docker exec "$CONTAINER" "$KC" add-roles \
  -r "$REALM" \
  --gname Developers \
  --rolename gitea-developer

docker exec "$CONTAINER" "$KC" add-roles \
  -r "$REALM" \
  --gname Helpdesk \
  --rolename glpi-agent

docker exec "$CONTAINER" "$KC" add-roles \
  -r "$REALM" \
  --gname Security \
  --rolename splunk-analyst

docker exec "$CONTAINER" "$KC" add-roles \
  -r "$REALM" \
  --gname IAM-Admins \
  --rolename iam-admin


echo ""
echo "============================================"
echo " IAM in Practice setup complete!"
echo "============================================"
echo ""
echo "Users:"
echo " Emma  -> HR          -> hr-user"
echo " David -> Developers  -> gitea-developer"
echo " Hanna -> Helpdesk    -> glpi-agent"
echo " Simon -> Security    -> splunk-analyst"
echo " Adam  -> IAM-Admins  -> iam-admin"
echo ""
echo "Demo password: Password123!"