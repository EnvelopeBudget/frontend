# syntax=docker/dockerfile:1
ARG NODE_VERSION=23.9.0
FROM node:${NODE_VERSION}-alpine AS frontend_build
ENV NODE_ENV=production
WORKDIR /usr/src/app
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=yarn.lock,target=yarn.lock \
    --mount=type=cache,target=/root/.yarn \
    yarn install --production --frozen-lockfile
RUN mkdir node_modules/.cache && chmod -R 777 node_modules/.cache
RUN mkdir build && chmod 777 build
#USER node
COPY . .
RUN yarn build

FROM nginx AS frontend
COPY --from=frontend_build /usr/src/app/build /usr/share/nginx/html
