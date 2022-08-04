***Settings***
Documentation          Monitoring Infra : This test verifies that:
...                    the RS provides a way to detect quickly infrastructure issues. [RS-REQ-SRD-011]
...                    the RS infrastructure components provides metrics for USE monitoring: Utilization, Saturation, Errors. [RS-REQ-SRD-024]
...                    Monitoring end points shall be accessible from authenticated users (belonging to a group with authorized access).  - [RS-REQ-SRD-SEC-050]
Library                SeleniumLibrary   
Library                BuiltIn
Library                ${RESOURCES}/RobotVault.py
Library                ${RESOURCES}/SafescaleOperator.py
Resource               ${RESOURCES}/passwords.resource    
Suite Setup            Retrieve all passwords
Suite Teardown         Close All Browsers

*** Variables ***
${RESOURCES}           ${CURDIR}${/}..${/}resources
${URL}                 https://monitoring.platform1.ivv-csc.com/

***Test Cases***
Login Through Keycloak
    [Documentation]                     Login to Grafana through Keycloak
    Login Through Keycloak              rb_operator    ${OPERATOR_PASSWORD}    ${URL}
    Wait Until Location Is              https://monitoring.platform1.ivv-csc.com/  timeout=30
    Wait Until Page Contains            Welcome to Grafana

Check Elasticsearch datasource is available
    Go To                               https://monitoring.platform1.ivv-csc.com/datasources
    Wait Until Page Contains            Elasticsearch

Check Elasticsearch traces are available
    Go To                               https://monitoring.platform1.ivv-csc.com/explore?orgId=1&left=%5B%22now-1M%2FM%22,%22now-1M%2FM%22,%22ES-traces%22,%7B%22refId%22:%22A%22,%22query%22:%22%22,%22alias%22:%22%22,%22metrics%22:%5B%7B%22id%22:%221%22,%22type%22:%22count%22%7D%5D,%22bucketAggs%22:%5B%7B%22type%22:%22date_histogram%22,%22id%22:%222%22,%22settings%22:%7B%22interval%22:%221d%22%7D,%22field%22:%22@timestamp%22%7D%5D,%22timeField%22:%22@timestamp%22%7D%5D
    # Traces are available
    Wait Until Page Contains Element    class:css-1rk4n5m









***Keywords***
Open Browser To Grafana
    ${firefox_options}=  Evaluate  sys.modules['selenium.webdriver'].FirefoxOptions()  sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --headless
    Create Webdriver    Firefox    options=${firefox_options}
    Go To    ${URL}                      
