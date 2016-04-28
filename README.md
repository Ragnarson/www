### ragnarson.com

This is our corporate site. With sources. With history.

It's contents are available under
[Attribution-NonCommercial-NoDerivatives 4.0 International license](http://creativecommons.org/licenses/by-nc-nd/4.0/).

You think it can be improved? Feel free to fork and send pull request.
However if you do so, we'll assume you give us full copyrights to your change.
We need to do that to publish our site anyway. :)

#### Development

```sh
$ git clone git@github.com:Ragnarson/www.git
$ bundle install
$ bundle exec middleman
```

#### Optimizing svg

Install `svgo` using `npm`, then:

```sh
find source/images/**/*.svg | xargs -n 1 svgo
```

#### Deployment

```sh
$ bundle exec middleman deploy
```
