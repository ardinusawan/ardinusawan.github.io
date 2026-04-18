# DewaDownload Architecture Illustrations

This directory contains diagrams and visualizations for the blog post.

## Image List

### 1. architecture-overview.png
Shows the complete system architecture:
- User request flow
- Cloudflare CDN
- 3 subdomains (api, api2, api3)
- Cloudflare Tunnels
- Nginx reverse proxies
- Fastify backends
- Redis caching
- yt-dlp/FFmpeg processing

### 2. docker-architecture.png
Docker Compose service architecture:
- dewadownload container (Fastify backend)
- redis container (Caching)
- nginx container (Reverse proxy)
- cloudflared container (Tunnel)
- Network: dewadownload-net (bridge)
- Volume mounts for logs and configs

### 3. performance-chart.png
Performance comparison bar chart:
- Before: Info TTFB 9.4s → After: 1.6s (82% faster)
- Before: Download TTFB 4.6s → After: 1.8s (61% faster)
- Before: Download Speed 185 KB/s → After: 800 KB/s (4x faster)
- Before: Concurrent 1024 → After: 8192 (8x increase)

### 4. status-dashboard.png
Backend status dashboard showing:
- 3 backend nodes with health status
- Response time metrics
- Performance ratings
- Auto-refresh indicator

## Creating the Images

For actual deployment, you can create these images using:
- Mermaid diagrams (exported as PNG)
- Draw.io / diagrams.net
- Figma
- Excalidraw
- Or any diagramming tool

### Mermaid Example for Architecture Overview

```mermaid
graph TD
    User[User Browser] -->|HTTPS| CDN[Cloudflare CDN]
    CDN -->|api.dewadownload.com| Tunnel1[Cloudflare Tunnel 1]
    CDN -->|api2.dewadownload.com| Tunnel2[Cloudflare Tunnel 2]
    CDN -->|api3.dewadownload.com| Tunnel3[Cloudflare Tunnel 3]
    
    Tunnel1 --> Nginx1[Nginx Proxy 1]
    Tunnel2 --> Nginx2[Nginx Proxy 2]
    Tunnel3 --> Nginx3[Nginx Proxy 3]
    
    Nginx1 --> Backend1[Fastify Backend 1]
    Nginx2 --> Backend2[Fastify Backend 2]
    Nginx3 --> Backend3[Fastify Backend 3]
    
    Backend1 --> Redis1[Redis Cache 1]
    Backend2 --> Redis2[Redis Cache 2]
    Backend3 --> Redis3[Redis Cache 3]
    
    Backend1 --> YTDLP1[yt-dlp/FFmpeg 1]
    Backend2 --> YTDLP2[yt-dlp/FFmpeg 2]
    Backend3 --> YTDLP3[yt-dlp/FFmpeg 3]
    
    YTDLP1 -->|Stream| Video[Video File]
    YTDLP2 -->|Stream| Video
    YTDLP3 -->|Stream| Video
```

### Mermaid Example for Docker Architecture

```mermaid
graph LR
    subgraph "Docker Network: dewadownload-net"
        Cloudflared[cloudflared<br/>Tunnel]
        Nginx[nginx<br/>Proxy]
        Backend[dewadownload<br/>Fastify]
        Redis[redis<br/>Cache]
    end
    
    Cloudflared -->|HTTP| Nginx
    Nginx -->|Proxy| Backend
    Backend -->|Cache| Redis
    
    Cloudflared -->|Volumes| Vols[/cloudflared/]
    Nginx -->|Volumes| Vols2[/nginx/]
    Backend -->|Volumes| Vols3[/backend/]
```

## Placeholder Images

For now, the blog post references these images. Replace them with actual PNG files before publishing.

Recommended image dimensions:
- Width: 1200px
- Height: 600-800px
- Format: PNG with transparency support
