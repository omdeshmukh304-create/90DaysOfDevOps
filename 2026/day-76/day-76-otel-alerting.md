# Day 76 - OpenTelemetry and Alerting

## Objective

The objective of this lab was to understand distributed tracing using OpenTelemetry, implement alerting using Prometheus and Grafana, and build a complete observability stack covering Metrics, Logs, and Traces.

---

# OpenTelemetry Architecture

OpenTelemetry Collector acts as a telemetry pipeline between applications and observability backends.

The collector consists of three main components:

## 1. Receivers

Receivers collect telemetry data from applications.

Examples:

* OTLP gRPC Receiver (Port 4317)
* OTLP HTTP Receiver (Port 4318)

Purpose:

* Receive traces, metrics, and logs from applications.

---

## 2. Processors

Processors transform or optimize telemetry before exporting.

Example:

* Batch Processor

Purpose:

* Group telemetry into batches.
* Improve efficiency.
* Reduce exporter load.

---

## 3. Exporters

Exporters send telemetry data to a destination.

Examples:

* Debug Exporter
* Jaeger
* Tempo
* Prometheus

Purpose:

* Deliver collected telemetry to storage or visualization systems.

---

# OpenTelemetry Data Flow

Application / curl Request
|
v
OTLP Receiver (4317 / 4318)
|
v
Batch Processor
|
v
Debug Exporter
|
v
Collector Logs

---

# OTEL Collector Configuration

## otel-collector-config.yml

```yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:

exporters:
  debug:

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [debug]

    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [debug]
```

### Configuration Explanation

#### Receivers

```yaml
receivers:
  otlp:
```

Receives telemetry through OpenTelemetry Protocol (OTLP).

---

#### Protocols

```yaml
protocols:
  grpc:
  http:
```

Supports:

* gRPC (4317)
* HTTP (4318)

---

#### Processors

```yaml
processors:
  batch:
```

Groups telemetry before export.

Benefits:

* Reduced network overhead
* Improved performance

---

#### Exporters

```yaml
exporters:
  debug:
```

Prints telemetry data into collector logs.

Useful for:

* Learning
* Troubleshooting
* Validation

---

#### Pipelines

```yaml
pipelines:
```

Defines the flow:

Receiver → Processor → Exporter

---

# Trace Verification

To verify traces:

```bash
docker logs otel-collector
```

Expected result:

* Trace IDs visible
* Span IDs visible
* Resource attributes visible

### Screenshot

Insert Screenshot:
**Trace visible in OTEL Collector Debug Logs**

---

# Prometheus Alert Rules

## alert-rules.yml

```yaml
groups:
  - name: system-alerts
    rules:

      - alert: HighCPUUsage
        expr: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 2m

      - alert: HighMemoryUsage
        expr: (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100 > 85
        for: 2m

      - alert: ContainerDown
        expr: absent(container_last_seen{name="notes-app"})
        for: 1m

      - alert: TargetDown
        expr: up == 0
        for: 1m

      - alert: HighDiskUsage
        expr: (1 - node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100 > 90
        for: 5m
```

---

# Alert Explanations

## HighCPUUsage

Triggers when CPU usage exceeds 80% for more than 2 minutes.

Purpose:

* Detect CPU bottlenecks.

---

## HighMemoryUsage

Triggers when memory usage exceeds 85%.

Purpose:

* Prevent Out Of Memory issues.

---

## ContainerDown

Uses:

```promql
absent(container_last_seen{name="notes-app"})
```

Triggers when notes-app disappears.

Purpose:

* Detect stopped containers.

---

## TargetDown

Uses:

```promql
up == 0
```

Triggers when a Prometheus target becomes unreachable.

Purpose:

* Detect monitoring failures.

---

## HighDiskUsage

Triggers when root filesystem usage exceeds 90%.

Purpose:

* Prevent disk exhaustion.

---

# Grafana Alerting

## Contact Point

Name:

```text
DevOps Team
```

Integration:

```text
Email
```

Purpose:

* Send notifications when alerts fire.

---

## Custom Alert Rule

Rule Name:

```text
High Container Memory
```

Condition:

```text
IS ABOVE 100 MB
```

Label:

```text
severity=warning
```

Purpose:

* Detect excessive container memory consumption.

### Screenshot

Insert Screenshot:
**Grafana Alert Rule**

---

# Prometheus Alert Verification

Alert states:

* Inactive
* Pending
* Firing

Testing performed:

```bash
docker compose stop notes-app
```

Result:

```text
ContainerDown -> FIRING
```

### Screenshot

Insert Screenshot:
**Prometheus Alerts Page Showing Alert States**

---

# Questions and Answers

## Q1. What is the role of Receivers, Processors, and Exporters in OpenTelemetry?

### Receivers

Collect telemetry data from applications.

### Processors

Transform, enrich, batch, or filter telemetry.

### Exporters

Send telemetry data to external systems.

---

## Q2. What is the difference between Prometheus Alerts and Grafana Alerts?

### Prometheus Alerts

* Evaluated by Prometheus.
* Defined in alert-rules.yml.
* Infrastructure focused.
* Usually integrated with Alertmanager.

Examples:

* CPU High
* Memory High
* Service Down

### Grafana Alerts

* Evaluated by Grafana.
* Dashboard based.
* Easier notification management.
* Supports Email, Slack, Teams, PagerDuty.

Examples:

* Dashboard Threshold Alerts
* Business Metric Alerts

### When to use each?

Use Prometheus Alerts:

* Infrastructure monitoring
* Service health monitoring

Use Grafana Alerts:

* Notification workflows
* Dashboard-based alerting

---

## Q3. What is the purpose of the 'for' field in Prometheus alerts?

Example:

```yaml
for: 2m
```

The condition must remain true for 2 minutes before the alert enters FIRING state.

Benefits:

* Prevents false alerts
* Avoids alert flapping

---

## Q4. What does absent() do in PromQL?

Example:

```promql
absent(container_last_seen{name="notes-app"})
```

Triggers when a metric disappears completely.

Useful for:

* Dead containers
* Missing services
* Monitoring failures

---

## Q5. What are the Three Pillars of Observability?

### Metrics

Numerical measurements over time.

Examples:

* CPU Usage
* Memory Usage
* Request Rate

### Logs

Timestamped records of events.

Examples:

* Application Logs
* Container Logs
* Error Logs

### Traces

Track request flow across systems.

Examples:

* Request Latency
* Service Dependencies
* Distributed Transactions

---

# Full Architecture Diagram

## Metrics Pipeline

Node Exporter ----

cAdvisor -----------> Prometheus ---> Grafana Dashboards
/
OTEL Collector ----/

Prometheus ---> Alert Rules
Grafana ---> Notifications

---

## Logs Pipeline

Docker Containers
|
v
Promtail
|
v
Loki
|
v
Grafana Explore

---

## Traces Pipeline

Application / curl
|
v
OTEL Collector
|
v
Debug Exporter

---

# Services Running

| Service        | Port           | Purpose                      |
| -------------- | -------------- | ---------------------------- |
| Prometheus     | 9090           | Metrics storage and querying |
| Node Exporter  | 9100           | Host metrics                 |
| cAdvisor       | 8080           | Container metrics            |
| Grafana        | 3000           | Dashboards and alerting      |
| Loki           | 3100           | Log storage                  |
| Promtail       | 9080           | Log collection               |
| OTEL Collector | 4317/4318/8889 | Telemetry collection         |
| Notes App      | 8000           | Sample application           |

---

# Conclusion

In this lab, I successfully built a complete observability stack using Prometheus, Grafana, Loki, Promtail, Node Exporter, cAdvisor, and OpenTelemetry Collector.

I implemented:

* Metrics Monitoring
* Log Aggregation
* Distributed Tracing
* Prometheus Alerting
* Grafana Alerting

This setup demonstrates all three pillars of observability and provides complete visibility into infrastructure and application health.
