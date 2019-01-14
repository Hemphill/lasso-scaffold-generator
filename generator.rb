require 'thor'
require 'action_view'
require 'active_support'
require 'active_support/core_ext'

class ScaffoldGeneratorCLI < Thor
  include Thor::Actions
  include ActionView::Helpers::TextHelper
  #include ActiveSupport::Inflector

  attr_accessor :name
  class_option :verbose, type: :boolean, default: true

  def self.source_root
    File.dirname(__FILE__)
  end

  

  # desc "hello NAME", "say hello to NAME"
  # options :from => :required, :yell => :boolean
  # def hello(name, from=nil)
  #   puts "from: #{from}" if from
  #   puts "Hello #{name}"
  # end
  
  desc 'scaffold NAME (e.g. `digital_coupons`)', 'Creates a file structure & base set of files for Lasso Modules.'
  def scaffold(name)
    set_supporting_data(name)
    directory "source_files", "output/#{@plural_name}", :exclude_pattern => /.DS_Store/
    #template 'source_files/README.md.tt', "output/#{@plural_name}/README.md"
  end

  # desc 'singular_name', 'Used for creating custom file names.'
  # Must be a public method or the directory method won't have access to it.
  def singular_name
    @singular_name
  end

  # desc 'plural_name', 'Used for creating custom file names.'
  # Must be a public method or the directory method won't have access to it.
  def plural_name
    @plural_name
  end
  
  private
  
  def set_supporting_data(name)
    @singular_name = name
    @plural_name = ActiveSupport::Inflector.pluralize(name)
  end
  
end

ScaffoldGeneratorCLI.start(ARGV)
