class Link < ApplicationRecord
  validates :short_url, uniqueness: true

  before_save :check_validity
  after_create :generate_short_url

  def equal_params?(other)
    if self.long_url.include? '?'
      params = self.long_url.split('?').last.split('&').map do |e|
        e.split('=')
      end.to_h.with_indifferent_access
    end

    if other.long_url.include? '?'
      other_params = other.long_url.split('?').last.split('&').map do |e|
        e.split('=')
      end.to_h.with_indifferent_access
    end

    params == other_params
  end

  private

  def check_validity
    url_path = extract_domain_name(self.long_url)
    url_params = self.long_url.split('?').last if self.long_url.include? '?'

    if url_params.present?
      formatted_url = "http://www.#{url_path}?#{url_params}"
    else
      formatted_url = "http://www.#{url_path}"
    end

    links = Link.all.to_a.select do |l|
      (l.long_url.include? url_path ) && !self.eql?(l)
    end

    if links.blank?
      self.long_url = formatted_url
      self.id = self.class.maximum(:id).to_i.next
    else
      duplicate = links.select { |l| self.equal_params?(l) }

      if duplicate.present?
        self.errors.add(:duplicate, duplicate.first.short_url)
        throw :abort, duplicate.first.short_url
      end

      self.long_url = formatted_url
      self.id = self.class.maximum(:id).to_i.next
    end
  end

  def generate_short_url
    update_column :short_url, SecureRandom.hex(3)
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def extract_domain_name(url)
    if url.include? "://"
      domain = url.split('/')[2]
      path = url.split('/')[3..-1].join('/').split('?').first if url.count('/') > 2
    else
      domain = url.split('/')[0]
      path = url.split('/')[1..-1].join('/').split('?').first if url.count('/') > 0
    end

    # find & remove port number
    domain = domain.split(':')[0]
    # find & remove "?"
    domain = domain.split('?')[0]

    split = domain.split('.')
    len = split.length

    if (len > 2)
      domain = split[len - 2] + '.' + split[len - 1]
      # //check to see if it's using a Country Code Top Level Domain (ccTLD) (i.e. ".co.in")
      if (split[len - 2].length == 2 && split[len - 1].length == 2)
        # //this is using a ccTLD
        domain = split[len - 3] + '.' + domain
      end
    end

    domain = "#{domain}/#{path}" if path.present?
    domain
  end
end
