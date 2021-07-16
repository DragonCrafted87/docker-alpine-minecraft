#!/bin/bash

mkdir -p mnt/ramdisk/

cat << EOF > root/mnt/ramdisk/modlist.conf
# test
# https://www.curseforge.com/minecraft/mc-mods/bounding-box-outline-reloaded
https://api.cfwidget.com/272578
# https://www.curseforge.com/minecraft/mc-mods/fabric-api
https://api.cfwidget.com/306612
# https://www.curseforge.com/minecraft/mc-mods/lithium
https://api.cfwidget.com/360438
# https://www.curseforge.com/minecraft/mc-mods/phosphor
https://api.cfwidget.com/372124
# https://www.curseforge.com/minecraft/mc-mods/shulkerboxtooltip
https://api.cfwidget.com/315811
# https://www.curseforge.com/minecraft/mc-mods/simple-voice-chat
https://api.cfwidget.com/416089

# https://github.com/gnembon/fabric-carpet/releases
https://api.github.com/repos/gnembon/fabric-carpet/releases
# https://github.com/gnembon/carpet-extra/releases
https://api.github.com/repos/gnembon/carpet-extra/releases
# https://github.com/gnembon/carpet-autoCraftingTable/releases
https://api.github.com/repos/gnembon/carpet-autoCraftingTable/releases
EOF

docker build \
        --no-cache \
        --pull \
        --file Dockerfile \
        --tag mc \
        .

MSYS_NO_PATHCONV=1 \
    docker run -it \
        --env TZ=America/Chicago \
        --env MINECRAFT_VERSION="1.17.1" \
        --volume "$(pwd)"/mnt/minecraft:/mnt/minecraft \
        --volume "$(pwd)"/mnt/ramdisk:/mnt/ramdisk \
        --publish 25565:25565 \
        mc

rm -rf mnt/ramdisk/
