***Settings***
Documentation          Deployed Elastic Search : This test checks whether elk is deployed
...                    on the cluster. This test validates half of US #XXX
Library                SSHLibrary    
Library                BuiltIn
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections
Resource               ${RESOURCES}/gateways.resource 

*** Variables ***
${RESOURCES}            %{RF_RESOURCES}
${USERNAME}             safescale

*** Test Cases ***
Check if elk is deployed on the platform
    [Documentation]         This test checks whether elk is deployed
    ...                     on the cluster.
    ${output}=    Execute Command    helm list -A | grep elasticsearch
    Should Contain    ${output}    deployed

*** Keywords ***
Open Connection And Log In
    Open Connection     ${PROXY}
    Login With Public Key    ${USERNAME}    ${PROXY_KEYPATH}