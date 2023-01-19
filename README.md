# OrangeFox Recovery Project for the Samsung Galaxy M30s

### How to build ###

```bash
# Create dirs
$ mkdir ofox ; cd ofox

# Init repo
$ repo init --depth=1 -u https://gitlab.com/OrangeFox/Manifest.git -b fox_9.0

# Clone m30sdd repo
$ git clone https://github.com/neel0210/ofox_m30s.git -b main device/samsung/m30sdd

# Sync
$ repo sync --no-repo-verify -c --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune -j64

# Build
$ source build/envsetup.sh ; lunch omni_m30sdd-eng ; mka recoveryimage
