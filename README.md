# MAC0350-PROJECT

Template for the project developed during the course MAC0350
(Introduction to Systems Development) at IME-USP.

This repository is a monorepo and requires [docker][1] and
[docker-compose][2] to run the services.

In order to setup the back-end services, open a shell and run:
```bash
cd server
docker-compose up
```

In order to setup the front-end services, open another shell and run:
```bash
cd client
docker-compose up
```

[1]: https://store.docker.com/search?type=edition&offering=community
[2]: https://docs.docker.com/compose/install/ 
