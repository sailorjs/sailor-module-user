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

### POST user/create/\<strategy>/register

Object to `POST`:

```
{
username: "user2",
email: "user2@sailor.com",
password: "password"
}

```

Strategies can be:

* local
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