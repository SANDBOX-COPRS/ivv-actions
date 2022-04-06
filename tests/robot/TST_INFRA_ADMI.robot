***Settings***
Documentation          TST_INFRA_ADMI : This test verifies requirements
...                    RS-REQ-SRD-SEC-002 and RS-REQ-SRD-SEC-003
Library                SeleniumLibrary    run_on_failure=Nothing
Library                SSHLibrary
Library                BuiltIn
Library                ${RESOURCES}/RobotVault.py
Library                ${RESOURCES}/SafescaleOperator.py
Resource               ${RESOURCES}/passwords.resource
Resource               ${RESOURCES}/ssh_co.resource
Resource               ${RESOURCES}/website_login.resource
Suite Setup            Run Keywords    Retrieve all passwords
...                    Get Platform Ip
Suite Teardown         Run Keywords    Close All Browsers
...                    Close All Connections

**Variables**
${GRAFANA}             https://monitoring.platform1.ivv-csc.com/
${RESOURCES}           ${CURDIR}${/}..${/}resources

**Test Cases**
Unregistered ssh connection to platform 
    [Documentation]               Checks it is impossible for an unregistered user
    ...                           to connect via ssh to the rs-platform
    Run Keyword And Expect Error    STARTS: Authentication failed
    ...                             SSH Connection To Platform    rb_fake    ${FAKE_PASSWORD}    ${GATEWAY}

Unregistered application connection
    [Documentation]               Checks it is impossible for an unregistered user
    ...                           to connect to an rs-platform application
    Login Through Keycloak           rb_fake  ${FAKE_PASSWORD}  ${GRAFANA}
    Run Keyword And Expect Error     STARTS: Location did not become
    ...                              Wait Until Location Is    https://monitoring.platform1.ivv-csc.com/\?orgId=1    timeout=15

Operator connection to grafana
    [Documentation]               Checks a user with the authorization can
    ...                           login to an rs-platform and logout
    Login Through Keycloak              rb_operator  ${OPERATOR_PASSWORD}  ${GRAFANA}
    Wait Until Location Is              https://monitoring.platform1.ivv-csc.com/\?orgId=1    timeout=15
    Go To                               https://monitoring.platform1.ivv-csc.com/logout
    Wait Until Page Contains Element    username    timeout=15

Operator ssh connection to platform 
    [Documentation]               Checks a user with the authorization can
    ...                           login and logout to the rs-platform
    SSH Connection To Platform    rb_operator    ${OPERATOR_PASSWORD}    ${GATEWAY}
    Execute Command               logout

Operator sudo test
    [Documentation]               Checks a user without authorization
    ...                           cannot use the sudo command
    SSH Connection To Platform            rb_operator    ${OPERATOR_PASSWORD}    ${GATEWAY}
    ${returnCode}=    Execute Command     echo ${OPERATOR_PASSWORD} \| sudo -S su    return_stdout=False    return_rc=True
    Should Be Equal                       ${returnCode}      ${1}

Sudoer sudo test
    [Documentation]               Checks an authorized user can use the sudo command
    SSH Connection To Platform            rb_sudo    ${SUDO_PASSWORD}    ${GATEWAY}
    ${returnCode}=    Execute Command     echo ${SUDO_PASSWORD} \| sudo -S su    return_stdout=False    return_rc=True
    Should Be Equal                       ${returnCode}      ${0}