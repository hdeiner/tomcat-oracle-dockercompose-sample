This project demomstrates a way to build and test locally between an Oracle database and a Tomcat application.

* Create an Oracle database in a Docker container with our schema and data suitable for testing
* Create a Tomcat war that uses the Oracle database
* Use docker-compose to manage the Docker infrastructure locally 
* Run quick smoke tests from build script
* Run extensive cucumber based integration tests from build script
