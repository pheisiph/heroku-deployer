module Heroku::Command
  
  class Deploy < BaseWithApp
    
    def index
      envs = Heroku::Command::Base.new.send(:git_remotes)
      
      unless envs.empty?
        puts "Specify which environment you want to deploy to: "
        envs.each do |env|
          puts "* #{env}"
        end
        puts "Example: heroku deploy:#{envs.first}"
      else
        puts "No heroku remote repositories defined."
      end
    end
    
    Heroku::Command::Base.new.send(:git_remotes).each do |env, app|
      unless instance_methods.include?(env.to_sym)
        define_method(env) do
          deploy!(env)
        end
        
        help = {
          :summary => " Deploys #{env} to heroku",
          :description => " Turns on maintenance mode, pushes the local "\
               "branch #{env} to heroku and then turns off maintenance mode "\
               "unless the flags -n or -m are provided."
        }
        help[:help] = [
          "deploy:#{env}", 
          help[:summary], 
          help[:description]
        ].join("\n\n")
      end
    end
    
    private
    
    def deploy!(env)
      skip_question    = !(args & %w{-y --yes --skip-question}).empty?
      keep_maintenance = !(args & %w{-m --maintenance-on}).empty?
      no_maintenance   = !(args & %w{-n --no-maintenance}).empty?
      
      display "Deploy this app to #{env}?" unless skip_question

      if skip_question || confirm
        run_command "maintenance:on", ["--remote", env] unless no_maintenance
        
        git_checkout env unless git_current_branch?(env)
        
        if git_push(env, env)
          if !keep_maintenance || !no_maintenance
            run_command "maintenance:off", ["--remote", env] 
          end
        end
      end
    end
    
    def git_push(local_branch, remote, use_remote_master=true)
      remote_branch = use_remote_master ? ":master" : ""
      command = "git push #{remote} #{local_branch}#{remote_branch}"
      display command
      puts %x{ #{command} }
      $?.success?
    end
    
    def git_current_branch?(branch)
      git_current_branch == branch
    end
    
    def git_current_branch
      %x{ git branch -a }.split("\n").detect { |b| b =~ /^\*/ }[2..-1]
    end
    
    def git_checkout(branch)
      command = "git checkout #{branch}"
      %x{ #{command} }
    end
    
    
  end
end