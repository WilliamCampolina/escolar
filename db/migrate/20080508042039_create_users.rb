class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      t.column :state, :string, :null => :no, :default => 'passive'
      t.column :deleted_at, :datetime
    end

    User.create!(:email => "marcos.neves@gmail.com", :password => "1234", :password_confirmation => "1234")
  end

  def self.down
    drop_table "users"
  end
end
