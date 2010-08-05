module Scruffy
  module Components
    class ValueMarkers < Base
      attr_accessor :markers
      attr_accessor :marker_values

      def draw(svg, bounds, options={})
        @marker_values = options[:marker_values] ? options[:marker_values] : nil
        @markers = options[:markers] ? options[:markers] : 5

        if @marker_values
          draw_marker_values(@marker_values, bounds, svg, options)
        else
          all_values = []
          inc = (options[:max_value] - options[:min_value]) / (@markers - 1)
          for i in 0...@markers
            all_values << (inc * i)
          end
          draw_marker_values(all_values, bounds, svg, options)
        end
      end

      private
      def draw_marker_values(marker_values, bounds, svg, options={})
        count = 0
        marker_values.each do |mv|
          # The Y co-ordinate of this marker
          y_coord_unit = bounds[:height] / (options[:max_value] - options[:min_value])
          marker = y_coord_unit * mv
          marker = marker - relative(3)

          # The Value of the Marker
          marker_value = mv
          marker_value = options[:value_formatter].route_format(marker_value, count, options.merge({:all_values => marker_values})) if options[:value_formatter]

          count = count + 1
          svg.text( marker_value.to_s, 
            :x => bounds[:width], 
            :y => (bounds[:height] - marker), 
            'font-size' => relative(12),
            'font-family' => options[:theme].font_family,
            :fill => ((options.delete(:marker_color_override) || options[:theme].marker) || 'white').to_s,
            'text-anchor' => 'end')
        end
      end
    end
  end
end
