# OrangeFox Recovery Project for the Samsung Galaxy M30s

### How to build ###

```bash
# Clone m30sdd repo
$ git clone https://github.com/neel0210/ofox_m30s.git -b main device/samsung/m30s

# Build
$ source build/envsetup.sh ; lunch omni_m30sdd-eng ; mka recoveryimage
