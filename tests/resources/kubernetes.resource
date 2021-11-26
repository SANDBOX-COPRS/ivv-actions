*** Keywords ***
Kubernetes Cluster Is Up
    [Documentation]                Checks whether the k8s cluster is fully up
    ...                            by checking no pod is in state Error or Init
    ${output}=    Execute Command    kubectl get pods -A
    Should Not Contain Any    ${output}    Init    Error

Wait For K8S To Start
    [Documentation]                Waits for the k8s cluster to be fully up
    Wait Until Keyword Succeeds    5 min 	20 sec    Kubernetes Cluster Is Up
    Sleep    0.2  # Prevents competitive access to the ssh connection 