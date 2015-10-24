require 'mandrill'

ARTICLES_PER_DIGEST = 10

# Service to handle sending of news digests
module NewsDigestService

  def self.create_digest user
    articles = self.compile_articles(user)
    message = articles ? self.digest_message(articles) : self.alert_message(user)
    self.mandrill_send(message, user)
  end

  def self.news_digest
    users = User.where(:subscribed => true)
    users.each { |u| self.create_digest(u) }
  end

  def self.compile_articles user
    interested_articles = Article.tagged_with(user.interest_list, :any => true).order(pub_date: :desc)
    sent_articles = user.articles
    sent_ids = sent_articles.map { |x| x.id }
    articles = interested_articles.reject { |x| sent_ids.include? x.id }

    articles[0...ARTICLES_PER_DIGEST]
  end

  def self.alert_message user
    message = {
      :subject => 'No articles matching your interests currently available. Update your interests!',
      :text => "Hi #{user.first_name},\nYou should update your interests!\nCheers,\nTheDigest"
    }
  end

  def self.digest_message articles
    # Add the new articles to articles sent to user
    user.articles << articles

    html_text = '<html>'

    articles.each do |article|
      html_text += '<h2><a href="' + article.url + '">' + article.title + '</a></h2><br>'
      html_text += '<p>' + article.summary + '</p><br>'
      html_text += '<small>Published On: ' + article.pub_date.strftime('%e %b %Y') + '</small><br>'
      html_text += '<br>'
    end

    html_text += '</html>'
    message = {
      :subject => 'Your News Digest',
      :html=> html_text
    }
  end

  def self.mandrill_send message_txt, user
    m = Mandrill::API.new
    message = {
      :from_name => "TheDigest",
      :to =>[
        {
          :email => user.email,
          :name => user.first_name
        }
      ],
      :from_email => "yiksurn.chong@gmail.com"
    }

    message = message.merge(message_txt)
    sending = m.messages.send(message)
  end

end
