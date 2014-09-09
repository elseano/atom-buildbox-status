# Buildbox Status Package

A really simple build box status package based on a similar package for Travis CI https://github.com/tombell/travis-ci-status.

Right now it's designed to pick up your builds by looking builds for your current branch with your email address.

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
