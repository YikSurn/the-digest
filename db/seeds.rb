# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Source.delete_all
Article.delete_all

User.create!({
  first_name: 'John',
  last_name: 'Doe',
  email: 'john@doe.com',
  username: 'johndoe',
  password: 'testtest',
  password_confirmation: 'testtest',
})

sources = Source.create([
    {
      name: 'Sydney Morning Herald',
      url: 'http://www.smh.com.au/rssheadlines/technology-news/article/rss.xml',
      category: 'Technology News'
    },
    {
      name: 'Sydney Morning Herald',
      url: 'http://www.smh.com.au/rssheadlines/digital-life-news/article/rss.xml',
      category: 'Digital Life News'
    },
    {
      name: 'Sydney Morning Herald',
      url: 'http://feeds.smh.com.au/rssheadlines/itpro.xml',
      category: 'IT Pro'
    },
    {
      name: 'Herald Sun',
      url: 'http://feeds.news.com.au/heraldsun/rss/heraldsun_news_technology_2790.xml',
    },
    {
      name: 'New York Times',
      url: 'http://api.nytimes.com/svc/topstories/v1/technology.json?api-key=0b50822950befdc61b6e8bb000f15021:14:72922814'
    }
  ])

