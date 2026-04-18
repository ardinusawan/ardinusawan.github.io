architecture-overview.png: mermaid-diagrams/architecture.mmd
docker-architecture.png: mermaid-diagrams/docker-architecture.mmd
performance-chart.png: mermaid-diagrams/performance.mmd
status-dashboard.png: mermaid-diagrams/status-dashboard.mmd

# Generate PNG from Mermaid
%.png: %.mmd
	mmdc -i $< -o $@

.PHONY: all
all: architecture-overview.png docker-architecture.png performance-chart.png status-dashboard.png
