require 'rainbow'
require_relative 'check_input/check_haml_data'

class CheckInput
  def initialize(verbose = true)
    @verbose = verbose
  end

  def file(filepath)
    @filepath = filepath
    self
  end

  def verbose(verbose)
    @verbose = verbose
    self
  end

  def check
    # Check HAML file syntax
    exist = check_file_exist
    return false unless exist
    check_file_content
  end

  private

  def check_file_exist
    if @filepath.nil?
      puts Rainbow("[ERROR] Can't check nil filename").red.bright
      return false
    end
    unless File.exist? @filepath
      puts Rainbow("[ERROR] File not found!: #{@filepath}").red.bright if @verbose
      return false
    end
    unless File.extname(@filepath) == '.haml'
      puts Rainbow("[ERROR] Check require's HAML file!").red.bright if @verbose
      return false
    end
    true
  end

  def check_file_content
    data = CheckHamlData.new(@filepath)
    data.check
    data.show_errors if @verbose
    data.ok?
  end
end
