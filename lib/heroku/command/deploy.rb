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
          :description => " Turns on maintenance mode, pushes the local branch #{env} to heroku and then turns off maintenance mode"
        }
        help[:help] = ["deploy:#{env}", help[:summary], help[:description]].join("\n\n")
      end
    end
    
    private
    
    def deploy!(env)
      
      display "Deploy this app to #{env}?"
      
      if confirm
        run_command "maintenance:on", ["--remote", env]
        
        git_checkout env unless git_current_branch?(env)
        
        if git_push(env, env)
          run_command "maintenance:off", ["--remote", env]
        end
        
      end
    end
    
    def git_push(local_branch, remote, use_remote_master=true)
      remote_branch = use_remote_master ? ":master" : ""
      command = "git push #{remote} #{local_branch}#{remote_branch}"
      display command
      puts %x{ command }
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
      %x{ command }
    end
    
    
  end
end