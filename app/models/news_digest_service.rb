require 'mandrill'

ARTICLES_PER_DIGEST = 10

# Module to handle sending of news digests
module NewsDigestService
  # Creates the digest
  def self.create_digest(user)
    articles = self.compile_articles(user)
    message = articles.empty? ? self.alert_message(user) : self.digest_message(user, articles)
    self.mandrill_send(user, message)
  end

  # Sends news digest to all subscribed users
  def self.news_digest
    users = User.where(subscribed: true)
    users.each { |u| self.create_digest(u) }
  end

  # Retrieves articles to be send in the news digest
  def self.compile_articles(user)
    interested_articles = Article.tagged_with(user.interest_list, any: true).order(pub_date: :desc)
    sent_articles = user.article
    sent_ids = sent_articles.map(&:id)
    articles = interested_articles.reject { |x| sent_ids.include? x.id }

    articles[0...ARTICLES_PER_DIGEST]
  end

  # Message to send to user when there are no available news digest articles
  def self.alert_message(user)
    {
      subject: 'Update your interests!',
      html: "Hi #{user.first_name},<br><br>There are currently no articles"\
        ' matching your interests available. You should update your interests!'\
        '<br><br>Cheers,<br>TheDigest'
    }
  end

  # Message to send to user containing the details of the articles
  # in the news digest
  def self.digest_message(user, articles)
    # Add the new articles to articles sent to user
    user.article << articles

    html_text = "<html><h3>Hi #{user.first_name},</h3><p>Below is your latest "\
      'news digest.</p><p>Have a nice day!<p><h3>Cheers,<br>TheDigest</h3><br>'\
      '<hr>'
    articles.each do |article|
      html_text += '<h4><a href="' + article.url + '">' + article.title +
                   '</a></h4>'
      html_text += '<p>' + article.summary + '</p>'
      html_text += '<small>By: ' + article.author + '</small><br>' unless article.author.nil?
      html_text += '<small>Published On: ' +
                   article.pub_date.strftime('%e %b %Y') + '</small>'
      html_text += '<br><br><hr>'
    end
    html_text += '</html>'

    {
      subject: 'Your News Digest',
      html: html_text
    }
  end

  # Sends the news digest to the user
  def self.mandrill_send(user, message_txt)
    m = Mandrill::API.new
    message = {
      from_name: 'TheDigest',
      to: [
        {
          email: user.email,
          name: user.first_name
        }
      ],
      from_email: ENV['EMAIL_SENDER']
    }

    message = message.merge(message_txt)

    m.messages.send(message)
  end
end
