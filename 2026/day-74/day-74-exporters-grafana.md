# Day 74 - Node Exporter, cAdvisor, and Grafana Dashboards

## Objective

Set up host and container monitoring using Prometheus exporters and visualize metrics using Grafana dashboards.

---

# Challenge Tasks

## Task 1: Add Node Exporter for Host Metrics

### Objective

Monitor host-level metrics such as:

* CPU Usage
* Memory Usage
* Disk Usage
* Network Usage

### Result

* Node Exporter installed and running on port 9100.
* Prometheus successfully scraping Node Exporter metrics.
* Verified metrics using PromQL queries.

---

## Task 2: Add cAdvisor for Container Metrics

### Objective

Monitor Docker container resource usage.

### Result

* cAdvisor installed and running on port 8080.
* Prometheus successfully scraping container metrics.
* Verified container CPU and memory metrics.

---

## Task 3: Set Up Grafana

### Objective

Visualize Prometheus metrics using Grafana dashboards.

### Result

* Grafana installed on port 3000.
* Prometheus configured as datasource.
* Successfully queried Prometheus metrics from Grafana.

---

## Task 4: Build Your First Dashboard

### Dashboard Name

DevOps Observability Overview

### Panels Created

#### Panel 1 - CPU Usage %

Visualization: Gauge

#### Panel 2 - Memory Usage %

Visualization: Gauge

#### Panel 3 - Container CPU Usage

Visualization: Time Series

#### Panel 4 - Container Memory Usage

Visualization: Bar Chart

#### Panel 5 - Disk Usage %

Visualization: Stat

---

## Task 5: Auto-Provision Datasources with YAML

### Objective

Automatically create Grafana datasources without manual UI configuration.

### Datasource Configuration

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
```

### Benefits

* Infrastructure as Code (IaC)
* Repeatable deployments
* No manual setup required
* Version controlled configuration
* Useful for CI/CD pipelines

---

## Task 6: Import Community Dashboards

### Imported Dashboard 1

Dashboard ID: 1860

Name: Node Exporter Full

Status: Working Successfully

### Imported Dashboard 2

Dashboard ID: 193

Name: Docker Monitoring via cAdvisor

Status: Imported Successfully. Some panels showed no data because the dashboard expects older cAdvisor metric labels not available in the current version.

---

# Updated docker-compose.yml

```yaml
# Paste your complete docker-compose.yml here
```

---

# Updated prometheus.yml

```yaml
# Paste your complete prometheus.yml here
```

---

# Difference Between Node Exporter and cAdvisor

| Node Exporter                      | cAdvisor                               |
| ---------------------------------- | -------------------------------------- |
| Monitors host machine              | Monitors Docker containers             |
| CPU, Memory, Disk, Network metrics | Container CPU, Memory, Network metrics |
| Host-level monitoring              | Container-level monitoring             |
| Runs on port 9100                  | Runs on port 8080                      |

### When to Use Node Exporter

Use Node Exporter when monitoring:

* Server CPU usage
* Memory usage
* Disk usage
* Network usage

### When to Use cAdvisor

Use cAdvisor when monitoring:

* Container CPU usage
* Container memory usage
* Container network traffic
* Container resource consumption

---

# PromQL Queries

## CPU Usage %

```promql
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

## Memory Usage %

```promql
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```

## Disk Usage %

```promql
(1 - node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100
```

## Container CPU Usage

```promql
rate(container_cpu_usage_seconds_total[5m]) * 100
```

## Container Memory Usage

```promql
container_memory_usage_bytes / 1024 / 1024
```

---

# Screenshots

## Prometheus Targets Page

(Add Screenshot)

## Custom Grafana Dashboard

(Add Screenshot)

## Node Exporter Full Dashboard (ID 1860)

(Add Screenshot)

---

# How Datasource Provisioning Works

1. Create provisioning directory.
2. Create datasources.yml file.
3. Mount provisioning directory inside Grafana container.
4. Restart Grafana.
5. Grafana automatically loads datasource configuration during startup.

Workflow:

Grafana Start
↓
Read datasources.yml
↓
Create Prometheus Datasource
↓
Datasource Available Automatically

---

# Outcome

Successfully configured:

* Prometheus
* Node Exporter
* cAdvisor
* Grafana
* Grafana Datasource Provisioning

Successfully created custom and community dashboards for monitoring host and container metrics.
