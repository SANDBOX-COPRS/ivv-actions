**Keywords**
Login Through Keycloak
    [Arguments]         ${LOGIN}    ${PASSWORD}    ${URL}
    ${firefox_options}=  Evaluate  sys.modules['selenium.webdriver'].FirefoxOptions()  sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --headless
    Create Webdriver    Firefox    options=${firefox_options}
    Go To    ${URL}
    Input Text  username       ${LOGIN}
    Set Log Level    NONE
    Input Text  password       ${PASSWORD}
    Set Log Level    INFO
    Click button  kc-login