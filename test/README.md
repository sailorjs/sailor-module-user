# Sailor module user

Resume of operations:

```
CREATE: POST /user/create/:strategy
REMOVE: DELETE /user/:identifier
LOGIN:
LOGOUT:
FIND:
FINDONE:
UPDATE:
```


## create

### POST user/create/:strategy

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

## remove
### DELETE /user/\<username>
### DELETE /user/\<email>

`username` and `email` parameter are extracted from the URL.

## login
## logout

## find
## findOne
## update