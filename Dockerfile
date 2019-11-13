FROM node:8
RUN npm install && npm install nodemon -g
WORKDIR /usr/src/app
ENV MONGODB_URI=mongodb://localhost:27017/tododb-dev
COPY package*.json ./
COPY . .
EXPOSE 5000
CMD ["nodemon", "app.js"]
