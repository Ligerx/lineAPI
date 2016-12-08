# Queue API
Backend Rails-api for our [67-442 iOS project](https://github.com/rhoeuns/67442_project)

## Setting up the database
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


#### Timezone issues:
I was having trouble getting things to display in the correct timezone.
Sometimes things would display in UTC and sometimes in EST.
To try fixing this, I added `config.time_zone` to `application.rb` and that seemed to fix it locally.

However, when deployed to Heroku, it seems to default to UTC and weird problems would arise again.
Following the advice from [this site](https://sbaronda.com/2014/03/05/getting-timezone-undercontrol-with-rails-and-heroku/), I could get Heroku in the right time zone with the above in addition to running `heroku config:add TZ=America/New_York`
