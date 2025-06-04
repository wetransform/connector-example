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

create_asset_from_file() {
    id=$1
    name=$2
    file_path=$3
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
        "type": "File",
        "path": "'"$file_path"'"
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
    name=$2
    role=$3
    geofence=$4
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/policydefinitions" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "privateProperties": {
        "name": "'"$name"'",
        "https://w3id.org/edc/v0.0.1/ns/tenantId": "default"
      },
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
                            "@id": "edc:wetransform_role"
                        },
                        "odrl:operator": {
                            "@id": "odrl:eq"
                        },
                        "odrl:rightOperand": "'"$role"'"
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
                            "@id": "edc:geofence"
                        },
                        "odrl:operator": {
                            "@id": "odrl:isPartOf"
                        },
                        "odrl:rightOperand": {
                            "@value": "'"$geofence"'"
                        }
                    }
                ]
            }
        ]
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

create_policy_norestriction() {
    id=$1
    name=$2
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/policydefinitions" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "privateProperties": {
        "name": "'"$name"'",
        "https://w3id.org/edc/v0.0.1/ns/tenantId": "default"
      },
      "policy": {
        "@type": "odrl:Set",
        "odrl:permission": []
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
    name=$5

    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$EDC_BASE_URL/management/v3/contractdefinitions" \
        -H "Content-Type: application/json" \
        -d '{
      "@id": "'"$id"'",
      "privateProperties": {
        "name": "'"$name"'",
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
ASSET_NAME_1="Asset for Forest owner a"
ASSET_URL_1="https://test.haleconnect.de/ows/datasets/org.531.b5f5904a-ac54-4fe2-b6e5-aa7699b094dc_ogcapi/collections"
ASSET_DESCRIPTION_1="Tolle Description hier"
ASSET_ACTIVE_1=true
POLICY_ID_1="7f09aa3f-9cb6-437a-b29e-3281601bdad7"
POLICY_NAME_1="Policy for forest owner a and any super set"
ROLE_1="forest-data-holder"
GEOFENCE_1="POLYGON ((8.6194458 48.5421278, 8.6307042 48.5369528, 8.6054351 48.5239125, 8.5994045 48.5109871, 8.6068298 48.5043549, 8.6358459 48.5001974, 8.6726588 48.5103278, 8.6934784 48.4839745, 8.7345171 48.4876054, 8.7388702 48.5042241, 8.7561926 48.5035272, 8.7705529 48.5226404, 8.7584687 48.5285755, 8.7649033 48.5319271, 8.7578736 48.5444417, 8.7730454 48.5455789, 8.7730191 48.5497698, 8.7587757 48.5556091, 8.7470196 48.5962232, 8.7490808 48.6037754, 8.7928833 48.5957518, 8.799544 48.6171278, 8.7898185 48.6290119, 8.7947927 48.6342155, 8.7991939 48.6582004, 8.8189302 48.6642488, 8.8196743 48.6698369, 8.8364189 48.6829608, 8.8511081 48.6844213, 8.8630095 48.6973072, 8.8551326 48.7068334, 8.8751287 48.726242, 8.8295866 48.7367838, 8.8351906 48.7538329, 8.8198928 48.7634797, 8.7994942 48.7736493, 8.8042943 48.7780584, 8.7701264 48.7762729, 8.7414513 48.8025316, 8.7293609 48.7982314, 8.7167597 48.818567, 8.7187158 48.8298083, 8.7046266 48.8386954, 8.6911454 48.8350915, 8.6942448 48.8196334, 8.6530077 48.8123889, 8.6193874 48.828765, 8.6068024 48.8187286, 8.608344 48.8106312, 8.5964612 48.8079906, 8.5877883 48.817594, 8.5604196 48.8104361, 8.550614 48.7914079, 8.5306748 48.7848228, 8.5170623 48.7954577, 8.5182698 48.8009041, 8.5322778 48.8033927, 8.5255464 48.8108486, 8.505923 48.8140434, 8.4929766 48.8200993, 8.4459745 48.8210324, 8.4389328 48.8119954, 8.419776 48.8300968, 8.3789387 48.8366516, 8.3755974 48.8319019, 8.403851 48.821941, 8.4077575 48.8083817, 8.397222 48.8097846, 8.3915563 48.8044322, 8.4269098 48.7889022, 8.4324177 48.7669809, 8.419847 48.7449528, 8.468357 48.7638019, 8.4843492 48.7565269, 8.4767876 48.726045, 8.4716263 48.7193836, 8.459603 48.7191635, 8.4667068 48.7004646, 8.4399245 48.6945643, 8.4476383 48.6859809, 8.4482995 48.6625583, 8.4439998 48.657288, 8.4317298 48.6603615, 8.4359445 48.6512731, 8.4295969 48.6447316, 8.4177239 48.6461917, 8.4098611 48.6396026, 8.4094455 48.6331536, 8.4192114 48.635585, 8.4497578 48.6200691, 8.4670379 48.6060137, 8.4726257 48.6115764, 8.5024878 48.592949, 8.5386884 48.5876164, 8.5620064 48.5686753, 8.575655 48.5769189, 8.5783164 48.5657932, 8.5592629 48.5497376, 8.5867553 48.5451698, 8.595801 48.5539429, 8.6030343 48.5484183, 8.6194458 48.5421278))"
#GEOFENCE_1="POLYGON((-5.652470932848154 29.213222844010318,3.004755629651825 23.426618046325483,11.398310317151825 32.04874108125516,1.2908884421518252 35.33857338563032,-5.652470932848154 29.213222844010318))"
CONTRACT_DEFINITION_ID_1="a7741ae6-bc6e-436e-a5f8-788153b94042"
CONTRACT_NAME_1="Contract for Forest owner a or any super set"

ASSET_ID_2="554468b1-f28b-4c1c-990c-d2dab2f2a432"
ASSET_NAME_2="Asset for Owner b"
ASSET_URL_2="https://test.haleconnect.de/ows/datasets/org.762.6955d69f-5e3a-446c-98cb-0c3b6ae119fd_ogcapi"
ASSET_DESCRIPTION_2="Should only be accessible to forest owner b"
ASSET_ACTIVE_2=true
POLICY_ID_2="de35267a-f4f4-4cea-a994-3741fd02ac71"
POLICY_NAME_2="Policy for forest owner b"
ROLE_2="forest-data-holder"
GEOFENCE_2="POLYGON ((8.5122367 48.4050197, 8.5303739 48.4004456, 8.5452819 48.4049379, 8.5646695 48.4000718, 8.5742973 48.4037735, 8.5951711 48.4100551, 8.6058205 48.3959917, 8.640327 48.4023885, 8.6554981 48.3945554, 8.6763373 48.4002011, 8.690371 48.3870313, 8.7368658 48.3767577, 8.7573319 48.3816695, 8.7491462 48.3904705, 8.7662151 48.4102384, 8.7716523 48.4162141, 8.7774047 48.4216732, 8.7647081 48.4272574, 8.7700895 48.4378735, 8.7807461 48.4384805, 8.7838505 48.4470819, 8.8106491 48.4583053, 8.8278819 48.4624796, 8.8207844 48.4698998, 8.8135611 48.4683599, 8.7942659 48.4849005, 8.7775698 48.485694, 8.7685666 48.5011402, 8.7561926 48.5035272, 8.7388702 48.5042241, 8.7345171 48.4876054, 8.6934784 48.4839745, 8.6726588 48.5103278, 8.6358459 48.5001974, 8.6068298 48.5043549, 8.5994045 48.5109871, 8.6054351 48.5239125, 8.6307042 48.5369528, 8.6194458 48.5421278, 8.6030343 48.5484183, 8.595801 48.5539429, 8.5867553 48.5451698, 8.5592629 48.5497376, 8.5783164 48.5657932, 8.575655 48.5769189, 8.5620064 48.5686753, 8.5386884 48.5876164, 8.5024878 48.592949, 8.4726257 48.6115764, 8.4670379 48.6060137, 8.4497578 48.6200691, 8.4192114 48.635585, 8.4094455 48.6331536, 8.4098611 48.6396026, 8.3884671 48.6364986, 8.3878245 48.623547, 8.3507285 48.6089112, 8.3593948 48.6000019, 8.3203406 48.5885893, 8.2636952 48.5892507, 8.2224609 48.6028322, 8.2099619 48.6014993, 8.2368901 48.5762915, 8.2281589 48.5629062, 8.2126327 48.5575666, 8.2208895 48.5496582, 8.2135455 48.5467629, 8.2190084 48.5371417, 8.2117129 48.5222734, 8.2214392 48.5033486, 8.2413375 48.4929768, 8.2660383 48.4904497, 8.2703331 48.4793728, 8.2650883 48.4362574, 8.2554476 48.4337513, 8.2551456 48.413533, 8.2413458 48.4112725, 8.2336501 48.4015168, 8.2461862 48.3947751, 8.2474793 48.3848707, 8.2631411 48.3793245, 8.2517313 48.3646195, 8.2911897 48.3573932, 8.300771 48.3494533, 8.3178201 48.3567449, 8.3148684 48.3663379, 8.3297396 48.3865461, 8.360019 48.3765955, 8.3552949 48.3670054, 8.3631506 48.3348403, 8.40395 48.3223928, 8.4316319 48.3227036, 8.4447319 48.3010528, 8.4585669 48.3130478, 8.4943193 48.3138392, 8.4996526 48.3272111, 8.501353 48.3314871, 8.4850071 48.3337349, 8.4849778 48.3416672, 8.4716216 48.3459014, 8.5031057 48.3573319, 8.4861197 48.36805, 8.4847136 48.3818845, 8.5202328 48.3879472, 8.5122367 48.4050197))"
#GEOFENCE_2="POLYGON((-5.652470932848154 29.213222844010318,3.004755629651825 23.426618046325483,11.398310317151825 32.04874108125516,1.2908884421518252 35.33857338563032,-5.652470932848154 29.213222844010318))"
CONTRACT_DEFINITION_ID_2="5e51316a-6de0-4630-bcf9-144c217b1ad1"
CONTRACT_NAME_2="Contract for Forest owner 2 or any super set"

ASSET_ID_3="554468b1-f38b-4c1c-990c-d2dab2f2a432"
ASSET_NAME_3="Asset for Non-EU"
ASSET_URL_3="http://geodata/Windenergieanlagen_KreisGT_EPSG3857_GEOJSON.geojson"
ASSET_DESCRIPTION_3="Should only be accessible to participant with geometry outside of EU or to researchers"
ASSET_ACTIVE_3=true
POLICY_ID_3="de35267a-f4e4-4cea-a994-3741fd02ac71"
POLICY_NAME_3="Policy for non-EU participant with geofence within Australia"
ROLE_3="forest-data-holder"
GEOFENCE_3="POLYGON((136.98507556190478 -21.493172818177026,129.51437243690478 -29.113032921614074,144.27999743690478 -35.71014778169594,149.28976306190478 -26.86252248905155,136.98507556190478 -21.493172818177026))"
CONTRACT_DEFINITION_ID_3="5e51316a-6ae0-4630-bcf9-144c217b1ad1"
CONTRACT_NAME_3="Contract for non-EU participant"

i=1
while [ "$i" -le "$ASSET_COUNT" ]; do
    ASSET_ID=$(eval echo "\$ASSET_ID_$i")
    ASSET_NAME=$(eval echo "\$ASSET_NAME_$i")
    ASSET_URL=$(eval echo "\$ASSET_URL_$i")
    ASSET_DESCRIPTION=$(eval echo "\$ASSET_DESCRIPTION_$i")
    ASSET_ACTIVE=$(eval echo "\$ASSET_ACTIVE_$i")
    POLICY_ID=$(eval echo "\$POLICY_ID_$i")
    POLICY_NAME=$(eval echo "\$POLICY_NAME_$i")
    ROLE=$(eval echo "\$ROLE_$i")
    GEOFENCE=$(eval echo "\$GEOFENCE_$i")
    CONTRACT_DEFINITION_ID=$(eval echo "\$CONTRACT_DEFINITION_ID_$i")
    CONTRACT_NAME=$(eval echo "\$CONTRACT_NAME_$i")

    create_asset "$ASSET_ID" "$ASSET_NAME" "$ASSET_URL" "$ASSET_DESCRIPTION" "$ASSET_ACTIVE"
    create_policy "$POLICY_ID" "$POLICY_NAME" "$ROLE" "$GEOFENCE"
    create_contract_definition "$CONTRACT_DEFINITION_ID" "$POLICY_ID" "$POLICY_ID" "$ASSET_ID" "$CONTRACT_NAME"
    i=$((i + 1))
done

ASSET_ID_4="554468b1-f28b-4c1c-990c-d2dab2f2a435"
ASSET_NAME_4="Open asset"
ASSET_URL_4="http://geodata/countries.geojson"
ASSET_DESCRIPTION_4="Asset with no geometry or role restriction"
ASSET_ACTIVE_4=true
POLICY_ID_4="de35267a-f4f4-4cea-a994-3741fd04ac71"
POLICY_NAME_4="Policy with no restriction"
CONTRACT_DEFINITION_ID_4="5e51316a-6de0-4630-bcf9-144c217b1aa1"
CONTRACT_NAME_4="Contract with no geometry restrictions"


create_asset "$ASSET_ID_4" "$ASSET_NAME_4" "$ASSET_URL_4" "$ASSET_DESCRIPTION_4" "$ASSET_ACTIVE_4"
create_policy_norestriction "$POLICY_ID_4" "$POLICY_NAME_4"
create_contract_definition "$CONTRACT_DEFINITION_ID_4" "$POLICY_ID_4" "$POLICY_ID_4" "$ASSET_ID_4" "$CONTRACT_NAME_4"


#ASSET_ID_4="554468g1-f28b-4c1c-990c-d2dab2f2a435"
#ASSET_NAME_4="file upload data"
#ASSET_URL_4="/data/minifix.geojson.json"
#ASSET_DESCRIPTION_4="Tolle Description hier"
#ASSET_ACTIVE_4=true
#POLICY_ID_4="de35264a-f4f4-4cea-a994-3741fd04ac71"
#CONTRACT_DEFINITION_ID_4="5e54316a-6de0-4630-bcf9-144c217b1aa1"
#
#create_asset_from_file "$ASSET_ID_4" "$ASSET_NAME_4" "$ASSET_URL_4" "$ASSET_DESCRIPTION_4" "$ASSET_ACTIVE_4"
#create_policy_norestriction "$POLICY_ID_4"
#create_contract_definition "$CONTRACT_DEFINITION_ID_4" "$POLICY_ID_4" "$POLICY_ID_4" "$ASSET_ID_4"
