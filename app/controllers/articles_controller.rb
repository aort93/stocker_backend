require 'net/http'

class ArticlesController < ApplicationController



  def retrieve
    articles_url = URI.parse('https://api.iextrading.com/1.0/stock/market/news/first/5')
    articles_codes = Net::HTTP.get_response(articles_url ).body
    articles_codes_arr = JSON.parse(articles_codes)
    landing = []

    articles_codes_arr.map do |article|
      obj = {}
      obj['headline'] = article['headline']
      obj['image'] = article['image']
      obj['summary'] = article['summary']
      obj['link'] =  article['url']
      obj['date'] = article['datetime'].slice(0, 10)

      landing.push(obj)
    end

    render :json => landing
  end


end
