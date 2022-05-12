***Settings***
Documentation          TST_PRO_CRASH_S1 : This test verifies requirements
...                    RS-REQ-SRD-026
Library                SSHLibrary
Library                BuiltIn
Library                Collections
Library                ${RESOURCES}/RobotVault.py
Library                ${RESOURCES}/SafescaleOperator.py
Resource               ${RESOURCES}/passwords.resource
Resource               ${RESOURCES}/ssh_co.resource
Resource               ${RESOURCES}/ingestion.resource
Suite Setup            Run Keywords    Retrieve all passwords
...                    Get Platform Ip
Task Setup             SSH Connection To Platform                 rb_kubectl    ${KUBE_PASSWORD}    ${GATEWAY}
Task Teardown          Close All Connections

***Variables***
${RESOURCES}           ${CURDIR}${/}..${/}resources

***Test Cases***
Ingest A Session
    Set Log Level               Debug
    Get S3cfg File
    Write S3cfg File To Mock    s1pro-mock-webdav-cgs02-0    s1pro-mock-webdav-cgs02-webdav
    Copy Session                s1pro-mock-webdav-cgs02-0    s1pro-mock-webdav-cgs02-webdav    S1A    DCS_04_S1A_20220316131333042347_dat