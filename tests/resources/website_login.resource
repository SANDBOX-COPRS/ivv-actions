**Keywords**
Open Browser To URL
    [Arguments]         ${URL}
    ${firefox_options}=  Evaluate  sys.modules['selenium.webdriver'].FirefoxOptions()  sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --headless
    Create Webdriver    Firefox    options=${firefox_options}
    Go To    ${URL}                      


Login Through Keycloak
    [Arguments]         ${LOGIN}    ${PASSWORD}    ${URL}
    Open Browser To URL    ${URL}
    Input Text  username       ${LOGIN}
    Set Log Level    NONE
    Input Text  password       ${PASSWORD}
    Set Log Level    INFO
    Click button  kc-login