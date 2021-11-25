***Settings***
Documentation          Deployed Databases : This test checks whether the chosen databases
...                    (elasticsearch, postgresql and mongodb) are deployed on the cluster
...                    and in the chosen version. This test validates part of US #84
Library                SSHLibrary    
Library                BuiltIn
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections
Test Teardown          Sleep    0.2
Resource               ${RESOURCES}/gateways.resource 

*** Variables ***
${RESOURCES}            %{RF_RESOURCES}
${USERNAME}             safescale

*** Test Cases ***
Check if elasticsearch is deployed on the platform
    [Documentation]         This test checks whether elasticsearch is deployed
    ...                     on the cluster.
    ${output}=    Execute Command    helm list -A | grep elasticsearch
    Should Contain    ${output}    deployed

Check if elasticsearch version is 7.15
    [Documentation]         This test checks whether elasticsearch is
    ...                     deployed with the correct version
    ${output}=    Execute Command    kubectl -n infra exec -it $(kubectl -n infra get pods -l "app=master, app.kubernetes.io/instance=elasticsearch" -o jsonpath='{.items[0].metadata.name}') -- elasticsearch --version
    Should Contain    ${output}    7.15

Check if postgresql is deployed on the platform
    [Documentation]         This test checks whether postgresql is deployed
    ...                     on the cluster.
    ${output}=    Execute Command    helm list -A | grep postgresql
    Should Contain    ${output}    deployed

Check if posqtgresql version is v14
    [Documentation]         This test checks whether postgresql is
    ...                     deployed with the correct version
    ${output}=    Execute Command    kubectl -n infra exec -it $(kubectl -n infra get pods -l "app.kubernetes.io/instance=postgresql, app.kubernetes.io/component=primary" -o jsonpath='{.items[0].metadata.name}') -- postgres -V postgres
    Should Contain    ${output}    14

Check if mongodb is deployed on the platform
    [Documentation]         This test checks whether mongodb is deployed
    ...                     on the cluster.
    ${output}=    Execute Command    helm list -A | grep mongodb
    Should Contain    ${output}    deployed

Check if mongodb version is v5
    [Documentation]         This test checks whether mongodb is
    ...                     deployed with the correct version

    ${output}=   Execute Command    kubectl -n infra exec -it $(kubectl -n infra get pods -l "app.kubernetes.io/instance=mongodb" -o jsonpath='{.items[0].metadata.name}') -- mongod --version
    Should Contain    ${output}    v5

*** Keywords ***
Open Connection And Log In
    Open Connection     ${PROXY}    timeout=600
    Login With Public Key    ${USERNAME}    ${PROXY_KEYPATH}