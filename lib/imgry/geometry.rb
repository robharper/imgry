module Imgry
  module Geometry
    extend self

    def scale(orig_width, orig_height, geometry)
      op = geometry[-1] # Expecting !, >, <, or nothing
      new_width, new_height = nil, nil
      ask_width, ask_height = geometry.split('x').map {|x| x.to_i }
      ask_height ||= 0
      aspect_ratio = orig_width.to_f / orig_height.to_f
      
      scale = Proc.new do
        if ask_width == 0 || ask_width < ask_height
          new_width, new_height = scale_by_height(ask_height, aspect_ratio)
        else
          new_width, new_height = scale_by_width(ask_width, aspect_ratio)
        end
      end

      case op
      when '!'
        new_width, new_height = ask_width.to_i, ask_height.to_i
      when '>'
        scale.call if orig_width > ask_width || orig_height > ask_height
      when '<'
        scale.call if orig_width < ask_width || orig_height < ask_height
      else
        scale.call
      end

      [new_width || orig_width, new_height || orig_height]
    end

    def scale_by_width(new_width, aspect_ratio)
      [new_width.to_i, (new_width / aspect_ratio).to_i]
    end

    def scale_by_height(new_height, aspect_ratio)
      [(new_height * aspect_ratio).to_i, new_height.to_i]
    end

  end
end