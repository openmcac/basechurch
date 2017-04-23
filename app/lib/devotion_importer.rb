class DevotionImporter
  def process
    contents = File.read('/tmp/devos.txt')
    devotions = contents.split("-----")
    group = Group.last
    author = User.first
    first_post = Group.last.posts.first
    devotions.map(&:strip).each do |d|
      post = Post.new
      published_at = Post.last.published_at + 24.hours
      current_day = (published_at.to_datetime - first_post.published_at.to_datetime).to_i + 1
      post.title = "Pastoral Devotions: Day #{current_day}"
      post.author = author
      post.group = group
      post.published_at = published_at
      post.content = d
      post.save!

      puts "saved day #{current_day}"
    end
  end
end
