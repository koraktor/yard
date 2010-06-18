require File.dirname(__FILE__) + '/../spec_helper'

describe YARD::CLI::CommandParser do
  describe '#run' do
    before do
      @cmd = CLI::CommandParser.new
    end
    
    it "should show help if --help is provided" do
      @cmd.should_receive(:puts).ordered.with(/^Usage:/)
      @cmd.should_receive(:puts).at_least(1).times
      @cmd.run *%w( --help )
    end
    
    it "should use default command if first argument is a switch" do
      command = mock(:command)
      command.should_receive(:run).with('--a', 'b', 'c')
      @cmd.commands[:foo] = command
      @cmd.class.default_command = :foo
      @cmd.run *%w( --a b c )
    end
    
    it "should use default command if no arguments are provided" do
      command = mock(:command)
      command.should_receive(:run)
      @cmd.commands[:foo] = command
      @cmd.class.default_command = :foo
      @cmd.run
    end
    
    it "should list commands if command is not found" do
      @cmd.should_receive(:list_commands)
      @cmd.run *%w( unknown_command --args )
    end
  end
end