## Sailor Module User

[![Build Status](http://img.shields.io/travis/sailorjs/sailor-module-user/master.svg?style=flat)](https://travis-ci.org/Kikobeats/sailor-module-user)
[![Dependency status](http://img.shields.io/david/sailorjs/sailor-module-user.svg?style=flat)](https://david-dm.org/Kikobeats/sailor-module-user)
[![Dev Dependencies Status](http://img.shields.io/david/dev/sailorjs/sailor-module-user.svg?style=flat)](https://david-dm.org/Kikobeats/sailor-module-user#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/sailor-module-user.svg?style=flat)](https://www.npmjs.org/package/sailor-module-user)
[![Gittip](http://img.shields.io/gittip/Kikobeats.svg?style=flat)](https://www.gittip.com/Kikobeats/)

> Module User for Sailor

## Installation

```
npm install sailor-module user --save
```

## API

Resume of content:

```
CREATE: POST /user/create/:strategy
REMOVE: DELETE /user/:identifier
LOGIN:
LOGOUT:
FIND:
FINDONE:
UPDATE:
```


### create

#### POST user/create/:strategy

Object to `POST`:

```
{
username: "user2",
email: "user2@sailor.com",
password: "password"
}

```

Strategies can be:

* local (can be exclude from the route)
* facebook
* twitter
* google

### remove
#### DELETE /user/\<username>
#### DELETE /user/\<email>

`username` and `email` parameter are extracted from the URL.

### login
### logout

### find
### findOne
### update


