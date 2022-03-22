# ntop-dockerized
A Docker image for the classic ntop (not ntopng) traffic analyzer. As far as I know, this was the last version that allowed for Netflow collection without the need for a commercial plugin.

Keep in mind this is a rather old codebase, but it's still adequate as a Netflow collector and traffic analyzer. Use at your own risk.

## Installation
* Clone the repo
* Copy the file vars-dist.env to vars.env
* Set your preferred admin password in the file vars.env (5 characters minimum)
* Build and run the image with docker-compose up -d
 
## Sources
The src directory in ths repo is bundled for convenience. The needed pieces come from:
* The bundled version of ntop in this repo is as still available in [Sourceforge](https://downloads.sourceforge.net/project/ntop/ntop/Stable/ntop-5.0.1.tar.gz). Some Github repos maintain the original SVN history, such as [lucab/ntop](https://github.com/lucab/ntop). (No luck for the bundled nDPI, sadly. This version of ntop won't compile with a modern nDPI)
* Patches as provided by [openembedded](https://cgit.openembedded.org/meta-openembedded/tree/meta-networking/recipes-support/ntop/ntop?id=f5b9e4ecd2cbcb4b6eae894a78cba8e72481c3a3)
* Uses [Almalinux 8 minimal](https://hub.docker.com/r/almalinux/8-minimal). Building in other modern distros other than EL8 (such as Alpine - libc problems, or Ubuntu 18.04/20.04 - geoip library incompatibilities) is unsuccessful.
