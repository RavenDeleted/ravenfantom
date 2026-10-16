# Ravenfantom

Ravenfantom is a hardened fork of postmarketOS (nura) — a privacy-focused mobile operating system with a permanent Tor killswitch, sandboxed applications, and an isolated Android layer.

> **"With Ravenfantom, you will be a ghost."**

---

## Goals

- **Zero Trust** — every application is isolated, nothing is trusted by default
- **Zero Leak** — no traffic leaves the device without going through Tor
- **Open Source** — everything is auditable, reproducible, forkable
- **Privacy First** — no accounts, no telemetry, no tracking

---

## Architecture
┌──────────────────────────────────────────────┐
│ User Applications │
│ Firefox (sandboxed) │ Thunderbird (sandbox)│
│ Waydroid (Android layer) │
└──────────────────────┬───────────────────────┘
│
┌─────────────┴─────────────┐
▼ ▼
Bubblewrap (sandbox) Waydroid NAT
│ │
└─────────────┬─────────────┘
▼
┌─────────────────┐
│ Tor (9050/9040) │
└────────┬────────┘
│
┌────────▼────────┐
│ Internet │
└─────────────────┘

### Security Layers

1. **Hardened kernel** — sysctl hardening (kptr_restrict, ptrace_scope, etc.)
2. **nftables killswitch** — blocks everything except Tor
3. **Tor** — bootstrapped at boot, SOCKS5 (9050) + TransPort (9040)
4. **Forced DNS** — all DNS redirected through Tor DNSPort
5. **Bubblewrap** — per-application sandbox
6. **Waydroid** — isolated Android with Tor-routed Internet

---

## Components

| Component     | Role                     | Status |
|---------------|--------------------------|--------|
| postmarketOS  | Mobile Linux base        | ✅     |
| Phosh         | Wayland UI               | ✅     |
| Tor           | Network anonymization    | ✅     |
| nftables      | Killswitch + NAT         | ✅     |
| Bubblewrap    | Application sandbox      | ✅     |
| Firefox-ESR   | Web browser              | ✅     |
| Thunderbird   | Mail client              | ✅     |
| Waydroid      | Android in LXC           | ✅     |

---

## Quick Install

### Requirements

- Arch Linux (or derivative)
- 8 GB RAM minimum
- KVM enabled (Intel VT-x or AMD-V)

### Build

```bash
git clone https://github.com/YOUR_USER/ravenfantom.git
cd ravenfantom

# Install pmbootstrap
git clone https://gitlab.postmarketos.org/postMarketOS/pmbootstrap.git ~/pmbootstrap
mkdir -p ~/.local/bin
ln -sf ~/pmbootstrap/pmbootstrap.py ~/.local/bin/pmbootstrap

# Configure
pmbootstrap init   # choose: qemu, amd64, phosh

# Build with required packages
pmbootstrap install --add "openssh,nftables,tor,bubblewrap,torsocks"

# Boot
pmbootstrap qemu --image-size=8G --display sdl -m 1536
