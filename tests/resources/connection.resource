*** Keywords ***
# Connection key words
Open Connection And Log In
    [Documentation]               Log in to the proxy gateway using the public key
    ...                           and stores the connection under the variable index
    ${index}=    Open Connection     ${PROXY}    timeout=600
    Set Suite Variable    ${index}
    Login With Public Key    ${USERNAME}    ${PROXY_KEYPATH}

Login To Host
    [Documentation]               Connect to the given host with the given hostkey through
    ...                           the proxy connection
    [Arguments]    ${host}    ${hostkey}
    Open connection   ${host}
    Login With Public Key    ${USERNAME}    ${hostkey}    jumphost_index_or_alias=${index}