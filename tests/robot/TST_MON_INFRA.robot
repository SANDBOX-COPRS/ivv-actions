***Settings***
Documentation          Monitoring Infra : This test verifies that:
...                    the RS provides a way to detect quickly infrastructure issues. [RS-REQ-SRD-011]
...                    the RS infrastructure components provides metrics for USE monitoring: Utilization, Saturation, Errors. [RS-REQ-SRD-024]
...                    Monitoring end points shall be accessible from authenticated users (belonging to a group with authorized access).  - [RS-REQ-SRD-SEC-050]
Library                SeleniumLibrary   
Library                BuiltIn
Library                SSHLibrary
Library                ${RESOURCES}/RobotVault.py
Library                ${RESOURCES}/SafescaleOperator.py
Resource               ${RESOURCES}/passwords.resource
Resource               ${RESOURCES}/website_login.resource 
Resource               ${RESOURCES}/ssh_co.resource
Suite Setup            Run Keywords    Retrieve all passwords
...                    Get Platform Ip
Suite Teardown         Run Keywords    Close All Browsers
...                    Close All Connections

*** Variables ***
${RESOURCES}           ${CURDIR}${/}..${/}resources
${URL}                 https://monitoring.platform1.ivv-csc.com/
${username_input}      username
${password_input}      password

*** Test Cases ***
# Login Through Keycloak
#     [Documentation]                 Login to Grafana
#     ...                             through Keycloak
#     Login Through Keycloak              rb_operator    ${OPERATOR_PASSWORD}    ${URL}
#     Wait Until Page Contains            Welcome to Grafana
#     Go To                               https://monitoring.platform1.ivv-csc.com/explore
#     Wait Until Page Contains            Thanos

# Check CPU Utilization
#     [Documentation]                     Check the cpu utilization for each node            
#     Go To                               https://monitoring.platform1.ivv-csc.com/explore?orgId=1&left=%5B%22now-1h%22,%22now%22,%22Thanos%22,%7B%22refId%22:%22A%22,%22instant%22:true,%22range%22:true,%22exemplar%22:false,%22expr%22:%221%20-%20avg%20without(cpu)%20(sum%20without(mode)%20(rate(node_cpu_seconds_total%7Bjob%3D%5C%22node-exporter%5C%22,mode%3D~%5C%22idle%7Ciowait%7Csteal%5C%22%7D%5B5m%5D)))%22%7D%5D
#     # The graph is present with lines
#     Wait Until Page Contains Element    class:css-1ns0gep-LegendLabel-LegendClickabel

# Check CPU Saturation
#     [Documentation]                     Check the cpu saturation for each node
#     Go To                               https://monitoring.platform1.ivv-csc.com/explore?orgId=1&left=%5B%22now-1h%22,%22now%22,%22Thanos%22,%7B%22refId%22:%22A%22,%22instant%22:true,%22range%22:true,%22exemplar%22:false,%22expr%22:%22(node_load1%7Bjob%3D%5C%22node-exporter%5C%22%7D%20%2F%20count%20without(cpu,%20mode)%20(node_cpu_seconds_total%7Bjob%3D%5C%22node-exporter%5C%22,mode%3D%5C%22idle%5C%22%7D))%20!%3D0%22%7D%5D
#     # The graph is present with lines
#     Wait Until Page Contains Element    class:css-1ns0gep-LegendLabel-LegendClickabel

# Check Disk Space Saturation
#     [Documentation]                     Check the disk space saturation for each node
#     Go To                               https://monitoring.platform1.ivv-csc.com/explore?orgId=1&left=%5B%22now-1h%22,%22now%22,%22Thanos%22,%7B%22refId%22:%22A%22,%22instant%22:true,%22range%22:true,%22exemplar%22:false,%22expr%22:%22sort_desc(1%20-%5Cn%5Cn(%5Cn%5Cnmax%20without%20(mountpoint,%20fstype)%20(node_filesystem_avail_bytes%7Bjob%3D%5C%22node-exporter%5C%22,%20fstype!%3D%5C%22%5C%22%7D)%5Cn%5Cn%2F%5Cn%5Cnmax%20without%20(mountpoint,%20fstype)%20(node_filesystem_size_bytes%7Bjob%3D%5C%22node-exporter%5C%22,%20fstype!%3D%5C%22%5C%22%7D)%5Cn%5Cn)%20!%3D%200)%22%7D%5D
#     # The graph is present with lines
#     Wait Until Page Contains Element    class:css-1ns0gep-LegendLabel-LegendClickabel

Check Disk Space Saturation After File Creation
    [Documentation]                     Fills a disk and checks the disk filling is
    ...                                 reported in prometheus
    # Connection to the gateway
    SSH Connection To Platform       rb_operator    ${OPERATOR_PASSWORD}    ${GATEWAY}
    # Get node-1 IP
    ${NODE1_IP}=                     Execute Command    cat /etc/hosts | grep node-1 | head -n 1 | awk '{print $1}'
    # Connection to node-1 using the gateway as proxy
    Open Connection                 ${NODE1_IP}
    Login                           rb_operator    ${OPERATOR_PASSWORD}    jumphost_index_or_alias=${GATEWAY_CONNECTION_INDEX}
    # Find space left on /tmp
    Write     df -h | grep /tmp | head -n 1 | awk '{print $4}'
    ${SPACE_LEFT_TMP}=    Read
    # Fill up the remaining space
    Write         fallocate -l ${SPACE_LEFT_TMP} /tmp/TST_MON_INFRA
    Read
    # Wait for the node exporter to probe the node
    Sleep                           30s
    # Check prometheus registered the full disk
    Write                 curl --data-urlencode 'query=node_filesystem_avail_bytes{job="node-exporter",fstype="ext4", instance="${NODE1_IP}:9100",mountpoint="/tmp"}' http://10.103.7.97:9090/prometheus/api/v1/query | jq -r '."data"."result"[0]."value"[1]'
    ${PROMETHEUS_VALUE}=    Read
    Should Be Equal As Integers    ${PROMETHEUS_VALUE}    0
    # Delete the empty file
    Execute Command    rm /tmp/TST_MON_INFRA