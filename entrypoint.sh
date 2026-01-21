#!/bin/sh

# Copy launcher files
if [ -d /usr/share/zenithproxy ]; then
    echo "Copying launcher files to /opt/ZenithProxy..."
    cp -af /usr/share/zenithproxy/. /opt/ZenithProxy/
fi

# If /defaults exists and is not empty, copy everything to /opt/ZenithProxy
if [ -d /defaults ] && [ "$(ls -A /defaults)" ]; then
    echo "Copying files from /defaults to /opt/ZenithProxy..."
    cp -a /defaults/. /opt/ZenithProxy/
fi

cd /opt/ZenithProxy
chmod +x ./launch
exec ./launch --unattended
