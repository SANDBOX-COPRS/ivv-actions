***Settings***
Documentation          TST_INFRA_ADMI : This test verifies requirements
...                    RS-REQ-SRD-SEC-002 and RS-REQ-SRD-SEC-003
Library                SSHLibrary
Library                BuiltIn
Library                Collections
Library                ${RESOURCES}/RobotVault.py
Library                ${RESOURCES}/SafescaleOperator.py
Resource               ${RESOURCES}/passwords.resource
Resource               ${RESOURCES}/ssh_co.resource
Suite Setup            Run Keywords    Retrieve all passwords
...                    Get Platform Ip
Task Setup             SSH Connection To Platform                 rb_kubectl    ${KUBE_PASSWORD}    ${GATEWAY}
Task Teardown          Close All Connections

**Variables**
${RESOURCES}           ${CURDIR}${/}..${/}resources

**Test Cases**
Double S1 Worker Pods
    # Set the number of worker to 2
    Execute Command                            
    ...    kubectl scale statefulset -n processing s1pro-l0-aio-ipf-preparation-worker --replicas\=2
    # Checking that 2 pods are deployed as expected
    Write    
    ...    kubectl get statefulset -n processing s1pro-l0-aio-ipf-preparation-worker -o\=jsonpath='\{.status.replicas\}' && sleep 10
    ${deployedReplicas}=    Read     delay=0.5
    Should Contain                  ${deployedReplicas}      2

Check Kafka Message Distribution
    Sleep     30s
    ${pods}=    Execute Command                            
    ...    kubectl exec -it -n infra kafka-cluster-kafka-0 -c kafka -- /opt/kafka/bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group l0-aio-ipf-preparation-worker | awk '{print $7}' | sed 's/s1pro//g' | sed 's/l0-aio-ipf-preparation-worker//g' | sed 's/\r//g' | column -t -s ' ' | tail -n 2 | cut -c 3
    Should Contain            ${pods}    1
