***Settings***
Documentation          Deployed Kafka : This test checks whther kafka is deployed
...                    on the cluster. This test validates half of US #90
Library                SSHLibrary    
Library                BuiltIn
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections
Resource               ${RESOURCES}/gateways.resource 

*** Variables ***
${RESOURCES}            resources
${USERNAME}             safescale

*** Test Cases ***
Check if kafka is deployed on the platform
    [Documentation]         This test checks whether kafka is deployed
    ...                     on the cluster.
    ${output}=    Execute Command    helm list -A | grep kafka
    Should Contain    ${output}    deployed

*** Keywords ***
Open Connection And Log In
    Open Connection     ${PROXY}
    Login With Public Key    ${USERNAME}    ${PROXY_KEYPATH}