# Cybersecurity & Homelab Portfolio

This repository contains the source code for my self-hosted cybersecurity and infrastructure portfolio.

🌐 **Live site:** https://beynz.uk

## About

I built this portfolio to document practical projects completed through my personal homelab, **Odysseus**.

The environment is used to develop hands-on experience with Linux administration, containerisation, networking, identity and access management, automation, monitoring and cybersecurity.

## Portfolio Infrastructure

The website is self-hosted on a Debian Linux mini PC rather than using a managed website hosting platform.

### Technologies

- Debian Linux
- Docker
- Caddy
- Cloudflare Tunnel
- Git & GitHub
- Bash
- WireGuard
- Uptime Kuma
- Grafana
- Diun
- AdGuard Home
- Vaultwarden

## Architecture

```text
Internet
   |
Cloudflare
   |
Cloudflare Tunnel
   |
cloudflared
   |
Caddy
   |
Static Portfolio
   |
Odysseus Debian Server
