# encoding: utf-8
require "spec_helper"
require "tempfile"

describe Dropbox::API::Client, vcr: true do

  before do
    @client = Dropbox::Spec.instance
  end

  describe "#initialize" do

    it "has a handle to the connection" do
      @client.connection.should be_an_instance_of(Dropbox::API::Connection)
    end

  end

  describe "#account" do
    
    it "retrieves the account object" do
      response = @client.account
      response.should be_an_instance_of(Dropbox::API::Object)
    end

  end

  describe "#find" do

    it "returns a single file" do
      pending
      # response = @client.find(@filename)
      # response.path.should == @file.path
      # response.should be_an_instance_of(Dropbox::API::File)
    end

    it "returns a single directory" do
      pending
      # response = @client.find(@dirname)
      # response.path.should == @dir.path
      # response.should be_an_instance_of(Dropbox::API::Dir)
    end

  end

  describe "#ls" do

    context "no value" do

      it "returns an array of files and dirs" do
        result = @client.ls
        result.should be_an_instance_of(Array)
      end
    end

    context "a single file" do
      it "returns a single item array of if we ls a file" do
        result     = @client.ls('foo.txt')
        first_file = result.detect { |f| f.class == Dropbox::API::File }
        result     = @client.ls first_file.path
        result.should be_an_instance_of(Array)
      end
    end

    context "a directory" do
      it "returns an item array of directory contents" do
        result     = @client.ls('foo.txt')
        first_file = result.detect { |f| f.class == Dropbox::API::File }
        result     = @client.ls first_file.path
        result.should be_an_instance_of(Array)
      end
    end

  end

  describe "#mkdir" do

    it "returns an array of files and dirs" do
      dirname  = "awesome-tests"
      response = @client.mkdir dirname
      response.path.should == dirname
      response.should be_an_instance_of(Dropbox::API::Dir)
    end

    it "creates dirs with tricky characters" do
      dirname  = "awesome-tests-|!@\#$%^&*{b}[].;'.,<>?:"
      response = @client.mkdir dirname
      response.path.should == dirname.gsub(/[\\\:\?\*\<\>\"\|]+/, '')
      response.should be_an_instance_of(Dropbox::API::Dir)
    end

    it "creates dirs with utf8 characters" do
      dirname  = "awesome-tests-łółą"
      response = @client.mkdir dirname
      response.path.should == dirname
      response.should be_an_instance_of(Dropbox::API::Dir)
    end

  end

  describe "#upload" do

    context "a simple file" do
      it "is uploaded" do
        filename = "test.txt"
        response = @client.upload filename, "Some file"
        response.path.should == filename
        response.bytes.should == 9
      end
    end

    context "a file with tricky characters" do
      it "is uploaded" do
        filename = "test ,|!@\#$%^&*{b}[].;'.,<>?:.txt"
        response = @client.upload filename, "Some file"
        response.path.should == filename
        response.bytes.should == 9
      end
    end

    context "a file with utf8" do
      it "is uploaded" do
        filename = "test łołąó.txt"
        response = @client.upload filename, "Some file"
        response.path.should == filename
        response.bytes.should == 9
      end      
    end

  end

  describe "#search" do

    let(:term) { "foo.txt" }

    after do
      @response.size.should == 1
      @response.first.class.should == Dropbox::API::File
    end

    context "with path" do    
      it "finds a file" do 
        @response = @client.search term, :path => "awesome-tests"
      end
    end

    context "path with leading slash" do
      it "finds the file" do
        @response = @client.search term, :path => "/awesome-tests"
      end

    end

    context "no path given" do
      it "finds the file if in root" do
        @response = @client.search term
      end
    end

  end

  describe "#copy_from_copy_ref" do

    it "copies a file from a copy_ref" do
      pending
      # filename = "test/searchable-test-#{Dropbox::Spec.namespace}.txt"
      # @client.upload filename, "Some file"
      # response = @client.search "searchable-test-#{Dropbox::Spec.namespace}", :path => 'test'
      # ref = response.first.copy_ref['copy_ref']
      # @client.copy_from_copy_ref ref, "#{filename}.copied"
      # response = @client.search "searchable-test-#{Dropbox::Spec.namespace}.txt.copied", :path => 'test'
      # response.size.should == 1
      # response.first.class.should == Dropbox::API::File
    end

  end

  describe "#download" do

    context "a file" do
      it "downloads a file" do
        file = @client.download "awesome-tests/foo.txt"
        file.should == "Some file"
      end
    end

    context "a non-existant file" do
      it "raises a 404" do
        expect { @client.download "awesome-tests/no.txt"}.to raise_error(Dropbox::API::Error::NotFound)
      end
    end

  end

  describe "#delta" do
    it "returns a cursor and list of files" do
      pending
      # filename = "#{Dropbox::Spec.test_dir}/delta-test-#{Dropbox::Spec.namespace}.txt"
      # @client.upload filename, 'Some file'
      # response = @client.delta
      # cursor, files = response.cursor, response.entries
      # cursor.should be_an_instance_of(String)
      # files.should be_an_instance_of(Array)
      # files.last.should be_an_instance_of(Dropbox::API::File)
    end

    it "returns the files that have changed since the cursor was made" do
      pending
      # filename = "#{Dropbox::Spec.test_dir}/delta-test-#{Dropbox::Spec.namespace}.txt"
      # delete_filename = "#{Dropbox::Spec.test_dir}/delta-test-delete-#{Dropbox::Spec.namespace}.txt"
      # @client.upload delete_filename, 'Some file'
      # response = @client.delta
      # cursor, files = response.cursor, response.entries
      # files.last.path.should == delete_filename
      # files.last.destroy
      # @client.upload filename, 'Another file'
      # response = @client.delta(cursor)
      # cursor, files = response.cursor, response.entries
      # files.length.should == 2
      # files.first.is_deleted.should == true
      # files.first.path.should == delete_filename
      # files.last.path.should == filename
    end
  end

end
