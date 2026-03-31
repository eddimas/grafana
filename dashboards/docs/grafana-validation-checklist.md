# Grafana Dashboard Validation Checklist

## 1. Datasources

- Abre `Connections > Data sources` y confirma que `Prometheus` esté en estado `Healthy`.
- Si usas Redis exporter, confirma que las métricas `redis_*` existen en Prometheus con `Explore`.
- Si el dashboard usa un UID explícito, verifica que coincida con el datasource real.
- En `Explore`, prueba estas consultas base y valida que devuelvan series:
  - `up`
  - `kube_pod_status_phase{namespace="immich-dev"}`
  - `kube_deployment_status_replicas{namespace="immich-dev"}`
  - `kube_service_info{namespace="immich-dev"}`
  - `kube_persistentvolumeclaim_status_phase{namespace="immich-dev"}`

## 2. Provisioning

- En `Dashboards`, confirma que el dashboard `Immich Application Dashboard` aparece en la carpeta `Applications`.
- Verifica que no existan dashboards duplicados con títulos viejos.
- Si hiciste push reciente, espera el intervalo de sync y recarga Grafana.
- Revisa logs de Grafana si el dashboard no aparece:
  - errores de JSON
  - errores de provisioning
  - errores de datasource UID

## 3. Paneles Del Dashboard Immich

- `Immich Running Pods`: debe mostrar un número mayor o igual a 0 y cambiar si escalas pods.
- `Immich Deployments`: debe coincidir con la cantidad de deployments en `immich-dev`.
- `Immich Services`: debe coincidir con los services del namespace.
- `Immich PVCs Bound`: debe coincidir con los PVCs en estado `Bound`.
- `Running Pods by Immich Pod`: debe listar pods reales de Immich, no pods de otras apps.
- `Immich Deployment Replicas Status`: revisa que Desired y Available tengan sentido por deployment.
- `Immich Restart Count (Last Hour)`: valida que no haya reinicios inesperados o que coincida con eventos recientes.
- `Immich Service Status`: confirma que sólo aparezcan services de `immich-dev`.
- `Immich Pod Memory Limits`: revisa que los límites por pod tengan unidad correcta y no estén vacíos si defines limits.
- `Immich Pod CPU Limits`: revisa que los límites por pod tengan unidad correcta y no estén vacíos si defines limits.
- `Immich ConfigMaps & Secrets`: valida que el conteo sea razonable para el namespace.

## 4. Validación Cruzada En Kubernetes

- Ejecuta `kubectl get pods -n immich-dev`.
- Ejecuta `kubectl get deploy -n immich-dev`.
- Ejecuta `kubectl get svc -n immich-dev`.
- Ejecuta `kubectl get pvc -n immich-dev`.
- Compara esos conteos con los panels tipo `stat` y `table`.

## 5. Señales De Problema

- Panel vacío: la métrica no existe, el label `namespace` no coincide o el datasource está mal.
- Panel con datos de otra app: el query aún filtra mal por namespace o pod.
- Valores duplicados: puede haber series repetidas por labels extra; revisa si necesitas `sum by (...)`.
- Todo en cero: valida scraping, namespace exacto y rango de tiempo del dashboard.

## 6. Comprobaciones Finales

- Cambia el rango de tiempo de `Last 1 hour` a `Last 24 hours` y confirma que los gráficos sigan teniendo datos.
- Abre `Inspect > Query` en 2 o 3 paneles y verifica el PromQL ejecutado.
- Guarda evidencia de los paneles correctos después de validar para tener una referencia base.
