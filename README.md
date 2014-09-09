# Buildbox Status Package

A really simple build box status package based on a similar package for Travis CI https://github.com/tombell/travis-ci-status.

Right now it's designed to pick up your builds by looking builds for your current branch with your email address.

It's not really in a usable state, as it's rather specific to Envato's build pipeline.

# Todo

* [ ] Fix the build matrix to work with a flat build
* [ ] Hasn't been tested for when a build is in progress
* [ ] Some kind of polling so it updates automatically
* [ ] Trigger manual builds from the widget


# Usage

You can use the package Settings for Atom wide enjoyment, or have a `.buildbox.json` file in your project root with all the settings specific to that project.

For example:

``` json
{
  "apiKey": "53e4aa671ccbf9e41abc6d7a22361ed4",
  "account": "buildbox-account",
  "project": "some-project",
  "email": "ohai@lolcats.com"
}
```
