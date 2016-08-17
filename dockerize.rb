#!/usr/bin/env ruby

require 'rubygems'
require 'commander'

class Dockerize
  include Commander::Methods
  # include whatever modules you need


  def run
    program :name, 'Dockerize'
    program :version, '0.1.0'
    program :description, 'A script to add the necessary files to your application in order for it to use docker  and deploy easily'

    global_option('-t', '--test', 'Runs the dockerizing process into a test folder') { working_dir = "./test" }

    command :this do |c|
      c.syntax = 'dockerize this [options]'
      c.summary = 'Dockerizing...'
      c.description = 'Will initiate the dockerization process'
      c.example 'description', 'command example'
      c.option '--ruby', 'Adds the files for a ruby/rails project'
      c.option '--circleci', 'Adds the files for a circle ci supported project'
      c.action do |args, options|
        # Do something or c.when_called Dockerize::Commands::Dockerize
        @working_dir = "../"
        copy_files(options)
        set_project_info
      end
    end

    run!
  end

  private

  def set_project_info
    puts "Please enter the information for your application:\n"
    app_name = ask("Project Name:")
    ecr_host = ask("ECR Host:")
    version = ask("Version:")

    replace_values(app_name, ecr_host, version)
  end

  def replace_values(app_name, ecr_host, version)
    replace("sample_app", app_name, [
      "#{working_dir}/APP_NAME",
      "#{working_dir}/scripts/docker/prod-Dockerrun.aws.json",
      "#{working_dir}/scripts/docker/qa-Dockerrun.aws.json",
      "#{working_dir}/scripts/docker/bin/push.sh",
      "#{working_dir}/scripts/docker/bin/build.sh",
    ])
    replace("ECR_HOST", ecr_host, [
      "#{working_dir}/scripts/docker/prod-Dockerrun.aws.json",
      "#{working_dir}/scripts/docker/qa-Dockerrun.aws.json",
      "#{working_dir}/scripts/docker/bin/push.sh",
    ])
    replace("0.1.0", version, ["#{working_dir}/VERSION"])
  end

  def replace(before, after, files)
    files.each do |file|
      text = File.read(file)
      replace = text.gsub(/#{before}/, after)

      File.open(file, "w") {|file| file.puts replace}
    end
  end

  def copy_files(options)
    puts "Copying setup files...\n"
    require "pry"; binding.pry
    FileUtils.cp_r './files/general/.', working_dir
    options.default.keys.each do |opt|
      copy_specific_files(option: opt)
    end unless options.default.empty?
  end

  def copy_specific_files(option: opt)
    case option.to_s
    when "ruby"
      puts "Copying Ruby setup files"
      FileUtils.cp_r './files/ruby/scripts/.', "#{working_dir}/scripts"
    when "circleci"
      puts "Copying Circle CI setup files"
      FileUtils.cp_r './files/circle_ci/.', "#{working_dir}/."
    end
  end

  def working_dir(dir = "./")
    @working_dir ||= dir
  end
end

Dockerize.new.run if $0 == __FILE__
