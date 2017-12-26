[![Code Climate](https://img.shields.io/codeclimate/maintainability/anomaly/jekyll-incremental.svg?style=for-the-badge)](https://codeclimate.com/github/anomaly/jekyll-incremental/maintainability)
[![Code Climate](https://img.shields.io/codeclimate/coverage/github/anomaly/jekyll-incremental.svg?style=for-the-badge)](https://codeclimate.com/github/anomaly/jekyll-incremental/test_coverage)
[![Travis CI](https://img.shields.io/travis/anomaly/jekyll-incremental/master.svg?style=for-the-badge)](https://travis-ci.org/anomaly/jekyll-incremental)
![Gem Version](https://img.shields.io/gem/v/jekyll-incremental.svg?style=for-the-badge)
![Gem DL](https://img.shields.io/gem/dt/jekyll-incremental.svg?style=for-the-badge)

# Jekyll Incremental

Jekyll Incremental is a more simple, and to the point version of incremental generation for Jekyll.  It also tries to solve the shortfalls of Jekyll's own incremental regeneration by treating all things equal, dynamic, doc, post, or collection.  As long as we can get the path, we will track it and make sure it gets generated.  It has an almost backwards compatible API (as far as adding dependencies, and dependent's) and merges several other API's in favor of a single, simple interface to track everything.

## Usage

```ruby
gem "jekyll-reload", {
  group: "jekyll-plugins"
}
```

And use the `--incremental` option on the command line interface.
