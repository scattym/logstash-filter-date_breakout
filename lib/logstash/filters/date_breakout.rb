# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "logstash/timestamp"

# This example filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::DateBreakout < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   date_breakout {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "date_breakout"
  
  # Replace the message with this value.
  config :source, :validate => :string, :required => true, :default => "@timestamp"
  #config :target, :validate => :string
  config :prefix, :validate => :string, :default => '@timestamp'
  # Append values to the `tags` field when there has been no
  # successful match
  config :tag_on_failure, :validate => :array, :default => ["_datebreakoutparsefailure"]
  
  public
  def register
    # Add instance variables 
  end # def register

  public
  def filter(event)
    begin
      timestamp = event[@source]
      event[@prefix + ":year"] = Integer(event[@source].time.strftime("%Y").to_i)
      event[@prefix + ":monthOfYear"] = Integer(event[@source].time.strftime("%m").to_i)
      event[@prefix + ":dayOfMonth"] = Integer(event[@source].time.strftime("%d").to_i)
      event[@prefix + ":weekOfYear"] = Integer(event[@source].time.strftime("%V").to_i)
      event[@prefix + ":dayOfWeek"] = Integer(event[@source].time.strftime("%w").to_i)
      event[@prefix + ":dayOfYear"] = Integer(event[@source].time.strftime("%j").to_i)
      event[@prefix + ":hourOfDay"] = Integer(event[@source].time.strftime("%k").to_i)
      #event[@prefix + ".ddMONyy"] = event[@sourch].time.strftime "%-d%^b%y"

    rescue Exception => e
      @logger.warn("Failed to breakout the date from field", :source => source,
                   :exception => e.message,
                   )
      # Tag this event if we can't parse it. We can use this later to
      # reparse+reindex logs if we improve the patterns given.
      @tag_on_failure.each do |tag|
        event["tags"] ||= []
        event["tags"] << tag unless event["tags"].include?(tag)
      end
    end
      

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::DateBreakout
