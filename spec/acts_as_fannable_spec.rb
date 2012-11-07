require File.dirname(__FILE__) + '/spec_helper'

ActiveRecord::Migration.verbose = false
TEST_DATABASE_FILE = File.join(File.dirname(__FILE__), '..', 'bigboy.sqlite3')
File.unlink(TEST_DATABASE_FILE) if File.exist?(TEST_DATABASE_FILE)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => TEST_DATABASE_FILE)
ActiveRecord::Schema.define(:version => 0) do
  create_table :fans do |t|
    t.integer :fannable_id,:default => 0, :null => false
    t.string :fannable_type,:default => "", :null => false
    t.integer :user_id,:default => 0, :null => false
    t.timestamps
  end
  create_table :users do |t|
    t.string :permalink, :default => "", :null => false
    t.timestamps
  end
  create_table :products do |t|
    t.string :name, :default => "",:null => false
    t.timestamps
  end
end

module FanSpecHelper
  def valid_fan_attributes
    {  :fannable_type => 'Product',
       :fannable_id => 1,
       :user_id => 1,
       :created_at=>Time.now }
  end
    def valid_product_attributes
    {  :name => 'Computer',
       :created_at=>Time.now }
  end
end



describe HeurionConsulting::Acts::Fannable do
  include FanSpecHelper
  before(:all) do
      @fan = Fan.new
      @user = User.create(:permalink => "heurion")
      @product = Product.create(:name => "Computer")
      @fan.user_id = @user.id
      @product.add_fan(@fan)
  end

  it "should be fan of" do
    @product.is_fan?(@user).should be_true
  end

  it "should relate to user" do
    Fan.reflect_on_association(:user).should_not be_nil
  end

  it "should relate to product" do
    Product.acts_as_fannable.should_not be_nil
  end

  it "should relate to fannable" do
    Fan.reflect_on_association(:fannable).should_not be_nil
  end

  it "should should not be valid without something to related to" do
    @fan = Fan.new
    @fan.attributes = valid_fan_attributes.except(:fannable_id, :fannable_type, :user_id)
    @fan.should_not be_valid
    @fan.errors.get(:fannable_id).should eql(nil)
    @fan.fannable_id = 1
    @fan.should_not be_valid
    @fan.errors.get(:user_id).should eql(nil)
    @fan.fannable_id = 1
    @fan.should_not be_valid
    @fan.errors.get(:fannable_type).should eql(["can't be blank"])
    @fan.fannable_type = "Product"
    @fan.should be_valid
  end

  it "should be able to search for fans" do
    @fan = Fan.first
     fan = Product.find_fans_for(@product)
     fan.should_not be_nil
     fan.include?(@fan).should be_true
  end

  it "should be able to search for users based on fannable_type" do
    @fan = Fan.first
     fan = Product.find_fannables_by_user(@user)
     fan.should_not be_nil
     fan.include?(@fan).should be_true
  end

  it "should not respond to user" do
    User.should_not respond_to :find_fans_for
  end

  it "should not respond to product" do
    Product.should respond_to :find_fans_for
  end

end

describe Product do
  it "should have many fans" do
    should have_many(:fans)
  end
end

describe User do
  it "should not have any fans" do
    should_not have_many(:fans)
  end
end

describe Fan do
  it "should belong to user" do
    should belong_to(:user)
  end
end

