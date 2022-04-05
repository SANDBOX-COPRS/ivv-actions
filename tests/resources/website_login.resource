**Keywords**
Login Through Keycloak
    [Arguments]         ${LOGIN}    ${PASSWORD}    ${URL}
    ${firefox_options}=  Evaluate  sys.modules['selenium.webdriver'].FirefoxOptions()  sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --headless
    Create Webdriver    Firefox    options=${firefox_options}
    Go To    ${URL}
    Input Text  username       ${LOGIN}
    Input Text  password       ${PASSWORD}
    Click button  kc-login