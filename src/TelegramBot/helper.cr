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
