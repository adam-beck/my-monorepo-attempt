# syntax=docker/dockerfile:1

FROM node@sha256:bc0ff0ad6f4a4817cf28fcafafe8ed3c0c56197ef67ecd21dce4a6400047151a

ARG NODE_ENV=development
ENV NODE_ENV $NODE_ENV

EXPOSE 3000 3001

USER node

WORKDIR /monorepo

COPY --chown=node:node . .
RUN npm install
ENV PATH /monorepo/node_modules/.bin:$PATH

CMD ["node", "apps/server/index.js"]



