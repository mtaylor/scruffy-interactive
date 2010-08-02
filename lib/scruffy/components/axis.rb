module Scruffy
  module Components
    class Axis < Base

      def draw(svg, bounds, options={})
        draw_x_axis = options[:x_axis] != nil ? options[:x_axis] : true
        draw_y_axis = options[:y_axis] != nil ? options[:y_axis] : true

        if draw_x_axis
          svg.line(:x1 => 0, :y1 => bounds[:height], :x2 => bounds[:width], :y2 => bounds[:height], :style => "stroke: #{options[:theme].axis.to_s}; stroke-width: 1;")
        end

        if draw_y_axis
          svg.line(:x1 => 0, :y1 => bounds[:height], :x2 => 0, :y2 => 0, :style => "stroke: #{options[:theme].axis.to_s}; stroke-width: 1;")
        end
      end
    end
  end
end