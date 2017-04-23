class DevotionImporter
  def process
    contents = File.read('/tmp/devos.txt')
    devotions = contents.split("-----")
    group = Group.last
    author = User.first
    last_post_published_at = Post.find(62).published_at
    last_day = 18
    devotions.map(&:strip).each do |d|
      post = Post.new
      current_day = last_day + 1
      post.title = "Pastoral Devotions: Day #{current_day}"
      post.author = author
      post.group = group
      post.published_at = last_post_published_at + 24.hours
      post.content = d
      post.save!

      puts "saved day #{current_day}"

      last_post_published_at = post.published_at
      last_day = current_day
    end
  end
end
