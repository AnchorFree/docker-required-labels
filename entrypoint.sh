#!/bin/sh
# Please set environment variables:
# HOST, PORT -- gunicorn host and port;
# GITHUB_USER, GITHUB_TOKEN -- GitHub API credentials with repo read permissions;
# or
# VAULT_ADDR, APPROLE_ROLE_ID, APPROLE_SECRET_ID -- Vault address and credentials;
# VAULT_SECRET_PATH, VAULT_SECRET_KEY_USER, VAULT_SECRET_KEY_TOKEN -- Vault path to get GitHub credentials.

VAULT_ADDR="${VAULT_ADDR:-127.0.0.1:8200}"

get_token() {    
    curl -s --request POST \
        --data "{\"role_id\":\"${APPROLE_ROLE_ID}\",\"secret_id\":\"${APPROLE_SECRET_ID}\"}" \
        ${VAULT_ADDR}/v1/auth/approle/login | jq -r '.auth.client_token'
}

get_secret() {
    SECRET_PATH="${1}"
    SECRET_KEY="${2}"
    curl -s --header "X-Vault-Token: ${VAULT_TOKEN}" ${VAULT_ADDR}/v1/${SECRET_PATH} \
    | jq -r --arg k "${SECRET_KEY}" '.data | .[$k]'
}

main() {
    export GITHUB_PW="none"
    if [ -z ${GITHUB_USER} -o -z ${GITHUB_TOKEN} ]; then
        VAULT_TOKEN="$(get_token)"
        GITHUB_USER="$(get_secret ${VAULT_SECRET_PATH} ${VAULT_SECRET_KEY_USER})"
        GITHUB_TOKEN="$(get_secret ${VAULT_SECRET_PATH} ${VAULT_SECRET_KEY_TOKEN})"
    fi
    gunicorn -b ${HOST}:${PORT:-8080} main:app
}

main
