# README

This repository contains only Web API.

Site is hosted on DigitalOcean App Platform: [https://rails.viwi.app](https://rails.viwi.app)

Front-end part can be found at [https://github.com/julianpetriv/react-blog-frontend](https://github.com/julianpetriv/react-blog-frontend)

Features of my project:

* Getting started
* Authentication
* Deployment on DigitalOcean
* JSON API + client (React app) + JWT authentication
* Authentication using phone number and sms one-time-code
* Image uploading to DigitalOcean Spaces (S3-like storage)
* Article search (using backend)
* Docker-compose

P.S.: docker-compose.yml file is located in this repo, to make it work just copy it to parent dictionary of 2 cloned repos

P.P.S.: When running locally, authorization won't work as it requires API key to SMS messaging service (and this is public repo 👀).