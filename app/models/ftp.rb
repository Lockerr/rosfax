module Ftp
  class User < ActiveRecord::Base
      self.establish_connection :ftp
      set_table_name :users
  end

  def update_files

  end

end