group = Group.create(name: 'English Service')
user = User.create(email: 'test@example.com',
                   password: 'password',
                   provider: "email")
bulletin = Bulletin.create(published_at: DateTime.now,
                           group: group,
                           name: 'Sunday Service',
                           description: 'This is a service bulletin.',
                           service_order: 'This is the service order.')
post = Post.create(author: user,
                   group: group,
                   title: 'This is a title',
                   content: 'This is my post content',
                   published_at: DateTime.now)
Announcement.create(post: post,
                    bulletin: bulletin,
                    description: 'This is an announcement',
                    position: 1)
Announcement.create(post: post,
                    bulletin: bulletin,
                    description: 'This is the second announcement',
                    position: 2)
Announcement.create(post: post,
                    bulletin: bulletin,
                    description: 'This is the third announcement',
                    position: 3)
