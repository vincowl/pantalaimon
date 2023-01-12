#!/usr/bin/env bash
export DISPLAY=:0
service dbus start
#RUN systemd --user start dbus.socket
export NO_AT_BRIDGE=1
export $(dbus-launch)

#ENTRYPOINT ["dbus-run-session"]
#CMD ["env", "DISPLAY=:0", "pantalaimon", "-c", "/data/pantalaimon.conf", "--data-path", "/data"]
#ENTRYPOINT ["pantalaimon"]
#CMD ["-c", "/data/pantalaimon.conf", "--data-path", "/data"]

exec pantalaimon -c /data/pantalaimon.conf --data-path /data

