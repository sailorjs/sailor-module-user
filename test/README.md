# Sailor module user - Testing

Resume of operations:

```
CREATE: POST /user/auth/\<strategy>/register
REMOVE: DELETE /user/
LOGIN:
LOGOUT:
FIND:
FINDONE:
UPDATE:
```


## create

### POST auth/\<strategy>/register

Object to `POST`:

```
{
username: "user2",
email: "user2@sailor.com",
password: "password"
}

```

Strategies can be:

* Local
* Facebook
* Twitter
* Google

## remove
### DELETE /user/\<username>
### DELETE /user/\<email>

`username` and `email` parameter are extracted from the URL.

## login
## logout

## find
## findOne
## update