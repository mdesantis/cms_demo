class Page < ActiveRecord::Base

  HOME      = 0b01
  PUBLISHED = 0b10

  scope :home          , -> { where("#{status_quoted} & ? = ?", HOME, HOME)            }
  scope :published     , -> { where("#{status_quoted} & ? = ?" , PUBLISHED, PUBLISHED) }
  scope :not_home      , -> { where("#{status_quoted} & ? != ?", HOME, HOME)           }
  scope :not_published , -> { where("#{status_quoted} & ? != ?", PUBLISHED, PUBLISHED) }

  before_save :publish_home
  after_save  :switch_home

  validates_numericality_of :status, greater_than_or_equal_to: 0

  def self.status_quoted
    connection.quote_column_name 'status'
  end

  def home
    status & HOME == HOME
  end

  def published
    status & PUBLISHED == PUBLISHED
  end

  def home=(home)
    self.status = (home && home != 0 && home != '0' ? status | HOME : status & ~HOME)
  end

  def published=(published)
    self.status = (published && published != 0 && published != '0' ? status | PUBLISHED : status & ~PUBLISHED)
  end

  def status
    read_attribute(:status) || 0
  end

  def status=(status)
    write_attribute :status, (status || 0)
  end

  def to_param
    "#{id}-#{title.to_s.parameterize}"
  end

  private

  def switch_home
    self.class.home.where('id != ?', id).update_all(["#{self.class.status_quoted} = #{self.class.status_quoted} & ~?", HOME]) if home
  end

  def publish_home
    self.published = true if home
  end

end
