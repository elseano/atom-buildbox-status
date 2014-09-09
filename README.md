# Buildbox Status Package

A really simple build box status package based on a similar package for Travis CI https://github.com/tombell/travis-ci-status.

It picks up your last build by looking at builds on your current branch.

# Todo

* [ ] Trigger manual builds from the widget

# Usage

You can use the package Settings for Atom wide enjoyment, or have a `.buildbox.json` file in your project root with all the settings specific to that project.

For example:

``` json
{
  "apiKey": "53e4aa671ccbf9e41abc6d7a22361ed4",
  "account": "buildbox-account",
  "project": "some-project"
}
```
