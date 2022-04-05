import yaml
import json
import os
import requests
from RobotVault import RobotVault

class SafescaleOperator:

    def get_flex_credentials():
        """_summary_
        Retrieves the safescale tenants file and use it to
        retrieve the flexible engine credentials

        Returns:
            tuple: the flexible engine credentials
        """
        RobotVault.get_tenant_file()
        with open("tenants.yaml",'r') as f:
            docs = yaml.safe_load(f)
            username = docs["tenants"][0]["identity"]["Username"]
            password = docs["tenants"][0]["identity"]["Password"]
            domainName = docs["tenants"][0]["identity"]["DomainName"]
            projectId = docs["tenants"][0]["compute"]["ProjectID"]
        try:
            os.remove(os.getcwd()+"/tenants.yaml")
        except:
            None
        return(username, password, domainName, projectId)
    
    def get_flex_token():
        """_summary_
        Uses the flexible engine credentials to retrieve
        the flexible engine token via the API

        Returns:
            string: the flexible engine token
        """
        CRED = SafescaleOperator.get_flex_credentials()
        url = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3/auth/tokens"
        header = {"Content-Type": "application/json"}
        body = {"auth" : {
                    "identity" : {
                        "methods": ["password"],
                        "password": {
                            "user": {
                                "name" : CRED[0],
                                "password": CRED[1],
                                "domain": {
                                    "name" : CRED[2]
                                }
                            }
                        }
                    },
                    "scope": {
                        "project": {
                            "id": CRED[3]
                        }
                    }
                }
            }
        token = requests.post(url=url, headers=header, json=json.loads(json.dumps(body)))
        return token.headers['X-Subject-Token']
    
    def get_gateway_ip(self):
        """_summary_
        Uses the flexible engine api to retrieve the cluster gateway ip

        Returns:
            string: the gateway ip
        """

        TOKEN = SafescaleOperator.get_flex_token()
        CRED = SafescaleOperator.get_flex_credentials()
        
        URL = "https://ecs.eu-west-0.prod-cloud-ocb.orange-business.com/v2.1/"+CRED[3]+"/servers"
        HEADER = {"Content-Type": "application/json", "X-Auth-Token": TOKEN}
        # Get the gateway IPs
        servers = requests.get(url=URL, headers=HEADER)
        gatewayId = list(filter((lambda c: c['name'] == "gw-"+str(os.environ["CLUSTER_NAME"])),(servers.json()["servers"])))[0]['id']
        # Get the gateway description to retrieve its ip
        URL2 = URL+"/"+str(gatewayId)
        gatewayDetails = requests.get(url=URL2, headers=HEADER)
        addrKey = next(iter(gatewayDetails.json()["server"]["addresses"]))

        return(gatewayDetails.json()["server"]["addresses"][addrKey][1]['addr'])