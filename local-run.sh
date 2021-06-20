#!/bin/bash

mkdir -p root/mnt/ramdisk/

cat << EOF > root/mnt/ramdisk/modlist.conf
# test
https://api.cfwidget.com/minecraft/mc-mods/bounding-box-outline-reloaded
https://api.cfwidget.com/minecraft/mc-mods/carpet
https://api.cfwidget.com/minecraft/mc-mods/fabric-api
https://api.cfwidget.com/minecraft/mc-mods/lithium
https://api.cfwidget.com/minecraft/mc-mods/phosphor
https://api.cfwidget.com/minecraft/mc-mods/shulkerboxtooltip

https://api.github.com/repos/gnembon/carpet-extra/releases
https://api.github.com/repos/gnembon/carpet-autoCraftingTable/releases
EOF

docker build \
        --no-cache \
        --pull \
        --file Dockerfile \
        --tag mc \
        .

docker run -it \
    --env TZ=America/Chicago \
    --env MINECRAFT_VERSION="1.17" \
    mc
