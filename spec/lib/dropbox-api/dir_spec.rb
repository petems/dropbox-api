require "spec_helper"

describe Dropbox::API::Dir, vcr: true do

  before do
    @client = Dropbox::Spec.instance
    @dirname = "dir-spec-tests"
    @dir = @client.mkdir @dirname
  end

  describe "#copy" do

    it "copies the dir properly" do
      new_dirname = @dirname + "-copied"
      @dir.copy new_dirname
      @dir.path.should == new_dirname
    end

  end

  describe "#move" do

    it "moves the dir properly" do
      new_dirname = @dirname + "-copied"
      @dir.move new_dirname
      @dir.path.should == new_dirname
    end

  end

  describe "#destroy" do

    it "destroys the dir properly" do
      @dir.destroy
      @dir.is_deleted.should == true
    end

  end

end
