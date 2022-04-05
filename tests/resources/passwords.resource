**Keywords**
Retrieve all passwords
    ${OPERATOR_PASSWORD}=    Get user password    rb_operator    
    ${SECURITY_PASSWORD}=    Get user password    rb_security
    ${SUDO_PASSWORD}=        Get user password    rb_sudo
    ${FAKE_PASSWORD}=        Get user password    rb_fake
    Set Suite Variable    $OPERATOR_PASSWORD
    Set Suite Variable    $SECURITY_PASSWORD
    Set Suite Variable    $SUDO_PASSWORD
    Set Suite Variable    $FAKE_PASSWORD