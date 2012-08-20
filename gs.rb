#! /usr/bin/env ruby
require 'rubygems'
require 'google_drive'

GS='0Aq-daXyC3OSSdFhqY1lORFdHSkdZMjJraTBKa0thQUE'

def gs_init(name)
  #$gs = GoogleDrive.saved_session
  $gs = GoogleDrive::Session.new({:wise => open('.ssh_tok').gets.chomp}, nil)
  $ss = $gs.spreadsheet_by_key(GS)
  ws = name + ' ' + Time.now.strftime("%Y-%m")
  puts "Spreadsheet: #{$ss.title} / #{ws}"
  $sheet = $ss.worksheet_by_title(ws)
  $sheet ||= $ss.add_worksheet(ws)
end

def append_row(gs_session, gs_sheet, row_hash={})
  xml = '<entry xmlns="http://www.w3.org/2005/Atom" xmlns:gsx="http://schemas.google.com/spreadsheets/2006/extended">'
  row_hash.each_pair do |k, v|
    xml << "<gsx:#{k}>#{v}</gsx:#{k}>"
  end
  xml << "</entry>"
  gs_session.request(:post, gs_sheet.list_feed_url, :data => xml)
end
