#!/bin/sh

IMPORTER_USERNAME=${1:-ccd.docker.default@hmcts.net}
IMPORTER_PASSWORD=${2:-Pa55word11}
IDAM_URI="http://localhost:5000"
REDIRECT_URI="http://localhost:3451/oauth2redirect"
CLIENT_ID="ccd_gateway"
CLIENT_SECRET="ccd_gateway_secret"
BIN_FOLDER=$($(dirname "$0")/probate-dev-env-realpath)

authToken=$(curl -v -H 'Content-Type: application/x-www-form-urlencoded' -XPOST "${IDAM_URI}/loginUser?username=idamOwner@hmcts.net&password=Ref0rmIsFun" | jq -r .api_auth_token)

echo "authtoken is ${authToken}"

#Create a ccd gateway client
curl -XPOST \
  ${IDAM_URI}/services \
 -H "Authorization: AdminApiAuthToken ${authToken}" \
 -H "Content-Type: application/json" \
 -d '{ "activationRedirectUrl": "", "allowedRoles": ["ccd-import", "caseworker", "caseworker-probate", "caseworker-probate", "caseworker-probate-issuer", "caseworker-probate-solicitor", "caseworker-probate-authoriser", "caseworker-probate-systemupdate", "caseworker-probate-scheduler", "caseworker-probate-caseofficer", "caseworker-probate-caseadmin", "caseworker-probate-registrar", "caseworker-probate-superuser", "caseworker-probate-charity", "payment", "caseworker-probate-bulkscan" ], "description": "ccd_gateway", "label": "ccd_gateway", "oauth2ClientId": "ccd_gateway", "oauth2ClientSecret": "ccd_gateway_secret", "oauth2RedirectUris": ["http://localhost:3451/oauth2redirect", "http://localhost:3000/oauth2/callback" ], "oauth2Scope": "string", "onboardingEndpoint": "string", "onboardingRoles": ["ccd-import", "caseworker", "caseworker-probate", "caseworker-probate", "caseworker-probate-issuer", "caseworker-probate-solicitor", "caseworker-probate-authoriser", "caseworker-probate-systemupdate", "caseworker-probate-caseofficer", "caseworker-probate-caseadmin", "caseworker-probate-registrar", "caseworker-probate-superuser", "caseworker-probate-charity", "payment", "caseworker-probate-bulkscan" ], "selfRegistrationAllowed": true}'

#Create all the role
$BIN_FOLDER/idam-role.sh caseworker
$BIN_FOLDER/idam-role.sh caseworker-probate
$BIN_FOLDER/idam-role.sh caseworker-probate-issuer
$BIN_FOLDER/idam-role.sh caseworker-probate-solicitor
$BIN_FOLDER/idam-role.sh caseworker-probate-authoriser
$BIN_FOLDER/idam-role.sh caseworker-probate-systemupdate
$BIN_FOLDER/idam-role.sh caseworker-probate-caseofficer
$BIN_FOLDER/idam-role.sh caseworker-probate-caseadmin
$BIN_FOLDER/idam-role.sh caseworker-probate-registrar
$BIN_FOLDER/idam-role.sh caseworker-probate-superuser
$BIN_FOLDER/idam-role.sh caseworker-probate-bulkscan
$BIN_FOLDER/idam-role.sh caseworker-probate-scheduler
$BIN_FOLDER/idam-role.sh caseworker-probate-charity
$BIN_FOLDER/idam-role.sh payment
$BIN_FOLDER/idam-role-assignable.sh ccd-import

#Assign all the roles to the ccd_gateway client
curl -XPUT \
  ${IDAM_URI}/services/ccd_gateway/roles \
 -H "Authorization: AdminApiAuthToken ${authToken}" \
 -H "Content-Type: application/json" \
 -d '["ccd-import", "caseworker", "caseworker-probate", "caseworker-probate", "caseworker-probate-issuer", "caseworker-probate-solicitor", "caseworker-probate-authoriser", "caseworker-probate-systemupdate", "caseworker-probate-caseofficer", "caseworker-probate-caseadmin", "caseworker-probate-registrar", "caseworker-probate-superuser", "caseworker-probate-charity", "caseworker-probate-scheduler", "payment"]'

