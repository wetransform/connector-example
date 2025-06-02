#!/bin/sh

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
    num=$2

    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/policydefinitions" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "privateProperties": {
        "name": "Policy ('"$num"')",
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

create_policy_de_before_2030() {
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/policydefinitions" \
        -H "Content-Type: application/json" \
        -d '{
            "@context": {
                "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
                "edc": "https://w3id.org/edc/v0.0.1/ns/",
                "odrl": "http://www.w3.org/ns/odrl/2/"
            },
            "createdAt": 0,
            "@id": "d22508ce-587c-4844-bf03-8597e46fef3c",
            "@type": "",
            "policy": {
                "@type": "odrl:Set",
                "odrl:permission": [
                    {
                        "odrl:action": {
                            "@id": "odrl:use"
                        },
                        "odrl:constraint": [
                            {
                                "@type": "AtomicConstraint",
                                "odrl:leftOperand": {
                                    "@id": "edc:country"
                                },
                                "odrl:operator": {
                                    "@id": "odrl:eq"
                                },
                                "odrl:rightOperand": "DE"
                            }
                        ]
                    },
                    {
                        "odrl:action": {
                            "@id": "odrl:use"
                        },
                        "odrl:constraint": [
                            {
                                "@type": "AtomicConstraint",
                                "odrl:leftOperand": {
                                    "@id": "edc:policyEvaluationTime"
                                },
                                "odrl:operator": {
                                    "@id": "odrl:lt"
                                },
                                "odrl:rightOperand": "2029-12-31T23:00:00.000Z"
                            }
                        ]
                    }
                ]
            },
            "privateProperties": {
                "https://w3id.org/edc/v0.0.1/ns/tenantId": "default",
                "name": "DE+Before 2030"
            }
        }'
    )


    if [ "$response" -ne 200 ]; then
        echo "Failed to create policy: HTTP $response"
        return 1
    fi
    echo "Policy DE+Before 2030 created successfully."
}

create_policy_before_2030_de() {
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/policydefinitions" \
        -H "Content-Type: application/json" \
        -d '{
            "@context": {
                "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
                "edc": "https://w3id.org/edc/v0.0.1/ns/",
                "odrl": "http://www.w3.org/ns/odrl/2/"
            },
            "createdAt": 0,
            "@id": "e243ce15-8126-435c-a882-d64f0a57f2c6",
            "@type": "",
            "policy": {
                "@type": "odrl:Set",
                "odrl:permission": [
                    {
                        "odrl:action": {
                            "@id": "odrl:use"
                        },
                        "odrl:constraint": [
                            {
                                "@type": "AtomicConstraint",
                                "odrl:leftOperand": {
                                    "@id": "edc:policyEvaluationTime"
                                },
                                "odrl:operator": {
                                    "@id": "odrl:lt"
                                },
                                "odrl:rightOperand": "2029-12-31T23:00:00.000Z"
                            }
                        ]
                    },
                    {
                        "odrl:action": {
                            "@id": "odrl:use"
                        },
                        "odrl:constraint": [
                            {
                                "@type": "AtomicConstraint",
                                "odrl:leftOperand": {
                                    "@id": "edc:country"
                                },
                                "odrl:operator": {
                                    "@id": "odrl:eq"
                                },
                                "odrl:rightOperand": "DE"
                            }
                        ]
                    }
                ]
            },
            "privateProperties": {
                "https://w3id.org/edc/v0.0.1/ns/tenantId": "default",
                "name": "Before 2030+DE"
            }
        }'
    )


    if [ "$response" -ne 200 ]; then
        echo "Failed to create policy: HTTP $response"
        return 1
    fi
    echo "Policy Before 2030+DE created successfully."
}


# Function to create a contract definition
create_contract_definition() {
    id=$1
    accessPolicyId=$2
    contractPolicyId=$3
    assetId=$4
    num=$5

    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/contractdefinitions" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "privateProperties": {
        "name": "Contract ('"$num"')",
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

ASSET_COUNT=3

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

ASSET_ID_3="f33255e7-3811-49f7-9210-69412f3ec5f9"
ASSET_NAME_3="Forestry"
ASSET_URL_3="http://host.docker.internal:8088/forestry.geojson.json"
ASSET_DESCRIPTION_3="wetransform example"
ASSET_ACTIVE_3=true
POLICY_ID_3="89b08bbe-e1d5-4a12-9ca8-dd3b87b748be"
CONTRACT_DEFINITION_ID_3="15431ef2-6e2f-47b0-893e-abce1c376840"

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
    create_policy "$POLICY_ID" "$i"
    create_contract_definition "$CONTRACT_DEFINITION_ID" "$POLICY_ID" "$POLICY_ID" "$ASSET_ID" "$i"
    i=$((i + 1))
done
create_policy_de_before_2030
create_policy_before_2030_de
