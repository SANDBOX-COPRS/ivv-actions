***Settings***
Documentation          This test checks whether the desired cluster configuration
...                    is the configuration that was deployed. To check the nodes
...                    available on the cluster, robot framework connects to the
...                    gateway using its SSH key. This test aims to check the
...                    conditions of US #97.
Library                SSHLibrary
Library                BuiltIn
Library                Collections
Resource               ${RESOURCES}/gateways.resource
Resource               ${RESOURCES}/nodes.resource 
Resource               ${RESOURCES}/masters.resource 
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections

*** Variables ***
${RESOURCES}            resources
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
    Sleep    0.2  # Sleep to avoid all connections arrive at the same time as a limited number of sessions
                  # is allowed on each host

Check there are the right number of masters
    [Documentation]       This test checks the number of masters deployed
    ...                   in the cluster and compares it to the expected number
    ${output}=    Execute Command    sed -n '/BEGIN$/,\${p;/END$/q}' /etc/hosts | grep master | wc -l
    Should Be Equal As Integers    ${output}     ${EXPECTED_MASTERS}
    Sleep    0.2 

Check there are the right number of gateways
    [Documentation]       This test checks the number of gateways deployed
    ...                   in the cluster and compares it to the expected number
    ${output}=    Execute Command    sed -n '/BEGIN$/,\${p;/END$/q}' /etc/hosts | grep gw | wc -l
    Should Be Equal As Integers    ${output}     ${EXPECTED_GATEWAYS}
    Sleep    0.2 

Check there are the right numbers of volumes through rook-ceph
    [Documentation]       This test connects to the rook-ceph tools pod to list
    ...                   the current rook-ceph volumes. They should match the
    ...                   number of expected nodes.
    ${output}=    Execute Command    kubectl -n infra exec -it $(kubectl -n infra get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') -- ceph osd status | grep 'cluster-ivv-node' | wc -l
    Should Be Equal As Integers    ${output}    ${EXPECTED_NODES}
    Sleep    0.2 

Check all hosts are in the network
    [Documentation]       This test checks whether all adresses are in the
    ...                   network
    ${output}=    Execute Command    ip neigh | grep '192.168.*' | cut -d ' ' -f 1
    ${HOSTS}=    Combine Lists    ${NODES}    ${MASTERS}    # TODO: Add second gateway when used

    FOR    ${host}    IN   @{HOSTS}
        Should Contain    ${output}    ${host}
    END

*** Keywords ***
Open Connection And Log In
    Open Connection     ${PROXY}
    Login With Public Key    ${USERNAME}    ${PROXY_KEYPATH}