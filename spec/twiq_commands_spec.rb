require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Twiq

describe Commands do
  describe ".enq" do
    it "raise error when it receives no argument" do
      lambda { Commands.enq }.should raise_error(Twiq::Error, 'arguments required (at least 1)')
    end

    it "takes the argument as user and reads statuses from stdin when it receives just one argument" do
      user = 'dummy user'
      expect_texts = ['dummy text 1', 'dummy text 2', 'dummy text 3']

      stdin = mock('stdin')
      expect_texts.each do |text|
        stdin.should_receive(:gets).and_return(text)
        Statuses.should_receive(:insert).with(:user => user, :text => text)
      end
      stdin.should_receive(:gets).and_return(nil)

      Commands.stdin = stdin
      Commands.enq(user)
    end

    it "takes the first argument as user and the second as when it receives two arguments" do
      user, text = 'dummy user', 'dummy text'
      Statuses.should_receive(:insert).with(:user => user, :text => text)
      Commands.enq(user, text)
    end
  end

  describe ".deq" do
    it "raise error when it receives no argument" do
      lambda { Commands.deq }.should raise_error(Twiq::Error, 'user not specified.')
    end
    it "dequeue first status of the user and post it to twitter" do
      id, user, text = 1, 'dummy user', 'dummy text'

      Statuses.should_receive(:filter).with(:user => user).and_return(
        mock.tap {|m| m.should_receive(:first).and_return(:id => id, :user => user, :text => text) }
      )
      Statuses.should_receive(:filter).with(:id => id).and_return(
        mock.tap {|m| m.should_receive(:delete) }
      )
      Commands.should_receive(:get_access_token).with(
        Commands::CONSUMER_KEY, Commands::CONSUMER_SECRET, :pit => 'twiq-' + user
      ).and_return(
        mock.tap {|m| m.should_receive(:post).with('/statuses/update.json', 'status' => text) }
      )

      Commands.deq(user)
    end
  end

  describe ".list" do
    before do
      @statuses = [
        {:id => 1, :user => 'dummy_user_1', :text => 'dummy text 1'},
        {:id => 2, :user => 'dummy_user_2', :text => 'dummy text 2'},
        {:id => 3, :user => 'dummy_user_3', :text => 'dummy text 3'}
      ]
      @stdout = mock.tap {|m| m.should_receive(:puts).with("id\tuser\ttext") }
      @statuses.each do |s|
        @stdout.should_receive(:puts).with("#{s[:id]}\t#{s[:user]}\t#{s[:text]}")
      end
      Commands.stdout = @stdout
    end

    it "lists all the statuses when it receives no arguments" do
      Statuses.should_receive(:all).and_return(@statuses)
      Commands.list
    end

    it "lists the statuses of the specified user when it receives one argument" do
      user = 'dummy user'
      Statuses.should_receive(:filter).with(:user => user).and_return(@statuses)
      Commands.list(user) 
    end
  end

  describe ".clear" do
    it "deletes all the statsuses when it receives no arguments" do
      Statuses.should_receive(:delete)
      Commands.clear
    end

    it "deletes the statsuses of the specified users or ids when it receives one argument" do
      args = [216, {}, 'dummy_user']
      Statuses.should_receive(:filter).with(:id => 216).and_return(
        mock.tap {|m| m.should_receive(:delete) }
      )
      Statuses.should_receive(:filter).with(:user => 'dummy_user').and_return(
        mock.tap {|m| m.should_receive(:delete) }
      )
      Commands.clear(*args)
    end
  end
end
