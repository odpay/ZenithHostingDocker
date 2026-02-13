#!/bin/sh

echo "entrypoint..."

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

# If /plugins exists and is not empty, copy everything to /opt/ZenithProxy/plugins
if [ -d /plugins ] && [ "$(ls -A /plugins)" ]; then
    echo "Copying files from /defaults to /opt/ZenithProxy/plugins..."
    mkdir /opt/ZenithProxy/plugins/
    cp -a /plugins/. /opt/ZenithProxy/plugins/
fi

cd /opt/ZenithProxy
chmod +x ./launch

while true; do
    if [ -n "$ZENITH_PLUGIN_URL" ]; then
        mkdir -p plugins
        echo "Downloading plugin..."
        wget --header="Authorization: $ZENITH_PLUGIN_TOKEN" \
            -O plugins/zenithhost-mgmt.jar "$ZENITH_PLUGIN_URL" \
            || echo "Plugin download failed, continuing with existing jar"
    fi

    echo "Starting ZenithProxy..."
    ./launch --unattended
    echo "ZenithProxy exited ($?), restarting in 2s..."
    sleep 2
done
