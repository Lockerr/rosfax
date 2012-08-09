# encoding: utf-8
  unless self.private_methods.include? 'irb_binding'
    task_scheduler = Rufus::Scheduler.start_new(:frequency => 0.5)

    task_scheduler.every('1m') do
      Asset.process_ftp
    end


  end

