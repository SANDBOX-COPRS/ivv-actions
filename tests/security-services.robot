***Settings***
Documentation          Security Services : This test aims at checking every
...                    services mentionned in story #87 are installed and running
Library                SSHLibrary    
Library                BuiltIn
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections
Resource               ${RESOURCES}/gateways.resource 
Resource               ${RESOURCES}/nodes.resource
Resource               ${RESOURCES}/masters.resource

*** Variables ***
${RESOURCES}            resources
${USERNAME}             safescale

*** Test Cases ***
# Add check Ansible playbook is present
Get Length of all hosts lists
    [Documentation]       This first step evaluate the total number of hosts
    ...                 and their kind

    ${nodes_length}=    Get Length   ${NODES}
    Set Suite Variable    ${nodes_length}

    ${masters_length}=    Get Length    ${MASTERS}
    Set Suite Variable    ${masters_length}

    ${gateways_length}=    Get Length    ${GATEWAYS}
    Set Suite Variable    ${gateways_length}

Check auditd is running on all gateways
    [Documentation]       This test aims to check whether all gateways have
    ...                 the running process auditd
    
    FOR    ${gateway_index}    IN RANGE    0     ${gateways_length}
        Login To Host  ${GATEWAYS}[${gateway_index}]    ${GATEWAYS_KEYS}[${gateway_index}]
        ${output}=    Execute Command    systemctl status auditd
        Should Contain    ${output}    active
        Close Connection
    END

Check auditd is running on all nodes
    [Documentation]       This test aims to check whether all nodes have
    ...                 the running process auditd

    FOR    ${nodes_index}    IN RANGE    0     ${nodes_length}
        Login To Host  ${NODES}[${nodes_index}]    ${NODES_KEYS}[${nodes_index}]
        ${output}=    Execute Command    systemctl status auditd
        Should Contain    ${output}    active
        Close Connection
    END

Check auditd is running on all masters
    [Documentation]       This test aims to check whether all masters have
    ...                 the running process auditd

    FOR    ${masters_index}    IN RANGE    0     ${masters_length}
        Login To Host  ${MASTERS}[${masters_index}]    ${MASTERS_KEYS}[${masters_index}]
        ${output}=    Execute Command    systemctl status auditd
        Should Contain    ${output}    active
        Close Connection
    END

Check Wazuh Agent is installed on all nodes
    [Documentation]       This test aims to check whether all nodes have
    ...                 the running process wazuh agent

    FOR    ${nodes_index}    IN RANGE    0     ${nodes_length}
        Login To Host  ${NODES}[${nodes_index}]    ${NODES_KEYS}[${nodes_index}]
        ${output}=    Execute Command    systemctl status wazuh-agent
        Should Contain    ${output}    active
        Close Connection
    END

Check Wazuh Manager is installed on all masters
    [Documentation]       This test aims to check whether all masters have
    ...                 the running process wazuh manager

    FOR    ${masters_index}    IN RANGE    0     ${masters_length}
        Login To Host  ${MASTERS}[${masters_index}]    ${MASTERS_KEYS}[${masters_index}]
        ${output}=    Execute Command    systemctl status wazuh-manager
        Should Contain    ${output}    active
        Close Connection
    END

Check ClamAV is installed on all masters
    [Documentation]       This test aims to check whether all masters have
    ...                 the running process clamav

    FOR    ${masters_index}    IN RANGE    0     ${masters_length}
        Login To Host  ${MASTERS}[${masters_index}]    ${MASTERS_KEYS}[${masters_index}]
        ${output}=    Execute Command    systemctl status clamav-freshclam
        Should Contain    ${output}    active
        Close Connection
    END

Check ClamAV is installed on all gateways
    [Documentation]       This test aims to check whether all gateways have
    ...                 the running process clamav

    FOR    ${gateway_index}    IN RANGE    0     ${gateways_length}
        Login To Host  ${GATEWAYS}[${gateway_index}]    ${GATEWAYS_KEYS}[${gateway_index}]
        ${output}=    Execute Command    systemctl status clamav-freshclam
        Should Contain    ${output}    active
        Close Connection
    END

Check Suricata is running on all gateways
    [Documentation]       This test aims to check whether all gateways have
    ...                 the running process suricata

    FOR    ${gateway_index}    IN RANGE    0     ${gateways_length}
        Login To Host  ${GATEWAYS}[${gateway_index}]    ${GATEWAYS_KEYS}[${gateway_index}]
        ${output}=    Execute Command    systemctl status suricata
        Should Contain    ${output}    active
        Close Connection
    END

Check OpenVPN is running on all gateways
    [Documentation]       This test aims to check whether all gateways have
    ...                 the running process openvpn

    FOR    ${gateway_index}    IN RANGE    0     ${gateways_length}
        Login To Host  ${GATEWAYS}[${gateway_index}]    ${GATEWAYS_KEYS}[${gateway_index}]
        ${output}=    Execute Command    systemctl status openvpn
        Should Contain    ${output}    active
        Close Connection
    END


*** Keywords ***
Open Connection And Log In
    ${index}=    Open Connection     ${PROXY}
    Set Suite Variable    ${index}
    Login With Public Key    ${USERNAME}    ${PROXY_KEYPATH}

Login To Host
    [Arguments]    ${host}    ${hostkey}
    Open connection   ${host}
    Login With Public Key    ${USERNAME}    ${hostkey}    jumphost_index_or_alias=${index}