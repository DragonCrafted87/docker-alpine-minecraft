#!/bin/bash

mkdir -p mnt/ramdisk/
mkdir -p mnt/minecraft/

cat << EOF > mnt/ramdisk/modlist.conf
# test
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
# https://www.curseforge.com/minecraft/mc-mods/worldedit
https://api.cfwidget.com/225608

# https://github.com/gnembon/fabric-carpet/releases
https://api.github.com/repos/gnembon/fabric-carpet/releases
# https://github.com/gnembon/carpet-extra/releases
https://api.github.com/repos/gnembon/carpet-extra/releases
# https://github.com/gnembon/carpet-autoCraftingTable/releases
https://api.github.com/repos/gnembon/carpet-autoCraftingTable/releases
EOF

docker build \
        --file Dockerfile \
        --tag mc \
        .

MSYS_NO_PATHCONV=1 \
MSYS2_ARG_CONV_EXCL="*" \
    docker run -it \
        --env TZ=America/Chicago \
        --env MINECRAFT_VERSION="1.18.1" \
        --volume "$(pwd)"/mnt/minecraft:/mnt/minecraft \
        --volume "$(pwd)"/mnt/ramdisk:/mnt/ramdisk \
        --publish 25565:25565 \
        mc

rm -rf mnt/ramdisk/
