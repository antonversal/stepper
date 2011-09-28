ActiveRecord::Schema.define(:version => 20110928102949) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "my_step"
    t.integer  "code"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end