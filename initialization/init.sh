#!/bin/sh
set -xo

EDC_BASE_URL="${EDC_BASE_URL:-http://localhost:8081}"

# Function to create an asset
create_asset() {
    id=$1
    name=$2
    base_url=$3
    description=$4
    proxy_path=${5:-false}

    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/assets" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "properties": {
        "contenttype": "application/json",
        "name": "'"$name"'",
        "description": "'"$description"'"
      },
      "privateProperties": {
        "https://w3id.org/edc/v0.0.1/ns/tenantId": "default"
      },
      "dataAddress": {
        "type": "HttpData",
        "proxyPath": "'"$proxy_path"'",
        "proxyQueryParams": "true",
        "proxyBody": "false",
        "proxyMethod": "false",
        "baseUrl": "'"$base_url"'"
      },
      "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/"
      }
    }')

    if [ "$response" -ne 200 ]; then
        echo "Failed to create asset: HTTP $response"
        return 1
    fi
    echo "Asset created successfully."
}

# Function to create a policy
create_policy() {
    id=$1

    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/policydefinitions" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "privateProperties": {
        "name": "Policy",
        "https://w3id.org/edc/v0.0.1/ns/tenantId": "default"
      },
      "policy": {
        "@type": "odrl:Set"
      },
      "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
        "edc": "https://w3id.org/edc/v0.0.1/ns/",
        "odrl": "http://www.w3.org/ns/odrl/2/"
      }
    }')

    if [ "$response" -ne 200 ]; then
        echo "Failed to create policy: HTTP $response"
        return 1
    fi
    echo "Policy created successfully."
}

# Function to create a contract definition
create_contract_definition() {
    id=$1
    accessPolicyId=$2
    contractPolicyId=$3
    assetId=$4

    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/contractdefinitions" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "privateProperties": {
        "name": "Contract",
        "https://w3id.org/edc/v0.0.1/ns/tenantId": "default"
      },
      "accessPolicyId":  "'"$accessPolicyId"'",
      "contractPolicyId":  "'"$contractPolicyId"'",
      "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/"
      },
       "assetsSelector": [{
          "@type": "CriterionDto",
          "operandLeft": "https://w3id.org/edc/v0.0.1/ns/id",
          "operator": "=",
          "operandRight": "'"$assetId"'"
        }]
    }')

    if [ "$response" -ne 200 ]; then
        echo "Failed to create contract definition: HTTP $response"
        return 1
    fi
    echo "Contract definition created successfully."
}

ASSET_COUNT=2

ASSET_ID_1="77e9fbfd-7e9a-4254-96c7-d06595728402"
ASSET_NAME_1="Countries"
ASSET_URL_1="http://host.docker.internal:8088/countries.geojson"
ASSET_DESCRIPTION_1="Tolle Description hier"
ASSET_ACTIVE_1=true
POLICY_ID_1="7f09aa3f-9cb6-437a-b29e-3281601bdad7"
CONTRACT_DEFINITION_ID_1="a7741ae6-bc6e-436e-a5f8-788153b94042"

ASSET_ID_2="554468b1-f28b-4c1c-990c-d2dab2f2a432"
ASSET_NAME_2="Windenergieanlagen"
ASSET_URL_2="http://host.docker.internal:8088/Windenergieanlagen_KreisGT_EPSG3857_GEOJSON.geojson"
ASSET_DESCRIPTION_2="Tolle Description hier"
ASSET_ACTIVE_2=true
POLICY_ID_2="de35267a-f4f4-4cea-a994-3741fd02ac71"
CONTRACT_DEFINITION_ID_2="5e51316a-6de0-4630-bcf9-144c217b1ad1"

i=1
while [ "$i" -le "$ASSET_COUNT" ]; do
    ASSET_ID=$(eval echo "\$ASSET_ID_$i")
    ASSET_NAME=$(eval echo "\$ASSET_NAME_$i")
    ASSET_URL=$(eval echo "\$ASSET_URL_$i")
    ASSET_DESCRIPTION=$(eval echo "\$ASSET_DESCRIPTION_$i")
    ASSET_ACTIVE=$(eval echo "\$ASSET_ACTIVE_$i")
    POLICY_ID=$(eval echo "\$POLICY_ID_$i")
    CONTRACT_DEFINITION_ID=$(eval echo "\$CONTRACT_DEFINITION_ID_$i")

    create_asset "$ASSET_ID" "$ASSET_NAME" "$ASSET_URL" "$ASSET_DESCRIPTION" "$ASSET_ACTIVE"
    create_policy "$POLICY_ID"
    create_contract_definition "$CONTRACT_DEFINITION_ID" "$POLICY_ID" "$POLICY_ID" "$ASSET_ID"
    i=$((i + 1))
done
