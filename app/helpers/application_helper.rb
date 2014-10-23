module ApplicationHelper
  def upvote_class
    if current_user
      ["upvote", current_user.vote_products.include?(@product) ? "voted" : nil ].compact.join(" ")
    else
      "upvote"
    end
  end

  def id_upvote
    @id_upvote = upvote_class.split(/\s/).join("_")
  end

  def time_past(time)
    t = TimeAgo.new(time)

    t.format_time
  end

  def is_current_user_author?(user)
    current_user == user
  end
end
