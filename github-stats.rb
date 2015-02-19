require 'pry'
require 'httparty'
require 'colorize'

#NAME = "TIY-DC-ROR-2015-Jan"

def get_token
  puts "Enter authorization token:"
  gets.chomp
end

TOKEN = ENV['GITHUB_TOKEN'] || get_token

class Github
  include HTTParty
  base_uri "https://api.github.com"

  def initialize
    @headers = {
      "Authorization" => "token #{TOKEN}",
      "User-Agent"    => "classbot"
    }  
  end

  def get_members
    puts "Enter github organization:"
    org = gets.chomp
    Github.get("/orgs/#{org}/members", headers: @headers)
  end

  def contributions
   
    members = get_members
    puts "\t\tAdditions\tDeletions\tChanges".underline
    members.each do |member|
      additions = 0
      deletions = 0
      changes = 0
      begin
      name = member["login"]
      member_repos = Github.get("/users/#{name}/repos", headers: @headers)
      member_repos.each do |repo|
        repo_stats = Github.get("/repos/#{name}/#{repo["name"]}/stats/contributors", headers: @headers)
        weeks = repo_stats[0]["weeks"]
        weeks.each do |week|
          additions += week["a"]
          deletions += week["d"]
          changes += week["c"]
        end
      end
      print "#{name}"
      if name.length <=7
        print "\t"
      end
      puts "\t#{additions}\t\t#{deletions}\t\t#{changes}"
      rescue
    end
    end
  end
end

api = Github.new
y = api.contributions















