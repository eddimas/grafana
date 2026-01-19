# Grafana Dashboards - Git-based Provisioning

This directory contains Grafana dashboards managed through git-based provisioning.

## 📁 Directory Structure

```
dashboards/
├── application/          # Application-specific dashboards
│   ├── immich-application.json    # Immich app monitoring
│   └── redis-cache.json          # Redis cache performance
├── infrastructure/      # Infrastructure monitoring
│   ├── cluster-stats.json        # Kubernetes cluster overview
│   ├── kubernetes-cluster-overview.json  # Main cluster dashboard
│   ├── pvc-storage.json          # Storage monitoring
│   └── loki-logs.json           # Log aggregation (if available)
├── business/            # Business logic monitoring
│   ├── kong-api-gateway.json     # API Gateway monitoring
│   └── kong-api-analytics.json   # API Analytics (if available)
├── provisioning/        # Grafana provisioning config
│   └── dashboards.yml            # Dashboard provider configuration
└── README.md           # This file
```

## 🔄 How It Works

1. **Git Sync**: A sidecar container (`git-sync`) pulls this repository every 60 seconds
2. **Auto-provisioning**: Grafana automatically loads dashboards from the git repository
3. **Folder Organization**: Dashboards are organized into folders in Grafana UI:
   - **Applications**: Immich app, Redis cache monitoring
   - **Infrastructure**: Kubernetes cluster, storage, logging
   - **Business**: Kong API gateway and analytics
4. **Real-time Updates**: Changes pushed to git are automatically reflected in Grafana

## 🛠️ Dashboard Management

### Adding New Dashboards
1. Create/export dashboard JSON from Grafana UI
2. Place in appropriate category folder (`application/`, `infrastructure/`, or `business/`)
3. Commit and push to git
4. Dashboard appears in Grafana within 60 seconds

### Updating Existing Dashboards
1. Modify the JSON file directly or export from Grafana UI
2. Commit and push changes
3. Grafana will reload the updated dashboard automatically

### Dashboard Categories

- **Applications**: App-specific monitoring (Immich, Redis, etc.)
- **Infrastructure**: Cluster, storage, logging infrastructure  
- **Business**: API gateways, business logic monitoring

## ⚙️ Configuration

The provisioning is configured in:
- `/etc/grafana/provisioning/dashboards/dashboard-provisioning.yml`
- Git sync configured in deployment with 60-second intervals
- Repository: `https://github.com/eddimas/k8s.git`
- Branch: `master`
- Path: `dashboards/`

## 🚀 Benefits

- ✅ **Version Control**: Full dashboard history and collaboration
- ✅ **Automated Deployment**: No manual dashboard imports
- ✅ **Backup**: Dashboards stored safely in git
- ✅ **Consistency**: Same dashboards across environments
- ✅ **Easy Migration**: Simple git clone for new environments

## 📊 Current Dashboards

### Applications
- **Immich Application**: Complete monitoring for photo management app
- **Redis Cache**: Cache performance and efficiency metrics

### Infrastructure  
- **Kubernetes Cluster Overview**: Main cluster monitoring dashboard
- **Cluster Stats**: Additional cluster statistics and metrics
- **PVC Storage**: Persistent volume monitoring and growth tracking

### Business
- **Kong API Gateway**: API gateway performance and statistics

## 🔄 Migration from ConfigMaps

This setup replaces the previous ConfigMap-based dashboard management with git-based provisioning:

**Before**: Dashboards stored in individual ConfigMaps
**After**: Dashboards in git repository with automated sync

Benefits of migration:
- Better version control and change tracking
- Easier collaboration and dashboard sharing
- Automated backup through git history
- Simplified deployment across environments