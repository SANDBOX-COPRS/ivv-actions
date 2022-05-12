***Keywords***
Get S3cfg File
    ${S3CFG_CONTENT}=     Get S3cfg Secret
    Set suite Variable    ${S3CFG_CONTENT}

Write S3cfg File To Mock
    [Arguments]           ${MOCK_NAME}    ${MOCK_CONTAINER}
    Execute Command                            
    ...    kubectl exec -n processing ${MOCK_NAME} -c ${MOCK_CONTAINER} -- sh -c 'echo \"${S3CFG_CONTENT}\" > /root/.s3cfg'

Copy Session
    [Arguments]           ${MOCK_NAME}    ${MOCK_CONTAINER}    ${SESSION_TYPE}    ${SESSION_NAME}
    Execute Command
    ...    kubectl exec -n processing ${MOCK_NAME} -c ${MOCK_CONTAINER} -- sh -c 's3cmd get --no-ssl -r s3://testdata-rs-ivv/sessions/${SESSION_NAME} /var/lib/dav/data/NOMINAL/${SESSION_TYPE}'