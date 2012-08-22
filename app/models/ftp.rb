module Ftp
  class User < ActiveRecord::Base
      self.establish_connection :ftp
      self.table_name = :users
  end

  def update_files

  end

end