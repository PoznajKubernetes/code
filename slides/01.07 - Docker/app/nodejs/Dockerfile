FROM node:latest

WORKDIR /app

COPY package*.json ./
RUN npm config set registry http://registry.npmjs.org/
RUN npm install

# removed
COPY . .
# added
COPY index.js ./

EXPOSE 8080
CMD [ "node", "index.js" ]
