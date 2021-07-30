FROM node:12
RUN node -v
WORKDIR /app/src/
COPY ./package*.json ./
RUN npm install
COPY ./ .
RUN npm install -g @ionic/cli
RUN npm rebuild node-sass
EXPOSE 8100
CMD [ "ionic" , "serve", "--external" ]