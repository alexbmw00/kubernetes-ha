# Kubernetes - Alta Disponibilidade

Este Vagranfile inicia um cluster multi-master.

# Instalando

```
vagrant up
```

# Testando

Para testar o cluster, entre em um dos três masters e execute o comando:

```
vagrant ssh master1
sudo su -
kubectl get nodes
```
