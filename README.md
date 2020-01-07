localvault
----------

A set of [vault](https://www.vaultproject.io/) configuration scripts for managing a local vault instance on windows 10 machine.

## Prerequisites
[Docker Desktop](https://www.docker.com/products/docker-desktop)

## Installation
Enter the following commands in a CMD shell:
```
cd %USER_PROFILE%
git clone https://github.com/rstms/localvault.git
```

Add %HOME%/localvault to your path using control panel's system applet:
```
control sysdm.cpl
```

### Quickstart
```
localvault create
localvault start
localvault init >init.txt
write-unseal-script init.txt >unseal.cmd
write-login-script init.txt >login.cmd
unseal
login
localvault status
```


## `localvault` Usage
```
Usage:  localvault COMMAND

 Where COMMAND is: 
   create                 create new vault
   start                  start vault instance
   init                   initialize vault, generating keys and root token
   unseal KEY             unseal vault with key (3 keys required to unseal)
   vault                  run vault CLI command
   shell                  run a sh session in vault container
   status                 output vault status
   seal                   seal vault
   stop                   stop vault instance
   destroy                delete all localvault data
