FROM node:14 as build

WORKDIR /app
COPY . .
RUN npm install nvm 
RUN npm install  npm@6.14.4
RUN npm install  @ionic/cli@6.12.3
RUN nvm install v10.19.0
RUN npm install
COPY ./ /app/
RUN npm run-script build:prod


FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/www/ /usr/share/nginx/html/