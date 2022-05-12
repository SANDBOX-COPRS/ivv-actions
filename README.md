# IVV Actions

## Configuration

Necessary environment variable:
 - VAULT_URL: vault url including the path to the folder in which the users passwords are stored. 
   Example: *https://myvault.com/v1/myfolder* if the users passwords are stored at: *https://myvault.com/v1/myfolder/rb_user*
 - VAULT_TOKEN: the vault token 
 - CLUSTER_NAME: the name of your cluster. For instance, if your servers are named *my-cluster-node-x*, your cluster name is "my-cluster"