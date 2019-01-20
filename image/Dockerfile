# Create KeePassXC builder image
FROM debian:9-slim as builder

# Install dependencies
RUN set -xe \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
       ca-certificates coreutils locales \
       libargon2-0-dev qtbase5-dev qttools5-dev qttools5-dev-tools libqt5svg5-dev \
       zlib1g-dev libxi-dev libxtst-dev libqt5x11extras5-dev libgcrypt-dev libqrencode-dev \
       libsodium-dev libcurl4-openssl-dev libyubikey-dev libykpers-1-dev \
       automake bash cmake expat g++ gcc git make \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8

ARG keepassxc_version=2.3.1
ARG keepassxc_git=https://github.com/keepassxreboot/keepassxc.git

# Add build KeePassXC
RUN set -xe \
    && git clone --quiet --depth 1 --branch "${keepassxc_version}" "${keepassxc_git}" /src/keepassxc \
    && cd /src/keepassxc \
    && mkdir -p build \
    && cd build \
    && cmake -DWITH_XC_ALL=ON -DCMAKE_BUILD_TYPE=Release -DWITH_TESTS=ON .. \
    && make -j$(nproc) \
    && make test \
    && make DESTDIR=/keepassxc install

# Create KeePassXC runner image
FROM debian:9-slim

# Install dependencies
RUN set -xe \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
      sudo locales ca-certificates libcurl4-openssl-dev \
      libargon2-0 libc6 libgcrypt20 libqt5core5a libqt5dbus5 libqt5gui5 \
      libqt5network5 libqt5widgets5 libqt5x11extras5 libsodium18 \
      libstdc++6 libx11-6 libxtst6 libzxcvbn0 zlib1g libykpers-1-1 \
      libegl1-mesa libgl1-mesa-glx libgl1-mesa-dri libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8

COPY --from=builder /keepassxc/ /

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["keepassxc"]
