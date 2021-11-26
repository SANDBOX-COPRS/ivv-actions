***Settings***
Documentation          Deployed Kafka : This test checks whether kafka is deployed
...                    on the cluster. This test validates half of US #90
Library                SSHLibrary    
Library                BuiltIn
Suite Setup            Setup
Resource               ${RESOURCES}/infra.resource
Resource               ${RESOURCES}/connection.resource
Resource               ${RESOURCES}/kubernetes.resource

*** Variables ***
${RESOURCES}            %{RF_RESOURCES}
${USERNAME}             safescale

*** Test Cases ***
Check if kafka is deployed on the platform
    [Documentation]         This test checks whether kafka is deployed
    ...                     on the cluster.
    ${output}=    Execute Command    helm list -A | grep kafka
    Should Contain    ${output}    deployed

*** Keywords ***
Setup
    Run Keywords    Open Connection And Log In    Wait For K8S To Start