Contributing
============

### Join the Team

Team discussions will take place in Slack. Join @ https://mcac.slack.com/signup.

### Recommended Reading

If you're starting from scratch here are a couple guides that will help you out:

 - Setting up Git: https://help.github.com/articles/set-up-git/
 - Writing good commit messages: https://github.com/erlang/otp/wiki/Writing-good-commit-messages
 - Learning the fundamental JavaScript concepts: http://superherojs.com
 - Build a Rails app from scratch: https://www.railstutorial.org/book
 - Ember basics: http://emberjs.com/guides/
 - Eloquent Ruby: http://www.amazon.ca/Eloquent-Ruby-Russ-Olsen/dp/0321584104

If you're more of a visual person, here are also some really good talks:

 - Magic Tricks of Testing: https://www.youtube.com/watch?v=URSWYvyc42M
 - Therapeutic Refactoring: https://www.youtube.com/watch?v=J4dlF0kcThQ
 - Refactoring from Good to Great: https://www.youtube.com/watch?v=DC-pQPq0acs

### Style Guides

You don't need to memorize these but try to read them once to know what to keep
an eye on. Keeping a readable/consistent code base is one of the key ways to
keep everything sane.

 - JavaScript: https://github.com/airbnb/javascript
 - Ruby: https://github.com/bbatsov/ruby-style-guide

### Workflow

We'll be loosely following the [Feature Branch Workflow][wf]:

 - Avoid commiting code directly on `master`
 - Create a feature branch for every issue you're working on
 - Submit a pull request for every completed feature
 - Code review all pull requests before merging into `master`
 - `master` should always contain what's currently on production

[wf]: https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow

### Code Reviews

For now, Amos will be doing most of the code reviews until things get rolling.
A couple things that you should look out for before even submitting the pull
request for code review:

 - Keep the test coverage at or above the current level or have a good reason
   why a test is not needed.
 - Keep the code climate at or above the current level unless there's a good
   reason to lower it.

Lastly, have fun! There's no room for egos, we're all just here to learn and
discuss about code.
