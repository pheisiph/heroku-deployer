Heroku Deployer
===============

Heroku Deployer is a plugin for the Heroku CLI to ease deployment in a multi-env setup. 

## Installation

```
$ heroku plugins:install git://github.com/darph/heroku-deployer.git
```

## Usage

If you are running only one Heroku instance associated with your app, you don't need this plugin. Simply run `git push heroku` and your app is deployed.

However, if you have multiple instances of your app, for example a staging and a production environment, deployment is a bit more. Heroku deployer takes some of the typework out of that. 

The deployer assumes that you have added your Heroku instances as remotes carrying the name of your environment. If you run `git remote -v` your output should look something like this:

```
origin      git@github.com:you/yourapp.git (fetch)
origin      git@github.com:you/yourapp.git (push)
production  git@heroku.com:yourapp-production.git (fetch)
production  git@heroku.com:yourapp-production.git (push)
staging     git@heroku.com:yourapp-staging.git (fetch)
staging     git@heroku.com:yourapp-staging.git (push)
```

In that case deploying to your environment is as simple as typing 

```
 heroku deploy:staging
 heroku deploy:production
```

The Deployer turns on maintenance mode on your Heroku instance before pushing and turns it off if the deployment was successful. 

### Parameters

`-y, --yes, --skip-question` - By default deployer asks if you really want to deploy. Providing one of these parameters skips the questions and deploys directly.

`-m, --maintenance-on` - Do not turn off maintenance mode after deployement. This is useful if you want to run migrations or other rake tasks after pushing your code. 

Example: `heroku deploy:production -y -m`