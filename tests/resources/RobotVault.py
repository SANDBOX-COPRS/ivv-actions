# pylint: disable=no-self-use
# pylint: disable=unspecified-encoding
import os
import requests

class RobotVault:
    """_summary_
      Class to retrieve elements from vault
    """
    def get_tenant_file(self):
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
        response = requests.get(str(os.environ['VAULT_URL'])+
          '/tests/'+str(username), headers=call_headers)
        return response.json()["data"]["password"]

    def get_s3cfg_secret(self):
        """_summary_
            Retrieves the s3cfg file from vault
        Returns:
            String: the .s3cfg file
        """
        call_headers = {'X-Vault-Token': os.environ['VAULT_TOKEN']}
        response = requests.get(str(os.environ['VAULT_URL'])+'/tests/s3cfg', headers=call_headers)
        return response.json()["data"]["secret"]
