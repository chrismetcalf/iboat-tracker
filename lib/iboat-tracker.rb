# require 'rubygems'
# gem 'httparty'
require '/Users/krezel/src/github.com/httparty/lib/httparty'
require File.dirname(__FILE__) + '/iboat_tracker/data'
 
class IBoatTracker
  include HTTParty
  #base_uri "http://maps.iboattrack.com/m/r/"
  
  def initialize(race)
    @race = race
  end
  
  def boats(time = "now")
    self.class.get("http://maps.iboattrack.com/m/r/getVessels?r=#{@race}&t=#{time}")
  end
  
  
  def weather
    @weather ||= self.class.get("/ig/api", :query => {:weather => @zip}, :format => :xml)['xml_api_reply']['weather']
  end
  
  def forecast_information
    @forecast_information ||= ForecastInformation.new(weather['forecast_information'])
  end
  
  def current_conditions
    @current_conditions ||= CurrentConditions.new(weather['current_conditions'])
  end
  
  def forecast_conditions
    @forecast_conditions ||= weather['forecast_conditions'].map { |cond| ForecastCondition.new(cond) }
  end
end