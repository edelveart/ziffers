load "~/ziffers/lib/defaults.rb"

module Ziffers
  module Grammar
    include SonicPi
    include SonicPi::Lang::WesternTheory
    include Ziffers::Defaults

    Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'ziffers.treetop')))
    Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'generative.treetop')))

    @@zparser = ZiffersParser.new
    @@rparser = GenerativeSyntaxParser.new

    def resolve_subsets(subs,divSleep)
      new_list = subs.each_with_object([]) do |z,n|
        if z[:subset]
          n.push(*resolve_subsets(z[:subset],divSleep/z[:subset].length))
        else
          z[:sleep] = divSleep
          n.push(z)
        end
      end
      new_list
    end

    # Parse shit using treeparse
    def parse_ziffers(text, opts, shared, durs)
      # TODO: Find a better way to inject parameters for the parser
      $tchordsleep = opts[:chord_sleep]
      $tshared = shared
      $topts = opts
      $topts_orig = Marshal.load(Marshal.dump(opts))
      $tarp = nil
      $default_durs = durs

      result = @@zparser.parse(text)

      if !result
        puts @@zparser.failure_reason
        puts @@zparser.failure_line
        puts @@zparser.failure_column
      end
      # Note to self: Do not call result.value more than once to avoid endless debugging.
      ziffers = ZiffArray.new(result.value)
      apply_array_transformations ziffers, opts, shared
    end

    def parse_generative(text, parse_chords=true)
      result = @@rparser.parse(text)
      # TODO: Find a better way to inject parameters for the parser
      $parse_chords = parse_chords

      if !result
        puts @@rparser.failure_reason
        puts @@rparser.failure_line
        puts @@rparser.failure_column
      end

      result.value
    end

  end
end