# encoding: utf-8
require 'spec_helper'
require "logstash/filters/date_breakout"

describe LogStash::Filters::DateBreakout do
  describe "Parse epoch and work out the dates, from a defined field" do
    let(:config) do <<-CONFIG
      filter {
        date_breakout {
          source => "random_field"
          prefix => "a_"
        }
      }
    CONFIG
    end

    epoch = LogStash::Timestamp.at(0)

    sample("random_field" => epoch) do
      expect(subject['a_.dayOfYear']).to eq(1)
      expect(subject['a_.year']).to eq(1970)
      expect(subject['a_.monthOfYear']).to eq(1)
      expect(subject['a_.dayOfMonth']).to eq(1)
      expect(subject['a_.weekOfYear']).to eq(1)
      expect(subject['a_.dayOfWeek']).to eq(4)
      expect(subject['a_.dayOfYear']).to eq(1)
    end
  end

  describe "Parse epoch and work out the dates from the @timestamp field" do
    let(:config) do <<-CONFIG
      filter {
        date_breakout {
        }
      }
    CONFIG
    end

    epoch = LogStash::Timestamp.at(0)

    sample("@timestamp" => epoch) do
      expect(subject['@timestamp.dayOfYear']).to eq(1)
      expect(subject['@timestamp.year']).to eq(1970)
      expect(subject['@timestamp.monthOfYear']).to eq(1)
      expect(subject['@timestamp.dayOfMonth']).to eq(1)
      expect(subject['@timestamp.weekOfYear']).to eq(1)
      expect(subject['@timestamp.dayOfWeek']).to eq(4)
      expect(subject['@timestamp.dayOfYear']).to eq(1)
    end
  end

  describe "Parse a non date and confirm that failure tag is set" do
    let(:config) do <<-CONFIG
      filter {
        date_breakout {
          source => "random_field"
        }
      }
    CONFIG
    end

    epoch = 0

    sample("random_field" => epoch) do
      insist { subject["tags"] }.include? "_datebreakoutparsefailure"
    end
  end
end
