Users
=====

## Logging in

```
POST /users/sign_in.json
```

### Parameters

```json
{
  "user": {
    "email": "test@example.com",
    "password": "password"
  }
}
```

## Finding a user

```
GET /users/:id
```

```json
{
  "user": {
    "name": "Jane Doe",
    "email": "janedoe@example.com"
  }
}
```
