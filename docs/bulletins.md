Bulletin
========



```
GET /:group_slug/bulletins/:id
```

```json
{
  "bulletin": {
    "date": "2014-11-07T01:39:11+00:00",
    "name": "Special Service Name",
    "description": "9:30am Service",
    "serviceOrder": "",
    "announcements": [
      {
        "post": {
          "title": "",
          "content": "this is announcement 1",
          "permalink": "http://mcac.church/sundayservice/posts/123/announcement-1",
          "created_at": "2014-11-01T11:39:11+00:00"
        }
      },
      {
        "post": {
          "title": "",
          "content": "this is announcement 2",
          "permalink": "http://mcac.church/sundayservice/posts/234/announcement-2",
          "created_at": "2014-11-01T11:39:11+00:00"
        }
      },
      {
        "post": {
          "title": "",
          "content": "this is announcement 3",
          "permalink": "http://mcac.church/sundayservice/posts/345/announcement-3",
          "created_at": "2014-10-21T13:11:23+00:00"
        }
      }
    ],
    "sermon": {
      "speaker": "Guest Speaker",
      "name": "Surprise Sermon",
      "passages": ["John 3:16", "Genesis 1"]
    }
  }
}
```

```
GET /sunday
```
Alias for retrieving the latest bulletin for `sunday_service` group.
