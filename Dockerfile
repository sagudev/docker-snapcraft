FROM ubuntu:bionic

RUN apt update && apt upgrade -y && apt install -y snapcraft && apt clean && apt install curl sudo jq squashfs-tools -y
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core' | jq '.download_url' -r) --output core.snap && \
  mkdir -p /snap/core && unsquashfs -d /snap/core/current core.snap && rm core.snap && \
  curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core18' | jq '.download_url' -r) --output core18.snap && \
  mkdir -p /snap/core18 && unsquashfs -d /snap/core18/current core18.snap && rm core18.snap && \
  curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=stable' | jq '.download_url' -r) --output snapcraft.snap && \
  mkdir -p /snap/snapcraft && unsquashfs -d /snap/snapcraft/current snapcraft.snap && rm snapcraft.snap && \
  apt remove --yes --purge curl jq squashfs-tools && \
  apt-get autoclean --yes && \
  apt-get clean --yes

COPY bin/snapcraft-wrapper /snap/bin/snapcraft

RUN chmod +x /snap/bin/snapcraft

ENV SNAP=/snap/snapcraft/current
ENV SNAP_NAME=snapcraft
ENV PATH=/snap/bin:$PATH

# enable multiverse as snapcraft cleanbuild does
RUN sed -i 's/ universe/ universe multiverse/' /etc/apt/sources.list
