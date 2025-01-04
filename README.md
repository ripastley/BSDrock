# BSDrock
BSDrock is a FreeBSD container for deploying Minecraft Bedrock servers using FreeBSD jails.

# Installation Guide:
Run `git clone https://github.com/ripastley/BSDrock` to download BSDrock.

`cd` into the downloaded directory and unzip bsdrock_alpha.zip

Run `install_bsdrock.sh`

Carefully follow prompts. Install script is in very early development but is functional.

Once the jail is installed, you can open the Minecraft folder by mapping the jail's SMB share (`\\your_ip\Minecraft`)

Add your minecraft folder and restart the jail (`service jail restart bedrock`)

This project is in the early stages and is mostly for my own personal use. YMMV.

# Happy crafting!
