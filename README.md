## Sailor Module User

[![Build Status](http://img.shields.io/travis/sailorjs/sailor-module-user/master.svg?style=flat)](https://travis-ci.org/Kikobeats/sailor-module-user)
[![Dependency status](http://img.shields.io/david/sailorjs/sailor-module-user.svg?style=flat)](https://david-dm.org/Kikobeats/sailor-module-user)
[![Dev Dependencies Status](http://img.shields.io/david/dev/sailorjs/sailor-module-user.svg?style=flat)](https://david-dm.org/Kikobeats/sailor-module-user#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/sailor-module-user.svg?style=flat)](https://www.npmjs.org/package/sailor-module-user)
[![Gittip](http://img.shields.io/gittip/Kikobeats.svg?style=flat)](https://www.gittip.com/Kikobeats/)

> Module User for Sailor

## Install

Install as dependency in your sailor base application:

```
npm install sailor-module-user --save
```

## API

## Create a new User

#### POST /lang/user

The minimum information to create a new user is:

```json
{
	email: "user@sailor.com,"
	password: "yourpassword",
	username: "user1"
}
```

check the User Model for know the required, optional and the restriction of each field.

## Find a User

#### GET /lang/user/

You can specified the user that you want to recover in the url by id:

```
GET /lang/user/1
```

or create a more specified query using url params:

```
GET /lang/user/?username=user2&email=user2@sailor.com
```

## Destroy User

#### DEL /lang/user

Destroy a user by id:

```
DEL /lang/user/1
```

## Login a User

#### POST /lang/user/login

Login a user using his email or username:

```json
{
	identifier: "<email or username>",
	password: "yourpassword"
}
```

## Logout a User

#### GET /lang/user/logout

TODO

## TODO

* WebTokens
* Login with Oauth services

