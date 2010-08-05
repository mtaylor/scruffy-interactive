module Scruffy::Layers
  # ==Scruffy::Layers::MultiLine
  #
  # Author:: Martyn Taylor
  # Date:: August 3rd 2010
  #
  # Multi Line graph.
  class MultiLine < Base

    attr_accessor :show_points
    attr_accessor :baseline
    attr_accessor :line_colors

    def initialize(options = {}, &block)
      super(options)
      @line_colors =  options[:line_colors] ? (options[:line_colors].size == 2 ? options[:line_colors]: [:black, :red]) : [:black, :red]
      @baseline = options[:baseline] ? options[:baseline] : 100
      @show_points = options[:show_points] != nil ? options[:show_points] : true
    end

    # Renders line graph.
    def draw(svg, coords, options={})
      line_colors = [:black, :red]
      if @line_colors && @line_colors.size == 2
        line_colors = @line_colors
      end

      translated_baseline = translate_number(@baseline)
      lines = seporate_lines(translated_baseline, coords)
      lines.each do |line|
        if upper_line?(line, translated_baseline)
          draw_line(svg, line, line_colors[0], options)
        else
          draw_line(svg, line, line_colors[1], options)
        end
      end
    end

    def draw_line(svg, coords, color, options={})
      if @show_points
        coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last + relative(0.9), :r => relative(2),
                                         :style => "stroke-width: #{relative(2)}; stroke: black; opacity: 0.35;" ) }
        coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last, :r => relative(2),
                                      :style => "stroke-width: #{relative(2)}; stroke: #{color.to_s}; fill: #{color.to_s}" ) }
      end
      svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'none', :stroke => color.to_s, 'stroke-width' => relative(3) )
    end

    def seporate_lines(baseline, coords)
      lines = [[coords.first]]
      coords.each_index do |index|
        if index + 1 < coords.size
          poi = calculate_intersection(baseline, coords[index], coords[index + 1])
          if poi
            lines[lines.size] = []
            lines[lines.size - 1] << poi
            lines[lines.size - 2] << poi
          end
          lines[lines.size - 1] << coords[index + 1]
        end
      end
      lines[lines.size - 1] << coords.last
      return lines
    end

    def upper_line?(line, baseline)
      line.each do |point|
        if point[1] > baseline
          return true
        elsif point[1] < baseline
          return false
        end
      end
      return false
    end

    #FIXME Some of these methods repeat some of the MultiArea code, should be moved to a Utility Class
    def calculate_intersection(baseline, point1, point2)
      x1 = point1[0]
      y1 = point1[1]
      x2 = point2[0]
      y2 = point2[1]

      # Check whether baseline intersects with the two point line from these coords
      if ((y2 >= baseline) && (y1 < baseline)) || ((y1 >= baseline) && (y2 < baseline))
        # Calculate point of intersection
        y = baseline.to_f
        m = (y2.to_f - y1.to_f) / (x2.to_f - x1.to_f)
        c = y1.to_f

        x = (y.to_f - c.to_f) / m.to_f
        return [x + x1, y]
      elsif (y2 <= baseline) && (y1 <= baseline)
        return nil
      else
        return nil
      end
    end

    def translate_number(baseline)
      relative_percent = ((baseline == min_value) ? 0 : ((baseline.to_f - min_value.to_f) / (max_value.to_f - min_value.to_f).to_f))
      return (height.to_f - (height.to_f * relative_percent))
    end
  end
end