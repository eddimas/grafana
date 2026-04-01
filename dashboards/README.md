# Grafana Dashboards - Git-based Provisioning

This directory contains Grafana dashboards managed through git-based provisioning.

## 📁 Directory Structure

```
dashboards/
├── application/          # Application-specific dashboards
│   ├── immich-application.json
│   └── redis-cache.json
├── infrastructure/      # Infrastructure monitoring
│   ├── cluster-stats.json
│   ├── adguard-home-overview.json
│   ├── grafana-observability.json
│   ├── kubernetes-cluster-overview.json
│   ├── physical-infrastructure-overview.json
│   └── pvc-storage.json
├── business/            # Business and usage dashboards
│   ├── .gitkeep
│   └── business-app-usage-overview.json
├── provisioning/        # Grafana provisioning config
│   └── dashboards.yml            # Dashboard provider configuration
└── README.md           # This file
```

## 🔄 How It Works

1. **Git Sync**: A sidecar container (`git-sync`) pulls this repository every 60 seconds
2. **Auto-provisioning**: Grafana automatically loads dashboards from the git repository
3. **Folder Organization**: Dashboards are organized into folders in Grafana UI:
   - **Applications**: App-level dashboards such as Immich and Redis
   - **Infrastructure**: Kubernetes, Grafana, storage, and physical host monitoring
   - **Business**: Usage-oriented dashboards such as business app traffic and adoption
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
- **Business**: Usage and business-facing dashboards

## ⚙️ Configuration

The provisioning is configured in:
- `/etc/grafana/provisioning/dashboards/dashboard-provisioning.yml`
- Git sync configured in deployment with 60-second intervals
- Repository: `https://github.com/eddimas/grafana.git`
- Branch: `main`
- Path: `dashboards/`

In the running Grafana pod, `git-sync` clones the repository under:

- `/var/lib/grafana/git-dashboards/grafana.git/dashboards/application`
- `/var/lib/grafana/git-dashboards/grafana.git/dashboards/infrastructure`
- `/var/lib/grafana/git-dashboards/grafana.git/dashboards/business`

## ✅ Local Validation

Run this before pushing changes:

```bash
./scripts/validate_dashboards.sh
```

The validator checks:
- JSON syntax
- Provisioning-ready dashboard shape
- Placeholder datasource UIDs
- Missing dashboard directories referenced by provisioning

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
- **AdGuard Home Overview**: DNS filtering health, query volume, blocked traffic, clients, and upstreams
- **Grafana Observability**: Grafana internal metrics, API latency, and pod health
- **Physical Infrastructure Overview**: Raspberry Pi and Minisforum CPU, memory, disk, network, load, uptime, and temperature
- **PVC Storage**: Persistent volume monitoring and growth tracking

### Business
- **Business App Usage Overview**: App traffic, Immich usage, and business-facing activity trends

## 🔄 Migration from ConfigMaps

This setup replaces the previous ConfigMap-based dashboard management with git-based provisioning:

**Before**: Dashboards stored in individual ConfigMaps
**After**: Dashboards in git repository with automated sync

Benefits of migration:
- Better version control and change tracking
- Easier collaboration and dashboard sharing
- Automated backup through git history
- Simplified deployment across environments
