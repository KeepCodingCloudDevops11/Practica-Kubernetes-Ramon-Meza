# Practica-Kubernetes-Ramon-Meza

Despliegue de una Aplicación en Kubernetes con Base de Datos utilizando Helm.
Esta práctica ofrece un enfoque integral para desplegar una aplicación escalable, segura y fácil de gestionar en un entorno Kubernetes, con una base de datos persistente y monitoreo en tiempo real para asegurar su rendimiento óptimo.




# Despliegue de WordPress y MySQL en Kubernetes usando Helm

## Índice
1. [Requisitos Previos](#requisitos-previos)
2. [Instalación de Helm en Minikube](#instalación-de-helm-en-minikube)
3. [Crear Namespace en Minikube](#crear-namespace-en-minikube)
4. [Estructura de Directorios](#estructura-de-directorios)
5. [Despliegue de WordPress y MySQL](#despliegue-de-wordpress-y-mysql)
6. [Verificación del Despliegue](#verificación-del-despliegue)
7. [Acceso a WordPress desde el Navegador](#acceso-a-wordpress-desde-el-navegador)



## Requisitos Previos
Antes de comenzar, asegúrate de tener los siguientes requisitos previos instalados en tu sistema:

1. **Minikube**: Para crear y gestionar el clúster de Kubernetes localmente.
2. **Helm**: Para gestionar los charts de Kubernetes de manera eficiente.
3. **kubectl**: Para interactuar con el clúster de Kubernetes.

Si no tienes estas herramientas, puedes seguir las instrucciones de instalación:

- [Instalar Minikube](https://minikube.sigs.k8s.io/docs/)
- [Instalar Helm](https://helm.sh/docs/intro/install/)
- [Instalar kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)


## Instalación de Helm en Minikube
A continuación, te proporcionamos los pasos para instalar Helm en tu clúster de Minikube:

1. **Inicia Minikube**: Si aún no has iniciado Minikube, puedes hacerlo con el siguiente comando:
    ```bash
    minikube start
    ```
2. **Instalar Helm**: Descarga e instala Helm desde su sitio oficial. Si ya tienes Helm instalado, puedes saltar este paso.
    ```bash
    curl https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz -o helm.tar.gz
    tar -zxvf helm.tar.gz
    sudo mv linux-amd64/helm /usr/local/bin/helm
    ```
    
3. **Inicializa Helm en Minikube**: Ejecuta el siguiente comando para asegurarte de que Helm esté conectado a tu clúster de Minikube:
    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
    ```


## Crear Namespace en Minikube
Para organizar los recursos en tu clúster de Kubernetes, vamos a crear un namespace llamado `mi-practica-keepcoding`:

1. **Crea el namespace** con el siguiente comando:
    ```bash
    kubectl create namespace mi-practica-keepcoding
    ```

Este namespace se usará para desplegar tanto WordPress como MySQL.


## Estructura de Directorios
La siguiente es la estructura de directorios para tu proyecto `practica-ramon-keepcoding`. Esta estructura contiene los archivos y configuraciones necesarias para el despliegue de WordPress y MySQL utilizando Helm.

```bash
practica-ramon-keepcoding/
├── charts/
├── test/
│   └── test-connection
├── templates/
│   ├── deployment.yaml
│   ├── deployment-mi-app-practica.yaml
│   ├── deployment-mysql.yaml
│   ├── hpa-mi-app-practica.yaml
│   ├── ingress.yaml
│   ├── mi-app-practica-pvc.yaml
│   ├── mysql-pvc.yaml
│   ├── mysql-secret.yaml
│   ├── mysql-service.yaml
│   ├── service-mi-app-practica.yaml
│   ├── wordpress-deployment.yaml
│   ├── wordpress-servicemonitor.yaml
├── stress-pod.yaml
├── NOTES.txt
├── helpers.tpl
├── values.yaml
├── Chart.yaml
└── .helmignore

 ```

## Despliegue de WordPress y MySQL
Con los directorios y archivos ya preparados, ahora puedes desplegar WordPress y MySQL usando Helm.

### Instalación Inicial
Para instalar WordPress y MySQL en tu clúster de Minikube, ejecuta el siguiente comando:

```bash
helm install wordpress bitnami/wordpress \
  --namespace mi-practica-keepcoding \
  --set wordpressPassword=adminpassword,primaryDomain=localhost,mysql.auth.rootPassword=rootpassword,mysql.auth.database=wordpressdb,persistence.enabled=true,persistence.size=8Gi
```

### Instalación personalizada
Si necesitas realizar cambios en la configuración de la instalación, como modificar valores o agregar nuevas configuraciones, puedes usar el comando `helm upgrade` para actualizar la instalación.

1. **Instalación inicial**: Si aún no has desplegado la aplicación en Kubernetes, usa `helm install` para desplegar el chart por primera vez:
    ```bash
    helm install mi-app-practica ./practica-ramon-keepcoding --namespace mi-practica-keepcoding
    ```
2. **Actualización posterior**: Si necesitas cambiar algún valor o configuración (por ejemplo, la base de datos o la versión de WordPress), modifica el archivo `values.yaml` y luego ejecuta `helm upgrade`:
    ```bash
    helm upgrade mi-app-practica ./practica-ramon-keepcoding --namespace mi-practica-keepcoding
    ```

---

## Verificación del Despliegue
Una vez que hayas desplegado WordPress y MySQL, verifica que todo esté funcionando correctamente usando los siguientes comandos:

1. **Verifica los pods**:
    ```bash
    kubectl get pods --namespace mi-practica-keepcoding
    ```

2. **Verifica los servicios**:
    ```bash
    kubectl get svc --namespace mi-practica-keepcoding
    ```

3. **Verifica los volúmenes persistentes**:
    ```bash
    kubectl get pvc --namespace mi-practica-keepcoding
    ```

---
![verificaciones](verificaciones.png)
## Acceso a WordPress desde el Navegador
Existen dos formas de acceder a la interfaz de WordPress desplegada en Kubernetes.

### 1. Acceder usando `minikube service`
El siguiente comando abrirá automáticamente la interfaz web de WordPress en tu navegador:

```bash
minikube service wordpress --namespace mi-practica-keepcoding
```

Este comando redirige el tráfico desde Minikube hacia tu navegador, permitiéndote acceder a WordPress de manera directa.

### 2. Acceder usando `kubectl port-forward`
Alternativamente, puedes utilizar port forwarding para redirigir el tráfico desde tu máquina local al servicio de WordPress en Kubernetes:

```bash
kubectl port-forward svc/wordpress 8080:80 --namespace mi-practica-keepcoding
```

Después de ejecutar este comando, abre tu navegador y accede a `http://localhost:8080` para acceder a la interfaz de usuario de WordPress y realizar la configuración inicial.

---

## Notas Finales
- **Persistencia de Datos**: La configuración de persistencia de datos para WordPress y MySQL está habilitada, lo que asegura que los datos no se perderán al reiniciar los pods.
- **Escalabilidad**: Los despliegues de WordPress y MySQL son escalables, lo que significa que puedes ajustar la cantidad de réplicas de los pods según sea necesario.
- **Seguridad**: Asegúrate de modificar las contraseñas predeterminadas antes de utilizar la aplicación en producción.



