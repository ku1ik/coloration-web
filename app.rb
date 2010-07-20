require "sinatra"
require "coloration"

get "/" do
  erb :index
end

post "/" do
  if file = params[:file]
    ext = File.extname(file[:filename])
    dest_format = params[:dest_format]
    if ["Vim", "JEdit", "KatePart"].include?(dest_format)
      begin
        converter = eval("Coloration::Converters::Textmate2#{dest_format}Converter").new
        converter.feed(params[:file][:tempfile].read.force_encoding("utf-8"))
        converter.convert!
        @result = converter.result
        @notice = "Success!"
        erb :result
      rescue Coloration::Readers::TextMateThemeReader::InvalidThemeError
        @alert = "This file doesn't look like xml plist file with Textmate theme."
        erb :index
      end
    else
      self.status = 400
      "Bad request man."
    end
  else
    @alert = "Please choose a file to convert."
    erb :index
  end
end
