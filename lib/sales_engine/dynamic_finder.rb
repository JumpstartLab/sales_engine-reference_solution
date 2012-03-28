module SalesEngine
  class DynamicFinder
    attr_reader :finder_method, :attribute

    def initialize(method_name)
      @method_name = method_name
    end

    def match?
      match_find_by || match_find_all_by || false
    end

    def match_find_by
      if @attribute = /\Afind_by_(?<attr>\w+)/ =~ @method_name && attr
        @finder_method = :find
      end
    end

    def match_find_all_by
      if @attribute = /\Afind_all_by_(?<attr>\w+)/ =~ @method_name && attr
        @finder_method = :find_all
      end
    end
  end
end