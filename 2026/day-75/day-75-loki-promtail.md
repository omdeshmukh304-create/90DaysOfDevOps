# Day 75 - Log Management with Loki and Promtail

## Objective

Today I implemented the second pillar of observability: **Logs**.

The goal was to set up:

* Loki as the log storage backend
* Promtail as the log collection agent
* Grafana Loki datasource
* LogQL queries in Grafana Explore
* Metrics and logs correlation in Grafana

---

# Task 1: Understand the Logging Pipeline

## Question

Why does Loki only index labels instead of full text? What is the trade-off?

## Architecture Diagram

```text
+-------------------+
| Docker Containers |
+-------------------+
          |
          | JSON Logs
          v
+-------------------+
|     Promtail      |
+-------------------+
          |
          | Push Logs
          v
+-------------------+
|       Loki        |
+-------------------+
          |
          | LogQL Queries
          v
+-------------------+
|      Grafana      |
+-------------------+
          |
          v
        User
```

## Answer

Loki only indexes labels instead of full log text to reduce storage costs and resource consumption. This makes Loki significantly lighter and easier to operate than Elasticsearch.

### Advantages

* Lower CPU usage
* Lower memory consumption
* Lower storage requirements
* Easier maintenance
* Faster deployment

### Trade-Off

* Full-text search is less powerful than Elasticsearch
* Complex searches can be slower
* Best suited for label-based log exploration

---

# Task 2: Add Loki to the Stack

## Question

Create the Loki configuration and run Loki as a log storage backend.

## loki-config.yml

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

common:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory
  replication_factor: 1
  path_prefix: /loki

schema_config:
  configs:
    - from: 2020-10-24
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

storage_config:
  filesystem:
    directory: /loki/chunks
```

## Explanation

* auth_enabled: false → disables authentication
* tsdb → Loki time-series storage engine
* filesystem → stores logs locally
* replication_factor: 1 → single-node deployment
* directory: /loki/chunks → stores log chunks

---

# Task 3: Add Promtail to Collect Container Logs

## Question

Configure Promtail to collect Docker logs and send them to Loki.

## promtail-config.yml

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker
    static_configs:
      - targets:
          - localhost
        labels:
          job: docker
          __path__: /var/lib/docker/containers/*/*-json.log

    pipeline_stages:
      - docker: {}
```

## Explanation

### positions

Tracks already-read log lines.

### clients

Defines Loki endpoint.

### **path**

Reads Docker JSON log files.

### docker stage

Parses Docker log format and extracts:

* timestamp
* stream
* message

---

# Updated docker-compose.yml

```yaml
services:
  prometheus:
    image: prom/prometheus:latest

  grafana:
    image: grafana/grafana-enterprise:latest

  notes-app:
    image: trainwithshubham/notes-app:latest

  node-exporter:
    image: prom/node-exporter:latest

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest

  loki:
    image: grafana/loki:latest

  promtail:
    image: grafana/promtail:latest

volumes:
  prometheus_data:
  grafana_data:
  loki_data:
```

---

# Task 4: Add Loki as a Grafana Datasource

## Question

Add Loki datasource in Grafana.

## Configuration

Datasource URL:

```text
http://loki:3100
```

Result:

* Prometheus datasource available
* Loki datasource available

---

# Task 5: Query Logs with LogQL

## Question

Run LogQL queries and explain the results.

## Query 1

```logql
{job="docker"}
```

### Result

Returned all Docker container logs.

---

## Query 2

```logql
{job="docker"} |= "error"
```

### Result

Returned only log lines containing the word "error".

---

## Query 3

```logql
count_over_time({job="docker"}[5m])
```

### Result

Counted log entries generated during the last 5 minutes.

---

## Query 4

```logql
rate({job="docker"}[5m])
```

### Result

Displayed logs per second.

---

## Query 5

```logql
topk(5, sum by (container_name) (rate({job="docker"}[5m])))
```

### Result

Displayed containers generating the highest log volume.

---

## Exercise

### Error logs from notes-app

```logql
{container_name="notes-app"} |= "error"
```

### Count error logs per minute

```logql
count_over_time({container_name="notes-app"} |= "error" [1m])
```

---

# Screenshot: Grafana Explore Showing Logs from Loki

Insert screenshot here:

```text
[PASTE SCREENSHOT - Loki Explore Logs]
```

---

# Task 6: Correlate Metrics and Logs in Grafana

## Question

How does having metrics and logs in the same tool (Grafana) help during incident response compared to checking separate systems?

## Answer

Having metrics and logs in the same platform significantly improves incident response.

Metrics show what happened:

* CPU spikes
* Memory pressure
* High latency
* Increased request rates

Logs explain why it happened:

* Application errors
* Failed database connections
* Service crashes
* Configuration issues

Using Grafana for both metrics and logs reduces context switching, speeds up root cause analysis, and allows engineers to investigate incidents much faster.

---

# Metrics and Logs Correlation

## Prometheus Query

```promql
rate(container_cpu_usage_seconds_total[5m])
```

## Loki Query

```logql
{job="docker"}
```

Result:

Metrics and logs were viewed side-by-side using Grafana Explore Split View.

---

# Screenshot: Metrics and Logs Side-by-Side

Insert screenshot here:

```text
[PASTE SCREENSHOT - Split View]
```

---

# Loki vs ELK Stack

| Feature                | Loki        | ELK Stack |
| ---------------------- | ----------- | --------- |
| Indexing               | Labels only | Full text |
| Storage Cost           | Low         | High      |
| Memory Usage           | Low         | High      |
| CPU Usage              | Low         | High      |
| Deployment Complexity  | Easy        | Complex   |
| Full-Text Search       | Limited     | Excellent |
| Kubernetes Integration | Excellent   | Good      |
| Learning Environment   | Ideal       | Heavy     |

## When to Use Loki

* Kubernetes environments
* Prometheus/Grafana ecosystem
* Cost-sensitive deployments
* Lightweight observability stacks

## When to Use ELK

* Advanced log analytics
* Full-text search requirements
* Compliance and audit workloads
* Large centralized logging platforms

---

# Conclusion

Successfully implemented centralized log management using Loki and Promtail, integrated logs into Grafana, learned LogQL, and correlated metrics with logs for effective observability and incident response.
