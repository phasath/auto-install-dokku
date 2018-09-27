
# Table of Contents
- [Table of Contents](#table-of-contents)
- [AutoConfigure Dokku on Ubuntu or CentOS server](#autoconfigure-dokku-on-ubuntu-or-centos-server)
    - [Add the pub keys that will be used on Dokku](#add-the-pub-keys-that-will-be-used-on-dokku)
    - [Add the SSH Keys to the server](#add-the-ssh-keys-to-the-server)
- [How to Install?](#how-to-install)
    - [install.sh](#installsh)
- [AutoConfigurar Dokku em servidor Ubuntu ou CentOS](#autoconfigurar-dokku-em-servidor-ubuntu-ou-centos)
    - [Adicione as chaves públicas utilizadas no Dokku](#adicione-as-chaves-p%C3%BAblicas-utilizadas-no-dokku)
    - [Adicione as chaves SSH do servidor](#adicione-as-chaves-ssh-do-servidor)
- [Como instalar](#como-instalar)
    - [Arquivo install.sh](#arquivo-installsh)

# AutoConfigure Dokku on Ubuntu or CentOS server

Don't you know what is Dokku? See it [here](https://github.com/dokku/dokku)

All the server configuration will be held in this repository so we can configure the server. 
I ask you to fork this repository to edit and add set your configuration.

> Make a fork so you can configure it

## Add the pub keys that will be used on Dokku

The keys in `pub_keys` will be inserted on Dokku. The key must be the username on Dokku plus the `.pub` extension.

## Add the SSH Keys to the server

Add all the ssh keys used on server to autheticate this server on folder `ssh/keys`.

# How to Install?

## install.sh

Use the file `install.sh` to configure the necessary stuff so you can ssh into the machine and then, install and configure dokku on the server.

Execution:

```
$ bash install.sh [-h?] [-H HOST IP] [-p PORT] [-u USERNAME] [-c USERNAME TO BE CREATED] [-d DOMAIN] [-i IDENTITY FILE PATH] [-a ALLOW USERS] 
```

Usage: 

|Command|Action|
|---|---|
|-h|Show help|
|-?|Show help|
|-H|Host IP to connect over SSH|
|-p|Port to connect through SSH|
|-u|Username used to connect|
|-d|Domain to add on dokku|
|-c|Username to be created. This will override -u user|
|-i|Identity file path. Default is /home/{user}/.ssh/id_rsa|
|-a|`AllowUsers` on `sshd_config`. Ex:. 'raphael.sathler john.doe ze.ninguem'|

> DON'T RUN THIS AS SUDO


---

# AutoConfigurar Dokku em servidor Ubuntu ou CentOS

Não sabe o que é o Dokku? Veja [aqui](https://github.com/dokku/dokku)

Todas as configurações do Servidor serão armazenadas nesse repositório para que possamos replicar e automatizar a configuração e instalação de um servidor novo.

> Faça um fork para que você possa editar 

## Adicione as chaves públicas utilizadas no Dokku

As chaves em `pub_keys` serão inseridas no Dokku. O nome do usuário considerado é o nome da chave (removendo a extensão `.pub`).

## Adicione as chaves SSH do servidor

Adicione as chaves que serão utilizadas no servidor para autenticá-lo na pasta `ssh/keys`.

# Como instalar

## Arquivo [install.sh](https://github.com/phasath/auto-install-dokku/blob/master/install.sh)

Use o arquivo install para configurar os passos básicos necessários no servidor fazendo diretamente pela sua máquina

Execução:

```
$ bash install.sh [-h?] [-H HOST IP] [-p PORT] [-u USERNAME] [-c USERNAME TO BE CREATED] [-d DOMAIN] [-i IDENTITY FILE PATH] [-a ALLOW USERS] 
```

Uso: 

|Comando|Ação|
|---|---|
|-h|Mostrar a ajuda|
|-?|Mostrar a ajuda|
|-H|Host IP usado para conectar via SSH|
|-p|Port usada para conectar via SSH|
|-u|Usuário usado para conectar|
|-d|Domínio para ser utilizado no dokku|
|-c|Usuário a ser criado no servidor. Essa flag ira sobreescrever -u user|
|-i|Caminho para o arquivo de identidade. Padrão é /home/{user}/.ssh/id_rsa|
|-a|AllowUsers adicionadas no `sshd_config`. Ex:. 'raphael.sathler john.doe ze.ninguem'|