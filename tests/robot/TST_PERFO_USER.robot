***Settings***
Documentation          Security Services : This test aims at checking every
...                    services mentionned in story #87 are installed and running
Library                SeleniumLibrary   
Library                BuiltIn      
Suite Teardown         Close All Browsers

*** Variables ***
${URL}                 https://processing.platform1.ivv-csc.com/
${username_input}      username
${password_input}      password
${submit_login}        kc-login
${max_users}           50
${results_tab}        //*[contains(text(),"RESULTS")]

*** Test Cases ***
Login Through Keycloak
    [Documentation]                 Login to the User Web Interface
    ...                             through Keycloak
    FOR    ${user}    IN RANGE    0     ${max_users}
        Open Browser To User Web Client Page
        Input Text  ${username_input}       test-user-${user}
        Input Text  ${password_input}       Supertoto-123
        Click button  ${submit_login}
        Wait Until Location Is              https://processing.platform1.ivv-csc.com/  timeout=30
        Wait Until Page Contains Element    class:clr-col-5
        Click Element                       ${results_tab}
        Wait Until Page Contains Element    class:datagrid-cell      timeout=30
        Log To Console                      User ${user} is done
    END


*** Keywords ***
Open Browser To User Web Client Page
    ${firefox_options}=  Evaluate  sys.modules['selenium.webdriver'].FirefoxOptions()  sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --headless
    Create Webdriver    Firefox    options=${firefox_options}
    Go To    ${URL}