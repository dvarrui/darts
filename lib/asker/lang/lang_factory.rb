# frozen_string_literal: true

require "singleton"
require_relative "lang"
require_relative "../application"
require_relative "../logger"

##
# * Read all language codes defined into configuration file
# * and load every language
# Lang objects are reused
class LangFactory
  include Singleton

  ##
  # Read all language codes from configuration file and load every language
  def initialize
    @default = Application.instance.config['languages']['default'].downcase
    @langs = {}
    Application.instance.config['languages'].each_pair do |key, value|
      code = key.downcase
      next if code == 'default'

      @langs[code] = Lang.new(code) if value.downcase == 'yes'
    end
  end

  ##
  # Return Lang object associated to code
  # @param code (String)
  def get(code)
    return @langs[code] unless @langs[code].nil?

    Logger.error "LangFactory: Unkown Lang code: #{code}"
    Logger.error "             (a) Change input file code lang"
    Logger.error "             (b) Revise configuration from asker.ini"
    Logger.error "             (c) Revise template files"
    exit 1
  end

  def default
    get(@default)
  end
end
