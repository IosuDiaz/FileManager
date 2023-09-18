require 'date'
require_relative 'app/models/file_manager'
require_relative 'app/models/item'
require_relative 'app/models/folder'
require_relative 'app/models/file_item'
require_relative 'app/models/user'
require 'byebug'

# Ejemplo de uso
file_manager = FileManager.new

loop do
  print '> '
  input = gets.chomp
  result = file_manager.execute_command(input)
  puts result if result.is_a?(String)
end
