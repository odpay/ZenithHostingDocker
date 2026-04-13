#!/bin/sh

echo "entrypoint..."

# Copy launcher files
if [ -d /usr/share/zenithproxy ]; then
    echo "Copying launcher files to /opt/ZenithProxy..."
    cp -af /usr/share/zenithproxy/. /opt/ZenithProxy/
fi

# If /defaults exists and is not empty, copy to /opt/ZenithProxy only on first boot
# (don't clobber existing config from a previous run on emptyDir)
if [ -d /defaults ] && [ "$(ls -A /defaults)" ] && [ ! -f /opt/ZenithProxy/config.json ]; then
    echo "First boot: copying defaults to /opt/ZenithProxy..."
    cp -a /defaults/. /opt/ZenithProxy/
fi

# If /plugins exists and is not empty, copy to /opt/ZenithProxy/plugins only on first boot
if [ -d /plugins ] && [ "$(ls -A /plugins)" ] && [ ! -d /opt/ZenithProxy/plugins ]; then
    echo "First boot: copying plugins to /opt/ZenithProxy/plugins..."
    mkdir -p /opt/ZenithProxy/plugins/
    cp -a /plugins/. /opt/ZenithProxy/plugins/
fi

cd /opt/ZenithProxy
chmod +x ./launch

while true; do
    if [ -n "$ZENITH_PLUGIN_URL" ]; then
        mkdir -p plugins
        echo "Downloading plugin..."
        if wget --header="Authorization: $ZENITH_PLUGIN_TOKEN" \
            -O plugins/zenithhost-mgmt.jar.tmp "$ZENITH_PLUGIN_URL"; then
            mv plugins/zenithhost-mgmt.jar.tmp plugins/zenithhost-mgmt.jar
            echo "Plugin download successful"
        else
            rm -f plugins/zenithhost-mgmt.jar.tmp
            echo "Plugin download failed, continuing with existing jar"
        fi
    fi

    echo "Starting ZenithProxy..."
    ./launch --unattended
    echo "ZenithProxy exited ($?), restarting in 2s..."
    sleep 2
done
