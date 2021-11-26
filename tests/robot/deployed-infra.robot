***Settings***
Documentation          Deployed Infrastructure : this test checks whether the desired 
...                    cluster configuration is the configuration that was deployed.
...                    To check the nodes available on the cluster, robot framework connects
...                    to the gateway using its SSH key. This test aims to check the
...                    conditions of US #97.
Library                SSHLibrary
Library                BuiltIn
Library                Collections
Library                OperatingSystem
Resource               ${RESOURCES}/infra.resource
Resource               ${RESOURCES}/connection.resource
Resource               ${RESOURCES}/kubernetes.resource
Suite Setup            Setup
Suite Teardown         Close All Connections
Test Teardown          Sleep    0.2    # Sleep to avoid all connections arrive at the same time as a limited number of sessions
                                       # is allowed on each host

*** Variables ***
${RESOURCES}            %{RF_RESOURCES}
${USERNAME}             safescale
${EXPECTED_NODES}       3
${EXPECTED_INGESTERS}   1
${EXPECTED_MASTERS}     1
${EXPECTED_GATEWAYS}    1

*** Test Cases ***
Check there are the right number of nodes
    [Documentation]       This test checks the number of nodes deployed
    ...                   in the cluster and compares it to the expected number
    ${output}=    Execute Command    sed -n '/BEGIN$/,\${p;/END$/q}' /etc/hosts | grep node | wc -l
    Should Be Equal As Integers    ${output}     ${${EXPECTED_NODES}+${EXPECTED_INGESTERS}}

Check there are the right number of masters
    [Documentation]       This test checks the number of masters deployed
    ...                   in the cluster and compares it to the expected number
    ${output}=    Execute Command    sed -n '/BEGIN$/,\${p;/END$/q}' /etc/hosts | grep master | wc -l
    Should Be Equal As Integers    ${output}     ${EXPECTED_MASTERS}

Check there are the right number of gateways
    [Documentation]       This test checks the number of gateways deployed
    ...                   in the cluster and compares it to the expected number
    ${output}=    Execute Command    sed -n '/BEGIN$/,\${p;/END$/q}' /etc/hosts | grep gw | wc -l
    Should Be Equal As Integers    ${output}     ${EXPECTED_GATEWAYS}

Check volumes deployed through safescale
     [Documentation]      This test uses safescale to list current volumes and check
     ...                  the expected volumes are present
     ${output}=           Run    safescale volume list | jq '.result[].attachments[].host.name'
     FOR    ${node_name}    IN     @{NODES_NAMES}
         Should Contain    ${output}    ${node_name}
    END

Check all hosts are in the network
    [Documentation]       This test checks whether all adresses are in the
    ...                   network
    ${output}=    Execute Command    ip neigh | grep '192.168.*' | cut -d ' ' -f 1
    ${HOSTS}=    Combine Lists    ${INGESTERS}    ${NODES}    ${MASTERS}    # TODO: Add second gateway when used

    FOR    ${host}    IN   @{HOSTS}
        Should Contain    ${output}    ${host}
    END

*** Keywords ***
Setup
    Run Keywords    Open Connection And Log In    Wait For K8S To Start