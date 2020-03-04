# frozen_string_literal: true

require_relative 'petsonic_parser.rb'
require_relative 'pet_page.rb'
require_relative 'record_to_file.rb'

if ARGV.empty?
  puts 'Для запуска необходимо указать дополнительно в аргументах:
        ссылку на страницу категории
        имя файла в который будет записан результат
        (если не указан, результат будет записан в файл rezult.csv)'
  puts 'Пример: ruby app.rb https://SITE_URL FILENAME'
  exit
end

SITE_URL = 'https://www.petsonic.com'

raise 'InvalidURLError' unless URI.parse(ARGV[0]).is_a?(URI::HTTP)

unless ARGV[0].include?('petsonic.com')
  puts "It's intended for #{SITE_URL}. Won't work with other resources."
  exit
end

INPUT_URL = ARGV[0].freeze

FILENAME = if ARGV[1] && !ARGV[1].to_s.strip.empty?
             if ARGV[1].include?('.csv')
               ARGV[1].freeze
             else
               ARGV[1].freeze + '.csv' unless ARGV[1].include?('.csv')
             end
           else
             'result.csv'
           end

RecordToFile.save_as_csv_file
