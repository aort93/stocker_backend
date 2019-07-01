require 'net/http'

class ArticlesController < ApplicationController
  def retrieve
    articles_url = URI.parse('https://cloud.iexapis.com/stable/stock/aapl/news/?token=pk_a8bb38e4ca7443d6a65134cd95b51606')
    articles_codes = Net::HTTP.get_response(articles_url ).body
    articles_codes_arr = JSON.parse(articles_codes)

    landing = []
    news_arr = articles_codes_arr

    news_arr.map do |article|
      obj = {}
      obj['headline'] = article['headline']
      obj['image'] = article['image']
      obj['summary'] = article['summary']
      obj['link'] =  article['url']
      # obj['date'] = article['datetime'].slice(0, 10)

      landing.push(obj)
    end

    render :json => landing
  end


end
