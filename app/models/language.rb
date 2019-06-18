class Language < ApplicationRecord
  has_many :users

  def self.search(search)
    if search
      Language.select{ |language| language.name.downcase.include?(search.downcase) }
    else
      Language.all
    end
  end


end
