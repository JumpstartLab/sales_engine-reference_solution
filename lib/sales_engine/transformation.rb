module SalesEngine
  class Transformation
    def initialize(name, value)
      @name, @value = name, value
    end

    def transform
      transformation_method = {
        id: Object.method(:Integer),
        created_at: DateTime.method(:parse),
        updated_at: DateTime.method(:parse)
      }.fetch(@name) { return @value }

      transformation_method.call(@value)
    end
  end
end