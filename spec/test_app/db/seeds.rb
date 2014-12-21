group = Basechurch::Group.create(name: 'English Service')
user = Basechurch::User.create(email: 'test@example.com', password: 'password')
bulletin = Basechurch::Bulletin.create(display_published_at: DateTime.now.to_time.utc.iso8601,
                            group: group,
                            name: 'Sunday Service',
                            description: 'This is a service bulletin.',
                            service_order: 'This is the service order.')
post = Basechurch::Post.create(author: user,
                               group: group,
                               title: 'This is a title',
                               content: 'This is my post content',
                               published_at: DateTime.now)
Basechurch::Announcement.create(post: post,
                                bulletin: bulletin,
                                description: 'This is an announcement',
                                position: 1)
