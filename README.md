<div align="center">

# Warpinator-AppImage 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/ArqamQazi/Warpinator/total?logo=github&label=GitHub%20Downloads)](https://github.com/ArqamQazi/Warpinator/releases/latest)
[![CI Build Status](https://github.com/ArqamQazi/Warpinator/actions/workflows/appimage.yml/badge.svg)](https://github.com/ArqamQazi/Warpinator/releases/latest)
[![Latest Stable Release](https://img.shields.io/github/v/release/ArqamQazi/Warpinator)](https://github.com/ArqamQazi/Warpinator/releases/latest)

<p align="center">
  <img src="https://raw.githubusercontent.com/linuxmint/warpinator/master/data/icons/hicolor/256x256/apps/org.x.Warpinator.png" width="128" alt="Warpinator Logo" />
</p>

| Latest Stable Release | Upstream URL |
| :---: | :---: |
| [Click here](https://github.com/ArqamQazi/Warpinator/releases/latest) | [Click here](https://github.com/linuxmint/warpinator) |

</div>

---

### Description

Warpinator is a local network file transfer tool developed by Linux Mint. It allows you to easily share files and directories between devices on the same local area network (LAN) without relying on cloud services or external servers.

Features:
- **Local Network Sharing**: Send and receive files and folders directly across your local network (LAN) with fast transfer speeds.
- **Automatic Peer Discovery**: Automatically detects other devices on the network running Warpinator.
- **Secure Transfers**: End-to-end encryption with customizable group codes / network PINs to authenticate peers.
- **Transfer Control**: Monitor progress, view transfer history, and easily accept, reject, or pause file transfers.
- **Cross-Device Support**: Interoperable with official and third-party Warpinator clients across different platforms.

---

AppImage made using [quick-sharun](https://github.com/pkgforge-dev/Anylinux-AppImages/blob/main/useful-tools/quick-sharun.sh), which makes it extremely easy to turn any binary into a portable package reliably without using containers or similar tricks. 

**This AppImage bundles everything and it should work on any Linux distro, including old and musl-based ones.**

This AppImage doesn't require FUSE to run at all, thanks to the [uruntime](https://github.com/VHSgunzo/uruntime).

This AppImage is also supplied with a self-updater by default, so any updates to this application won't be missed, you will be prompted for permission to check for updates and if agreed you will then be notified when a new update is available.

Self-updater is disabled by default if AppImage managers like [am](https://github.com/ivan-hc/AM), [soar](https://github.com/pkgforge/soar) or [dbin](https://github.com/xplshn/dbin) exist, which manage AppImage updates.

<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/d40067a6-37d2-4784-927c-2c7f7cc6104b" alt="Inspiration Image">
</details>

---

More at: [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/)
