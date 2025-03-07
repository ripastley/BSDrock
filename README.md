# BSDrock
BSDrock is a FreeBSD container for deploying Minecraft Bedrock servers using FreeBSD jails.
#

<ins>Installation Host Requirements </ins>
- Machine running 64-bit FreeBSD 14.2-RELEASE
- Linux Binary Compatibility enabled (see [Chapter 12. Linux Binary Compatibility](https://docs.freebsd.org/en/books/handbook/linuxemu/) )
- samba419 (optional: for enabling SMB on jail)
- git-lfs (optional: for cloning BSDrock on local machine)
- NTP (must be enabled to sync with Microsoft login services if enabling online mode)
# Installation Guide:

Set up git-lfs if cloning onto local machine.
- Run `pkg install git-lfs` to install git-lfs.
- Then run `git-lfs install` in the directory you wish to clone into.

Run `git clone https://github.com/ripastley/BSDrock` to download BSDrock.

`cd` into the downloaded directory and unzip bsdrock_alpha.zip

Make install_bsdrock executable (`chmod 700 install_bsdrock.sh`)

Run `install_bsdrock.sh`

Carefully follow prompts. Install script is in very early development but is functional.

Once the jail is installed, you can open the Minecraft folder by mapping the jail's SMB share (`\\your_ip\Minecraft`)

Add your minecraft folder and restart the jail (`service jail restart bedrock`)

This project is in the early stages and is mostly for my own personal use. YMMV.

# Happy crafting!
