#!/bin/sh
cd /mnt/minecraft
java -jar fabric-installer.jar server -downloadMinecraft
rm fabric-installer.jar
exec java -Xms4G -Xmx4G -jar fabric-server-launch.jar --nogui --forceUpgrade
