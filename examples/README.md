examples
--------

These scripts show one way of using vault to provide a json configuration file


### use the root token to create an approle with read access to the secrets at `/kv/<ROLE_NAME>/*`
```
mkrueger@beaker:~/src/localvault/examples$ ROOT_TOKEN=<root token from localvault init>
mkrueger@beaker:~/src/localvault/examples$ ./create-approle $ROOT_TOKEN testapp
Success! Uploaded policy: testapp
Success! Data written to: auth/approle/role/testapp
ROLE_ID=94355831-1842-a815-8cc2-974594ed836c
SECRET_ID=d5b49612-d563-b35a-044c-bcbff4e14aa5
```
### use the root token to write example data to <ROLE_NAME>/<SECRET_NAME>
```
mkrueger@beaker:~/src/localvault/examples$ ./write-secret $ROOT_TOKEN testapp/config <config.json
Success! Data written to: kv/testapp/config
```

### (copy/paste from stdout to set ROLE_ID, SECRET_ID vars)
```
mkrueger@beaker:~/src/localvault/examples$ ROLE_ID=94355831-1842-a815-8cc2-974594ed836c
mkrueger@beaker:~/src/localvault/examples$ SECRET_ID=d5b49612-d563-b35a-044c-bcbff4e14aa5
```

### Finally, use the ROLE_ID and SECRET_ID to read the data at <ROLE_NAME>/<SECRET_NAME>
```
mkrueger@beaker:~/src/localvault/examples$ ./read-secret $ROLE_ID $SECRET_ID testapp/config
{
  "kniggits": [
    "Lancelot",
    "Bedeviere",
    "Robin"
  ],
  "words": "Ni"
}
```
