# Queue API
Backend Rails-api for our [67-442 iOS project](https://github.com/rhoeuns/67442_project)

### Local:
To populate database with mock data:
```
rails db:seed
```
Or to reset everything:
```
rails db:reset
```

### Heroku Server:
First reset the database:
```
heroku pg:reset DATABASE --confirm queue-api
```
Then migrate and seed:
```
heroku run rake db:migrate db:seed
```
