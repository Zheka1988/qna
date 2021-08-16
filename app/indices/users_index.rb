ThinkingSphinx::Index.define :user, with: :active_record do
  #fileds
  indexes email, sortable: true

end