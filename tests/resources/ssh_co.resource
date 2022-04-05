**Keywords**
Get Platform IP
    ${GATEWAY}=         Get Gateway Ip
    Set Suite Variable    ${GATEWAY}

SSH Connection To Platform
    [Arguments]         ${LOGIN}    ${PASSWORD}    ${IP}
    Open Connection     ${IP}
    Login    ${LOGIN}    ${PASSWORD}