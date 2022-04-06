**Keywords**
Retrieve all passwords
    Set Log Level    NONE
    ${OPERATOR_PASSWORD}=    Get user password    rb_operator    
    ${SECURITY_PASSWORD}=    Get user password    rb_security
    ${SUDO_PASSWORD}=        Get user password    rb_sudo
    ${FAKE_PASSWORD}=        Get user password    rb_fake
    ${KUBE_PASSWORD}=     Get user password    rb_kubectl
    Set Suite Variable    $OPERATOR_PASSWORD
    Set Suite Variable    $SECURITY_PASSWORD
    Set Suite Variable    $SUDO_PASSWORD
    Set Suite Variable    $FAKE_PASSWORD
    Set Suite Variable    $KUBE_PASSWORD
    Set Log Level    INFO