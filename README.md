localvault
----------

A set of [vault](https://www.vaultproject.io/) configuration scripts for managing a local vault instance in a docker container on a Windows 10 machine.   Because.

## Prerequisites
[Docker Desktop](https://www.docker.com/products/docker-desktop)

## Installation
Enter the following commands in a CMD shell:
```
cd %HOME%
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
   init                   initialize vault, generating keys and root token
   destroy                delete all localvault data
   start                  start vault container
   stop                   stop and seal vault container
   status                 output vault status
   unseal KEY             unseal vault with key (3 keys required to unseal)
   vault ARG [...]        run vault CLI command
   exec 'CMDLINE'         execute shell command in the vault container
   shell                  interactive shell session in vault container
   seal                   seal vault

```
