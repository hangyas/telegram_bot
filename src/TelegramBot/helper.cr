macro force_getter!(*names)
    {% for name in names %}
      def {{name.id}}!
        if {{name.id}} = @{{name.id}}
          return {{name.id}}
        else
          raise Exception.new("")
        end
      end
    {% end %}
  end

# writes basic initializer from properti maps used by JSON.mapping
# TODO steel have to find out how to handle properties with constant value like `@type = "article"`
macro initializer_for(properties)
  {% for key, value in properties %}
    {% properties[key] = {type: value} unless value.is_a?(NamedTupleLiteral) %}
  {% end %}

  def initialize(
    {% for key, value in properties %}
        @{{key.id}} : {{ (value[:nilable] ? "#{value[:type]}? = nil, " : "#{value[:type]},").id }}
    {% end %}
    )
  end
end
