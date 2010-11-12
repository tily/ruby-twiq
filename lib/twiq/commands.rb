
module Twiq
  module Commands
    extend self
    extend OAuth::CLI::Twitter

    CONSUMER_KEY = '9gu06q0SOcJLOwKpAeaClA'
    CONSUMER_SECRET = 'K8Kb6JpfRkzjQl4IRn2CWbCL67rEtO0mSeoqKCQdSFQ'

    attr_accessor :stdout, :stdin

    def enq(args)
      case args.size
      when 0
        raise Error, 'arguments required (at least 1)'
      when 1
        while text = stdin.gets
          Statuses.insert(:user => args[0], :text => text)
        end
      else
        Statuses.insert(:user => args[0], :text => args[1])
      end
    end

    def deq(args)
      raise Error, 'user not specified.' if args.size == 0
      s = Statuses.filter(:user => args[0]).first
      Statuses.filter(:id => s[:id]).delete
      at = get_access_token(CONSUMER_KEY, CONSUMER_SECRET, :pit => 'twiq-' + s[:user])
      at.post('/statuses/update.json', 'status' => s[:text])
    end

    def list(args)
      statuses = args.size > 0 ? Statuses.filter(:user => args[0]) : Statuses.all
      stdout.puts "id\tuser\ttext"
      statuses.each do |s|
        stdout.puts "#{s[:id]}\t#{s[:user]}\t#{s[:text]}"
      end
    end

    def clear(args)
      if args.size == 0
        Statuses.delete
      else
        args.each do |arg|
          case arg
          when String  then key = :user
          when Integer then key = :id
          else next
          end
          Statuses[key => arg].delete
        end
      end
    end
  end
end
