#!/bin/sh

# If /defaults exists and is not empty, copy everything to /opt/ZenithProxy
if [ -d /defaults ] && [ "$(ls -A /defaults)" ]; then
    echo "Copying files from /defaults to /opt/ZenithProxy..."
    cp -a /defaults/. /opt/ZenithProxy/
fi

cd /opt/ZenithProxy
exec ./launch --unattended
