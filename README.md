# Raybot

Raybot, re-implemented for [Slack](http://raybeam.slack.com)!

Uses [slack-ruby-bot](https://github.com/dblock/slack-ruby-bot/tree/v0.8.2) as
its base.

To connect to slack, run `heroku config:add SLACK_API_TOKEN=token_goes_here`
before deploying.

## Development
### Setting Up
1. `Clone the repo`
1. `gem install bundle`
1. `bundle install`

### Developing
Create a new file in `raybot/commands/`.  Use the existing files to get started.

## Running Locally
1. make sure .env exists in the root directory with `SLACK_API_TOKEN=token` in
it.
1. `foreman start`

## Deploying
1. Be a collaborator on the raybot-slack heroku instance. (ask other developers)
1. `heroku git:remote -a raybot-slack`
1. `git push heroku branchname:master`

