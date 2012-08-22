rails_root = '/home/perekup/rosfax/current'

2.times do |num|
  God.watch do |w|
    w.name     = "dj-#{num}"
    w.group    = 'dj'
    w.interval = 30.seconds
    w.start    = "cd #{rails_root} && rvm r328 do rake jobs:work RAILS_ENV=production"
    w.log      = '/home/perekup/rosfax/shared/log/god_jobs.log'

#    w.uid = 'rosfax'
#    w.gid = 'rosfax'

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 300.megabytes
        c.times = 2
      end
    end


    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end