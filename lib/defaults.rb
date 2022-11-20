module Ziffers
  module Defaults

    def int_to_length(val,map=nil)
      if map
        map[val%map.length]
      else
        # ['e','q','q.','h','h.','w','w.','d','d.','l']
        # 0.125, 0.25, 0.375, 0.5, 0.75, 1.0, 1.5, 2.0, 3.0, 4.0
        k = @@rhythm_keys[val%@@rhythm_keys.length]
        @@default_durs[k.to_sym]
      end
    end

    def port(port_value)
      if !port_value
        @@default_opts.delete(:port)
      else
        @@default_opts[:port] = port_value
      end
    end

    def channel(channel_value)
      if !channel_value
        @@default_opts.delete(:channel)
      else
        @@default_opts[:channel] = channel_value
      end
    end

    def get_default_opts
      @@default_opts
    end

    def get_default(key)
      @@default_opts[key]
    end

    def list_dur_chars
      @@default_durs.to_a
    end

    def set_default_opts(opts)
      @@default_opts.merge!(opts)
    end

    def merge_synth_defaults
      @@default_opts.merge!(Hash[current_synth_defaults.to_a])
    end

    @@default_port = nil

    @@default_opts = {
      :key => :c,
      :scale => :major,
      :duration => 0.25
    }

      @@rhythm_keys = ['e','q','q.','h','h.','w','w.','d','d.','l']

      @@default_durs = {
              'm': 8.0, # 15360 ticks
              'k': 5.333, # 10240 ticks
              'l': 4.0, # 7680
              'd.': 3.0, #
              'p': 2.667, # 5120
              'd': 2.0, # 3840
              'w.': 1.5,
              'c': 1.333, # 2560
              'w': 1.0, # 1920
              'h.': 0.75,
              'y': 0.667, # 1280
              'h': 0.5, # 960 - 1/2
              'q.': 0.375,
              'n': 0.333, # 640
              'q': 0.25, # 480 - 1/4
              'e.': 1.875,
              'a': 0.167, # 320
              'e': 0.125, # 240 - 1/8
              'f': 0.083, # 160
              's': 0.0625, # 120 - 1/16
              'x': 0.042, # 80
              't': 0.031, # 60 - 1/32
              'g': 0.021, # 40
              'u': 0.016, # 30 - 1/64
              'j': 0.010, # 20
              'o': 0.005, # 10 - 1/128
              'z': 0.0 # 0
            }

      @@pitch_mappings = {
            :volca_drum => [0,1,3,5,8,10,15,18,20,25.6,26.9,28.3,29.9,31.6,33.5,35.5,37.6,39.9,42.3,44.9,47.6,50.4,53.4,56.4,59.7,63.1,66.6,70.2,74,78,82,86.2,90.6,95,99.7,104.4,109.3,114.3,119.5,124.8,130.3,135.8,141.5,147.4,153.4,159.5,165.8,172.2,178.8,185.4,192.3,199.2,206.3,213.5,220.9,228.4,236.1,243.9,251.8,259.8,268,276.4,284.9,293.5,302.2,311.1,320.1,329.3,338.6,348,357.6,367.3,377.2,387.2,397.3,407.6,418,428.5,439.2,450,461,472.1,483.3,494.7,506.2,517.8,529.6,541.5,553.6,565.6,578.1,590.6,603.2,615.9,628.8,641.8,655,668.3,681.7,695.3,709,722.9,736.8,751,765.3,779.6,794.2,808.8,823.7,838.6,853.7,868.9,884.3,899.8,915.5,931.2,947.2,963.2,979.4,995.7,1012,1029,1046,1062,1079,1097,1114,1131,1149,1167,1185,1202,1220,1239,1257,1276,1294,1313,1332,1351,1370,1390,1409,1429,1449,1469,1489,1509,1529,1550,1570,1591,1611,1633,1654,1675,1698,1718,1739,1762,1784,1806,1829,1850,1872,1896,1919,1942,1967,1989,2010,2032,2057,2082,2107,2133,2157,2179,2200,2224,2251,2277,2303,2331,2358,2382,2403,2424,2448,2476,2505,2534,2564,2595,2622,2645,2667,2688,2711,2738,2770,2801,2832,2865,2899,2931,2957,2980,3001,3021,3042,3065,3093,3158,3184,3204,3224,3265,3323,3352,3377,3399,3420,3440,3462,3485,3511,3563,3600,3621,3676,3694,3714,3771,3792,3810,3850,3934,3957,3976,3994,4011,4028,4046,4064,4164,4212,4230,4245,4326,4346,4362,4380,4398,4500]
      }

      def midi_to_cc_pitch(key, midi_note)

        arr = @@pitch_mappings[key] if key.is_a?(Symbol) and @@pitch_mappings[key]
        arr = key if key.is_a?(Array)
        if arr
          midi_hz = midi_to_hz midi_note
          cc_pitch = arr.each_with_index.min_by{|hz,cc| (midi_hz-hz).abs}
          cc_pitch[1]
        else
          raise "No valid pitch cc mapping"
        end
      end

    end
end
