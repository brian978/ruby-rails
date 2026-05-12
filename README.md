# ruby-rails
Service image for a Ruby on Rails application

## Supported platforms
* linux/amd64
* linux/arm64

## Building the images
For Ruby 4.0 and the latest version of Ruby on Rails you need to run the following commands depending on env:
* prod: `make 40`
* dev: `make 40 env=dev`

For Ruby 3.4:
* prod: `make 34`
* dev: `make 34 env=dev`
