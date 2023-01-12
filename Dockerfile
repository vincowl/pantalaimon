FROM python:3.8-slim-bullseye AS builder

RUN mkdir -p /app
RUN apt-get update && apt-get install -y git gcc clang cmake g++ pkg-config python3-dev wget libcairo2-dev libgirepository1.0-dev libdbus-1-3 libdbus-1-dev libffi7

WORKDIR /app
RUN wget https://gitlab.matrix.org/matrix-org/olm/-/archive/master/olm-master.tar.bz2 \
    && tar -xvf olm-master.tar.bz2 \
    && cd olm-master && make && make PREFIX="/usr" install

RUN pip --no-cache-dir install --upgrade pip setuptools wheel

COPY . /app

RUN pip wheel .[ui] --wheel-dir /wheels --find-links /wheels

FROM python:3.8-slim-bullseye AS run
RUN apt-get update && apt-get install -y tmux dbus dbus-x11 libcairo2-dev libgirepository1.0-dev libffi7 dbus-user-session

COPY --from=builder /usr/lib/libolm* /usr/lib/
COPY --from=builder /wheels /wheels

ENV DISPLAY=:0
RUN service dbus start
#RUN systemd --user start dbus.socket
ENV NO_AT_BRIDGE=1
RUN export "$(dbus-launch)"

WORKDIR /app

RUN pip --no-cache-dir install --find-links /wheels --no-index pantalaimon
RUN pip --no-cache-dir install --find-links /wheels --no-index pantalaimon[ui]

COPY initfiles/init.sh /usr/local/bin/.
RUN chmod +x /usr/local/bin/init.sh

VOLUME /data
#ENTRYPOINT ["dbus-run-session"]
#CMD ["env", "DISPLAY=:0", "pantalaimon", "-c", "/data/pantalaimon.conf", "--data-path", "/data"]
#ENTRYPOINT ["pantalaimon"]
#CMD ["-c", "/data/pantalaimon.conf", "--data-path", "/data"]
ENTRYPOINT ["/bin/bash", "/etc/init/init.sh"]


