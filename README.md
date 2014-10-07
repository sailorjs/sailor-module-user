<center>![](http://i.imgur.com/0W8wQDR.png)</center>

# Sailor Module User

[![Build Status](http://img.shields.io/travis/sailorjs/sailor-module-user/master.svg?style=flat)](https://travis-ci.org/sailorjs/sailor-module-user)
[![Dependency status](http://img.shields.io/david/sailorjs/sailor-module-user.svg?style=flat)](https://david-dm.org/Kikobeats/sailor-module-user)
[![Dev Dependencies Status](http://img.shields.io/david/dev/sailorjs/sailor-module-user.svg?style=flat)](https://david-dm.org/Kikobeats/sailor-module-user#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/sailor-module-user.svg?style=flat)](https://www.npmjs.org/package/sailor-module-user)
[![Gittip](http://img.shields.io/gittip/Kikobeats.svg?style=flat)](https://www.gittip.com/Kikobeats/)

> Module User for Sailor

## Install

Install as dependency in your sailor base application:

```bash
npm install sailor-module-user --save
```



## API

### Basic CRUD

### Register new user

```
POST /user
```

The minimum information to create a new user is:

```json
{
	email: "user@sailor.com,"
	password: "yourpassword",
	username: "user1"
}
```

Check the User Model for know the required, optional and the restriction of each field.

### Find all Users

```
GET /user
```

### Find One User

```
GET /user/:id
```

You can specified the user that you want to recover in the url by id:

```
GET /user/1
```

or create a more specified query using url params:

```
GET /user/?username=user2&email=user2@sailor.com
```

### Destroy an User

```
DELETE /user/:id
```

### Authentication

#### Login 

```
POST /user/login
```

You can login a user with his username:

```json
{
	identifier: "user2",
	password: "yourpassword"
}
```


or with the email:


```json
{
	identifier: "user2@sailor.com",
	password: "yourpassword"
}
```

### Logout

```
GET /user/logout
```


### Relationship


### get following or followers users

```
GET /user/:id/following
```

or

```
GET /user/:id/followers
```

### starts follow other User

```
POST /user/:id/following
```

with:

```json
{
	follower: 'yourfollowerID'}
```

### status relationship

```
GET /user/:id/following/status
```

with:

```json
{
	follower: 'yourfollowerID'}
```

### unfollow

```
DELETE /user/:id/following
```

with:

```json
{
	follower: 'yourfollowerID'}
```