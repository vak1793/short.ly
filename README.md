# short.ly

A url shortening REST service

Install rvm from [here](https://rvm.io/)

* Run `bundle install` from project root directory
* Run `rvmsudo rails s -p 80`. Enter your root password when prompted.
* If you are unable to run on port 80 try running on port 3001
* Add `127.0.0.1 short.ly` to your hosts file.
* Use [postman](https://www.getpostman.com/) or the UI [form](https://github.com/vak1793/shorten-me) to create shortened urls
* Use the shortened URL as you would use any url

## Endpoints
### 1. List
HTTP Method - GET

`short.ly/links` returns a list of all links currently present

### 2.  Create

HTTP Method - POST

`short.ly/links?url="url-to-compress"` creates a shortened url for url-to-compress and returns the same

### 3.  Find

HTTP Method - GET

`short.ly/links/url-to-find` finds the long url for the corresponding short url. (Enter only the 6 character hex code)

### 3.  Delete

HTTP Method - DELETE

`short.ly/links/url-to-delete` deletes the long url for the corresponding short url. (Enter only the 6 character hex code)
