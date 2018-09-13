# Configurações do Servidor WEB

Todas as configurações do Servidor Web serão armazenadas nesse repositório para que possamos replicar e automatizar a configuração e instalação de um servidor novo.

## Configurações que serão versionadas

As configurações do SSH serão trackeadas por este repositório a fim de termos controle sobre tudo o que é alterado para evitar falhas de seguranças e mudanças manuais serão:

- SSH

# Como instalar

## install.sh

Use o arquivo install para configurar os passos básicos necessários no servidor fazendo diretamente pela sua máquina

Execução:

```
$ bash install.sh host_address port username domain
```

Onde:
    host_adress é o endereço IP do servidor
    port é a porta do servidor
    username é o usuário com permissões root para acessar o servidor
    domain é o domínioa ser usado pelo dokku
