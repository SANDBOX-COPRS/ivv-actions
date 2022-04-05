import requests
import os

class RobotVault:
    
    def get_tenant_file():
        """_summary_
        Retrieves the tenant file from vault
        """
        call_headers = {'X-Vault-Token': os.environ['VAULT_TOKEN']}
        response = requests.get(os.environ['VAULT_URL']+'/tenant', headers=call_headers)

        with open("tenants.yaml", "w") as f:
            f.write(response.json()["data"]["flexeng"])

    def get_user_password(self, username):
        """_summary_
            Retrieves the password from the indicated user
        Args:
            username (string): The username from which the password
            must be retrieved

        Returns:
            String: the password of the user
        """
        call_headers = {'X-Vault-Token': os.environ['VAULT_TOKEN']}
        response = requests.get(str(os.environ['VAULT_URL'])+'/tests/'+str(username), headers=call_headers)
        return response.json()["data"]["password"]