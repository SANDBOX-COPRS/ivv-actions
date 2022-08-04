**Keywords**
Get Platform IP
    ${GATEWAY}=         Get Gateway Ip
    Set Suite Variable    ${GATEWAY}

SSH Connection To Platform
    [Arguments]         ${LOGIN}    ${PASSWORD}    ${IP}
    ${GATEWAY_CONNECTION_INDEX}=    Open Connection     ${IP}
    Set Suite Variable      $GATEWAY_CONNECTION_INDEX
    # Setting logs to None so the password is not in logs
    Set Log Level    None
    # Continuing on failure to set the log level to info info
    # after possible fail login
    BuiltIn.Run Keyword And Continue On Failure    Login    ${LOGIN}    ${PASSWORD}
    Set Log Level    INFO