# class Ftp < ActiveRecord::Base
#     self.establish_connection :ftp
#     set_table_name :user



# end



 module Ftp
   class User < ActiveRecord::Base
       self.establish_connection :ftp
       set_table_name :user
   end

     def foo
       'bbbbaaaaaaaaaaaar!!!!!!!1111oneone'
       end

   end
