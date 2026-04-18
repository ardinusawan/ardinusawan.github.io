---
author: ["I Dewa Putu Ardi Nusawan"]
title: "Tanpa Cloud, Tanpa Biaya: Bagaimana Saya Membangun Kekaisaran Pengunduh Video 3 Node"
date: 2024-04-19
description: "Dari git push ke CDN global: Men-deploy pengunduh video multi-node dengan 3 subdomain, Cloudflare tunnel, dan tanpa biaya cloud"
tags: ["deployment", "cloudflare", "docker", "git", "architecture", "video-downloader"]
thumbnail:
  image: "images/architecture.png"
  cover:
    image: "images/architecture.png"
    alt: "Arsitektur DewaDownload"
    caption: "Arsitektur multi-node dengan Cloudflare tunnel"
    relative: true
ShowToc: true
comments: true
draft: false
---

# Tanpa Cloud, Tanpa Biaya: Bagaimana Saya Membangun Kekaisaran Pengunduh Video 3 Node

DewaDownload bukan sekadar pengunduh video lain. Ini adalah bukti apa yang bisa kamu capai saat kamu menolak jebakan langganan cloud dan memeluk kekuatan edge computing.

Dengan **3 subdomain**, **tanpa tagihan cloud**, dan **alur kerja deployment git push**, proyek ini berjalan sepenuhnya di infrastruktur yang saya kendalikan. Berikut cara saya melakukannya.

## Apa itu DewaDownload?

DewaDownload adalah pengunduh video berkinerja tinggi dan mobile-first yang mendukung YouTube, TikTok, X (Twitter), dan Instagram. Tapi yang membuatnya spesial bukan hanya apa yang dilakukannya—tapi bagaimana cara berjalannya.

**Fitur Utama:**
- ⚡ **82% lebih cepat** pengambilan metadata video (9.4s → 1.6s)
- 🚀 **4x lebih cepat** kecepatan unduhan (185 KB/s → 800 KB/s)
- 🔄 **Arsitektur 3-node** dengan failover otomatis
- 💎 **Tanpa biaya cloud** - berjalan di infrastruktur self-hosted
- 📱 **PWA-enabled** dengan kemampuan offline

## Arsitektur: 3 Subdomain, Tanpa Kompromi

Ketika kamu mengakses DewaDownload, permintaanmu mengalir melalui sistem yang diatur dengan cermat:

```
User → Cloudflare CDN → Cloudflare Tunnel → Nginx → Fastify Backend → yt-dlp/FFmpeg
                                       ↓
                                    Redis Cache
```

### 3 Subdomain

**1. api.dewadownload.com** (Node Utama)
- Lokasi: Infrastruktur utama
- Sumber daya: 2 core CPU, 6GB RAM
- Tunnel ID: `8b2a69e6-64e9-4d35-82b5-1799ac85e16d`

**2. api2.dewadownload.com** (Node Sekunder)
- Lokasi: Infrastruktur sekunder
- Sumber daya: 2 core CPU, 2GB RAM
- Tunnel ID: `8b2a69e6-64e9-4d35-82b5-1799ac85e16d`

**3. api3.dewadownload.com** (Node Tersier)
- Lokasi: Infrastruktur tersier
- Sumber daya: 2 core CPU, 2GB RAM
- Tunnel ID: `95ae5e2d-f439-4e5f-8c59-b2c9c37ab932`

![Ikhtisar Arsitektur](images/architecture.png)

## Cara Kerja Deployment: Sihir Git Push

Keindahan setup ini? Deployment sesederhana `git push`. Berikut alur kerjanya:

### 1. Deployment Frontend (Cloudflare Pages)

```bash
# Build dan deploy ke Cloudflare Pages
npm run deploy
```

Ini memicu:
1. Vite membangun frontend React/TypeScript
2. Wrangler mengunggah ke Cloudflare Pages
3. Distribusi CDN global dalam hitungan detik

### 2. Deployment Backend (Docker + Git)

Untuk setiap node infrastruktur (infra, infra2, infra3):

```bash
# Pull perubahan terbaru
cd /path/to/dewadownload/infra
git pull origin main

# Rebuild dan restart layanan
docker compose up -d --build
```

Sihir terjadi melalui orkestrasi **docker-compose**:

![Arsitektur Docker Compose](images/docker-architecture.png)

Setiap direktori infrastruktur berisi:
- `docker-compose.yml` - Orkestrasi layanan
- `cloudflared/config.yml` - Konfigurasi tunnel
- `nginx/` - Konfigurasi reverse proxy
- `cloudflared/` - Kredensial tunnel Cloudflare

## Pendalaman: Komponen Infrastruktur

### Cloudflare Tunnel: Tidak Perlu Port Forwarding Lagi

Hari-hari membuka port dan mengekspos IP sudah berlalu. Cloudflare Tunnel membuat koneksi keluar yang terenkripsi:

```yaml
# infra/cloudflared/config.yml
ingress:
  - hostname: api.dewadownload.com
    service: http://nginx:80
  - service: http_status:404
```

**Manfaat:**
- 🔒 Tidak ada port terbuka
- 🌍 SSL/TLS otomatis
- 🚀 Perlindungan DDOS
- 📊 Analitik bawaan

### Nginx: Konduktor Lalu Lintas

Nginx duduk di antara Cloudflare Tunnel dan backend kami, menangani:
- Pembatasan laju (rate limiting)
- Perutean request
- Terminasi SSL
- Kompresi
- Logging

```nginx
# Dioptimalkan untuk streaming unduhan
location ~ ^/download {
    proxy_buffering off;
    proxy_cache off;
    proxy_read_timeout 600s;
    proxy_socket_keepalive on;
}
```

### Backend: Fastify + yt-dlp + FFmpeg

Backend adalah server Node.js/Fastify yang mengorkestrasi unduhan video:

```typescript
// Cepat + efisien
import fastify from 'fastify';
import ytDlp from 'yt-dlp-exec';

// Stream video langsung ke klien
app.get('/download', async (req, reply) => {
    const stream = ytDlp.execStream(url, options);
    reply.raw.writeHead(200, { 'Content-Type': 'video/mp4' });
    stream.pipe(reply.raw);
});
```

### Redis: Caching untuk Kecepatan

Redis menyimpan cache metadata video untuk menghindari panggilan API berulang:

```javascript
// Cache info video selama 24 jam
await redis.setex(`info:${videoId}`, 86400, JSON.stringify(metadata));
```

## Rahasia Performa: Bagaimana Bisa 4x Lebih Cepat

### Optimasi Backend

1. **Transcoding Cerdas**: Hanya transcode saat perlu
2. **Unduhan Paralel**: 4 koneksi bersamaan
3. **Optimasi Buffering**: 2MB highWaterMark
4. **Koneksi Pooling**: 100 koneksi keep-alive

### Optimasi Infrastruktur

1. **Multiplexing HTTP/2**: Throughput lebih baik
2. **Batas Sumber Daya**: Mencegah kill OOM
3. **Health Checks**: Pemulihan otomatis
4. **8192 Koneksi Bersamaan**: Peningkatan 8x

![Perbandingan Performa](images/performance.png)

## Alur Kerja Git

Berikut alur kerja deployment saya yang sebenarnya:

```bash
# 1. Buat perubahan secara lokal
vim src/components/VideoDownloader.tsx

# 2. Commit dan push
git add .
git commit -m "Optimalkan pelacakan progres unduhan"
git push origin main

# 3. Deploy frontend (otomatis)
npm run deploy

# 4. Deploy backend (manual untuk saat ini)
ssh user@server1
cd /opt/dewadownload/infra
git pull
docker compose up -d --build

# Ulangi untuk server2 dan server3
```

**Rencana masa depan:** Tambahkan GitHub Actions untuk mengotomatisasi deployment backend melalui SSH.

## Konfigurasi DNS: Perekatnya

Cloudflare DNS mengarahkan lalu lintas ke tunnel yang benar:

| Record | Tipe | Target | Tujuan |
|--------|------|--------|---------|
| api | CNAME | (tunnel) | Backend utama |
| api2 | CNAME | (tunnel) | Backend sekunder |
| api3 | CNAME | (tunnel) | Backend tersier |
| dewadownload.com | CNAME | (Cloudflare Pages) | Frontend |

## Monitoring & Health Checks

Setiap node menjalankan health check setiap 30 detik:

```bash
# Endpoint health check
curl http://localhost:3000/ping
# Response: pong
```

Frontend menampilkan status real-time di `/status.html`:

![Dashboard Status](images/status-dashboard.png)

## Ringkasan Tech Stack

### Frontend
- **Vite** - Tool build super cepat
- **React 19** - Framework UI
- **TypeScript** - Keamanan tipe
- **Tailwind CSS** - Styling
- **Cloudflare Pages** - Hosting & CDN

### Backend
- **Fastify** - Framework web
- **yt-dlp** - Pengunduh video
- **FFmpeg** - Pemrosesan media
- **Redis** - Caching
- **Docker** - Kontainerisasi

### Infrastruktur
- **Cloudflare Tunnel** - Eksposur aman
- **Nginx** - Reverse proxy
- **Docker Compose** - Orkestrasi
- **Git** - Kontrol versi & deployment

## Rincian Biaya: Tanpa Tagihan Cloud

| Layanan | Biaya | Catatan |
|---------|------|-------|
| Cloudflare Pages | $0 | Tier gratis |
| Cloudflare Tunnel | $0 | Tier gratis |
| Cloudflare DNS | $0 | Tier gratis |
| Domain | $10/tahun | dewadownload.com |
| **Total** | **$10/tahun** | Hanya domain! |

Bandingkan dengan pendekatan "cloud-native":
- 3x Cloud Functions: $30-50/bulan
- Load Balancer: $20-30/bulan
- CDN: $10-20/bulan
- **Total Cloud: $60-100/bulan**

**Penghematan: $700-1.200/tahun**

## Tantangan & Solusi

### Tantangan 1: Streaming File Besar
**Masalah:** Masalah memori Node.js dengan video 4K

**Solusi:** Stream langsung dari yt-dlp ke respons
```typescript
const stream = ytDlp.execStream(url, { format: 'best' });
stream.pipe(reply.raw);
```

### Tantangan 2: Sinkronisasi Multi-Node
**Masalah:** Menjaga 3 node tetap sinkron

**Solusi:** Deployment berbasis git
```bash
# Di setiap server
cd /opt/dewadownload/infra
git pull && docker compose up -d --build
```

### Tantangan 3: Pembatasan Laju
**Masalah:** Penyalahgunaan dan spam

**Solusi:** Batas laju Nginx + caching Redis
```nginx
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
```

## Peningkatan Masa Depan

- [ ] Deployment otomatis melalui GitHub Actions
- [ ] Sharding database untuk Redis
- [ ] Load balancing geografis
- [ ] WebSocket untuk progres real-time
- [ ] Thumbnail pratinjau video

## Kesimpulan

DewaDownload membuktikan kamu tidak perlu tagihan cloud $1.000/bulan untuk menjalankan layanan global. Dengan arsitektur yang tepat, kamu bisa membangun sesuatu yang cepat, andal, dan aman dengan biaya nama domain.

Pelajaran utama:
1. **Cloudflare Tunnel > Port Forwarding**
2. **Docker Compose > Kubernetes** (untuk skala kecil)
3. **Git Push > CI/CD** (terkadang)
4. **Edge Computing > Cloud Computing**

Ingin melihat kodenya? Cek [repositori GitHub](https://github.com/ardinusawan/download-youtube-video).

Coba di [dewadownload.com](https://dewadownload.com)!

Punya pertanyaan? Hubungi saya di ardi.nusawan13[at]gmail.com!

---

**Dibuat dengan ❤️ dan tanpa tagihan cloud oleh [Ardi Nusawan](https://github.com/ardinusawan)**
