# syntax=docker/dockerfile:1

FROM node@sha256:bc0ff0ad6f4a4817cf28fcafafe8ed3c0c56197ef67ecd21dce4a6400047151a

EXPOSE 3000

WORKDIR /monorepo

COPY . .

RUN npm install

CMD ["node", "apps/server/index.js"]



