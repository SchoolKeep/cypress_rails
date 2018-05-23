### 0.4.1 / 2018-05-23

* renamed `seeds` to `scripts`
* added `scripts_path` to config, it defaults to `spec/cypress/scripts`

### 0.4.0 / 2018-05-17

* Integrate the gem with Rails and hook up a middleware for: 
  * reseting the database
  * calling "seed" files
* Added configuration object with `before_each` option which takes a block of code to be executed
    before each example

### 0.3.0 / 2018-05-16

* Added more options to the CLI
* Added `#run` and `#open` methods to the Runner

### 0.2.0 / 2018-05-08

* Added `CypressRails::Runner` class that runs Cypress with the specified command inside the
    `CypressRails::Server.start` block
* Runner returns the status code of the Cypress process

### 0.1.0 / 2018-05-04

* Initial release
* Added `CypressRails::Server` class that starts the application to test under the specified address
