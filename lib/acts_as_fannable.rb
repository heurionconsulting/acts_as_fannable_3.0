require "acts_as_fannable/version"
require "active_record"
module HeurionConsulting
  module Acts
    module Fannable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_fannable
          has_many :fans, :as => :fannable, :dependent => :destroy, :order => 'created_at ASC'
          include HeurionConsulting::Acts::Fannable::InstanceMethods
          extend HeurionConsulting::Acts::Fannable::SingletonMethods
        end
      end

      # This module contains class methods
      module SingletonMethods
        # Helper method to lookup for fans of a model
        def find_fans_for(obj)
          fanobject = self.base_class.name
          Fan.where(:fannable_id => obj.id , :fannable_type => fanobject).order("created_at DESC")
        end

        def find_fannables_by_user(user)
          fanobject = self.base_class.name
          Fan.where(:user_id => user.id , :fannable_type => fanobject).order("created_at DESC")
        end

      end

      # This module contains instance methods
      module InstanceMethods
        # Helper method to sort fan by date
        def fans_by_recent
          Fan.where(:fannable_id => id ,:fannable_type => self.class.name).order("created_at DESC")
        end

        # Helper method that defaults the submitted time.
        def add_fan(fan)
          fans << fan
        end

        def is_fan?(user)
         fan = Fan.where(:user_id => user.id,:fannable_type => self.class.name,:fannable_id => self.id)
          !(fan.nil?)
        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, HeurionConsulting::Acts::Fannable)

