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

Source.create!([
    {
      name: 'Sydney Morning Herald',
      url: 'http://www.smh.com.au/rssheadlines/technology-news/article/rss.xml'
    },
    {
      name: 'Herald Sun',
      url: 'http://feeds.news.com.au/heraldsun/rss/heraldsun_news_technology_2790.xml'
    },
    {
      name: 'ABC',
      url: 'http://www.abc.net.au/news/feed/45910/rss.xml'
    },
    {
      name: 'The Age',
      url: 'http://www.theage.com.au/rssheadlines/digital-life-news/article/rss.xml'
    },
    {
      name: 'SBS',
      url: 'http://www.sbs.com.au/news/rss/news/science-technology.xml'
    },
    {
      name: 'New York Times',
      url: 'http://api.nytimes.com/svc/topstories/v1/technology.json?api-key=0b50822950befdc61b6e8bb000f15021:14:72922814'
    },
    {
      name: 'The Guardian',
      url: 'http://content.guardianapis.com/search?q=technology%20startup%20entrepreneur%20software&api-key=w7v3mpny242ubjrk9kgw54qx'
    }
  ])

