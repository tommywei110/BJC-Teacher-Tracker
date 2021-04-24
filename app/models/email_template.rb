# == Schema Information
#
# Table name: email_templates
#
#  id         :bigint           not null, primary key
#  body       :text
#  format     :string
#  handler    :string
#  locale     :string
#  partial    :boolean
#  path       :string
#  subject    :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EmailTemplate < ApplicationRecord
  store_templates
end
