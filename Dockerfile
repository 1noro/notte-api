FROM node:17.6 as base

# ------------------------------------------------------------------------------
FROM base as common
RUN mkdir -p /app
WORKDIR /app


# ------------------------------------------------------------------------------
FROM common as dev

ARG UID=1000
ARG GID=1000

RUN chown -R $UID:$GID /app
ENTRYPOINT [ "npm", "run", "start-dev" ]

# ------------------------------------------------------------------------------
FROM common as pro

COPY ./app /app

RUN cd /app && npm install
ENTRYPOINT [ "npm", "start" ]
