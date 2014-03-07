module ActiveAdmin
  module Views
    class IndexAsMap < ActiveAdmin::Component

      def build(page_presenter, collection)
        render 'shared/map', objects: collection, width: '100%'
      end

      def self.index_name
        "Map"
      end
    end
  end
end
