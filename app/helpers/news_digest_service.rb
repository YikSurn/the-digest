require 'mandrill'

NUMBER_OF_ARTICLES_PER_DIGEST = 10

# Service to handle sending of news digests
module NewsDigestService

  def create_digest user
    articles = compile_articles(user)
    message = articles ? digest_message(articles) : alert_message
    mandrill_send(message, user)
  end

  def news_digest
    users = User.where(:subscribed => true)
    users.each { |u| create_digest(u) }
  end

  def compile_articles user
    interested_articles = Article.tagged_with(user.interest_list, :any => true).order(pub_date: :desc)
    sent_articles = user.articles
    sent_ids = sent_articles.map { |x| x.id }
    articles = interested_articles.reject { |x| sent_ids.include? x.id }

    articles[0...NUMBER_OF_ARTICLES_PER_DIGEST]
  end

  def alert_message
    message = {
      :subject => 'No new articles available for digest. Update your interests!',
      :text => 'Hi. You should update your interests! Cheers.'
    }
  end

  def digest_message articles

  end

  def mandrill_send m, user
    m = Mandrill::API.new
    message = {
      :from_name => "TheDigest",
      :to =>[
        {
          :email => user.email,
          :name => user.first_name
        }
      ],
      # :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",
      :from_email => "yiksurn.chong@gmail.com"
    }

    message = message.merge(m)
    sending = m.messages.send(message)
  end

end
