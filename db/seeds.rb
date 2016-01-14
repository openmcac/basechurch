group = Group.create(name: 'English Service')
user = User.create(email: 'test@example.com',
                   password: 'password',
                   provider: "email")

service_order =
  " - ## Call to Worship
 - ## Praise & Worship
 - ## Announcements
 - ## Offering
 - ## Holy Communion
 - ## Sermon
   \"We Will Love The World\"  
   Genesis 2:4-15
 - ## Doxology
 - ## Benediction"

bulletin = Bulletin.create(published_at: DateTime.new(2016, 01, 3),
                           group: group,
                           name: 'Holy Communion New Year Sunday Service',
                           description: 'January 3, 2016 at 9:30 am',
                           service_order: service_order)
post = Post.create(author: user,
                   group: group,
                   title: 'This is a title',
                   content: 'This is my post content',
                   published_at: DateTime.now)

[
  "**Welcome friends and visitors.** We invite you to make MCAC your spiritual
home. Please let us know how we can be of help to you.",
  "The **2016 Church theme** is \"Equip to Shepherd\". *\"..to equip his people
for works of servce, so that the body of Christ may be built up\" (Ephesians
4:12)",
  "We have received **162 pledge cards**, pledging an amount of **$103,510**.
If you have participated in the pledge, when you offer please specify
\"Missions\". Also remember to put 2016 as the year if you offer with checks.",
  "Praise the Lord for the opportunities to reach out to our community through
the Christmas activities: the Celebrations in our 3 congregations, caroling in
an elderly home and with CCM's Christmas gifts to elderly and homeless... May
more people learn about the true meaning and the reason of Christmas.",
  "Rev. Chan and Auntie Cindy have left for Hong Kong on Wednesday to visit
family and friends. They will return on the 21st of January.",
  "There will be a **Jacob Fellowship** prayer meeting on Sunday, January 10
from 11:30am to 12:30pm in the library.",
  "Sunday school classes will resume next Sunday.",
  "There will be an Elders Board meeting on January 24th. 2016 ministry annual
report due the end of January. Annual Membership meeting takes place on
February 28th 11:30am after the joint service at 10am.",
  "**2016 Church Directory** is now available. Ask ushers for a copy. 1 per
family.",
  "**Church Renewal Weekend** offered by the Southland Church in Steinback, MB.
January 29 - February 1, 2016. Main speaker: Pastor Ray Duerksen. Fee for the
sessions: $139/person. Session and events include: Retreats, Ministry Tours,
Worships on Church Renewal and Hearing God, Prayer Summit and fellowships. For
more info, visit
[churchrenewalministry.com](http://www.churchrenewalministry.com)."
].each_with_index do |a, i|
  Announcement.create(post: post,
                      bulletin: bulletin,
                      description: a,
                      position: i + 1)
end
