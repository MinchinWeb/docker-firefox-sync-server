# FROM minchinweb/python:2.7
FROM minchinweb/python:2.7

# install syncserver dependencies
COPY ./syncserver .

# local changes to above
COPY root/ /

# Install packages required
RUN \
    apt update -qq && \
    echo "\n**** Apt installs ****" && \
    apt install --no-install-recommends -y \
            gcc \
            g++ \
    && \
    echo "\n**** Installing Python packages ****" && \
    pip install \
        -r requirements.txt \
        -r dev-requirements.txt \
    && \
    echo "\n**** Apt cleanup ****" && \
    apt remove -y \
            gcc \
            g++ \
    && \
    apt autoremove -y

ENTRYPOINT [ "/s6-init", "/app/docker-entrypoint.sh" ]
CMD ["server"]
