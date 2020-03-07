# frozen_string_literal: true

# Showing progress notifications
class Informer
  class << self
    def start_message
      puts I18n.t(:start)
    end

    def result_reading_message(products_num, pages_num)
      puts "#{products_num} "\
           "#{I18n.t('result_reading_page.found')} "\
           "#{pages_num} #{I18n.t('result_reading_page.pages')}."
    end

    def processing_message(index, all_num, link)
      puts "#{I18n.t('is_processed.text')} "\
           "#{index + 1} #{I18n.t('is_processed.pretext')} #{all_num} - "\
           "#{link}"
    end

    def write_data_message
      puts I18n.t(:record)
    end

    def finish_message
      puts I18n.t(:finish)
    end

    def bye_message
      puts I18n.t(:bye)
    end
  end
end
