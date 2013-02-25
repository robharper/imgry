module Imgry
  module Geometry
    extend self

    def scale(orig_width, orig_height, geometry)
      # TODO: basic verification of geometry syntax
      new_width, new_height = nil, nil
      ask_width, ask_height, _, _, op = from_s(geometry)

      ask_height ||= 0
      aspect_ratio = orig_width.to_f / orig_height.to_f

      scale = Proc.new do
        ask_aspect_ratio = ask_width.to_f / ask_height.to_f
        if ask_width == 0 || (ask_height != 0 && ask_aspect_ratio > aspect_ratio)
          # Requested wider aspect, fill height, calculate width
          new_width, new_height = scale_by_height(ask_height, aspect_ratio)
        else
          # Requested taller aspect, fill width, calculate height
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

    # borrowed from RMagick
    W = /(\d+\.\d+%?)|(\d*%?)/
    H = W
    X = /(?:([-+]\d+))?/
    Y = X
    REGEXP = /\A#{W}x?#{H}#{X}#{Y}([!<>@\^]?)\Z/

    def from_s(str)
      m = REGEXP.match(str)
      if m
          width  = (m[1] || m[2]).to_f
          height = (m[3] || m[4]).to_f
          x      = m[5].to_i
          y      = m[6].to_i
          flag   = m[7]
      else
          raise ArgumentError, "invalid geometry format"
      end
      [width, height, x, y, flag]
    end

  end
end