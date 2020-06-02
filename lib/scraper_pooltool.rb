require 'nokogiri'
require 'watir'
require 'pry'

# html = open("https://pooltool.io/pool/c0285a4fe690d3aa9c0709f2f365e13f4ba83161e9219c8a10446aaa189e81d0/history")
# browser = Watir::Browser.new :chrome, headless: true
browser = Watir::Browser.new

browser.goto 'https://pooltool.io/'
# browser.goto 'https://itn.adapools.org/'
# Watir::Wait.until { browser.tbody().present? }
# Watir::Wait.until {browser.div(class: ['modal-modal-dialog', 'modal-lg']).visible? }
# browser.send_keys(:escape)
# # browser.button(text: 'X').when_present.click
# browser.select_list(name: 'DataTables_Table_0_length').option(value: '1000')

doc = Nokogiri::HTML.parse(browser.html)

File.write("log.html", doc)


puts doc.css(".text-no-wrap")[10]
