# Buildbox Status Package

A really simple build box status package based on a similar package for Travis
CI https://github.com/tombell/travis-ci-status.

It picks up your last build by looking at builds on your current branch.

# Usage

You can use the package Settings for Atom wide enjoyment, or have a `.buildbox.json`
file in your project root with all the settings specific to that project, which
is probably a better choice for your project name.

For example:

``` json
{
  "apiKey": "53e4aa671ccbf9e41abc6d7a22361ed4",
  "account": "buildbox-account",
  "project": "some-project"
}
```

# Screenshots

A build in progress

![Much anticipation](https://raw.githubusercontent.com/elseano/atom-buildbox-status/master/screenshots/in-progress.png)

A build failed

![Oh noes](https://raw.githubusercontent.com/elseano/atom-buildbox-status/master/screenshots/failed.png)

# Contributing

I'd love contributions! I'm also going to write some specs soon, I promise!

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Send me a pull request. Bonus points for topic branches.
