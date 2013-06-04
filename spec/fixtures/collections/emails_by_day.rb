class EmailsByDay < Collection

  focus Model

  dimension "Date", :created_at, :last_seven_days
  dimension "Source", :source, :primary_sources

  question :unique_emails, :count_emails

  def last_seven_days
    (7.days.ago.to_date..Date.today).map do |date|
      key = date.strftime("%m/%d/%Y")
      range = date.beginning_of_day
      query(key, range)
    end
  end

  def primary_sources
    %w(Facebook Google Twitter).map do |source|
      query(source, source)
    end
  end

  def count_emails
    intersection.distinct(:email).count
  end

end
