Posts
=====

```
GET /:group_slug/:post_id/:post_slug
```

```json
{
  "post": {
    "id": 1,
    "name": "This is a test post",
    "tags": ["test"],
    "author": {
      "id": 1,
      "name": "Jane Doe",
      "email": "janedoe@example.com"
    },
    "content": "This is my post content",
    "banner": <s3 url>
  }
}
```
