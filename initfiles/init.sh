#!/usr/bin/env bash
#export DISPLAY=:0
#service dbus start
##RUN systemd --user start dbus.socket
#export NO_AT_BRIDGE=1
#export $(dbus-launch)

if ! pgrep -x "dbus-daemon" > /dev/null
then
    # export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address | cut -d, -f1)

    # or:
    dbus-daemon --config-file=/usr/share/dbus-1/system.conf
    # and put in Dockerfile:
    # ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/dbus/system_bus_socket"
else
    echo "dbus-daemon already running"
fi


#ENTRYPOINT ["dbus-run-session"]
#CMD ["env", "DISPLAY=:0", "pantalaimon", "-c", "/data/pantalaimon.conf", "--data-path", "/data"]
#ENTRYPOINT ["pantalaimon"]
#CMD ["-c", "/data/pantalaimon.conf", "--data-path", "/data"]

exec pantalaimon -c /data/pantalaimon.conf --data-path /data

