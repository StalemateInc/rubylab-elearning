# frozen_string_literal: true

require 'prawn'
require 'prawn/measurement_extensions'
require 'certificate_builder/intersectable'

class CertificateStampCreator
  include Intersectable

  def initialize(data)
    @data = data
    @config = intersect(YAML.load(File.read(Rails.root + 'lib/certificate_builder/builder_options.yml'))[:stamp_creator], @data)
  end

  def create
    data = @data
    name = "#{Rails.root}/#{@config[:stamp_path]}/#{@config[:stamp_name]}-#{Time.now.to_i}.pdf"
    sign = "#{Rails.root}/#{@config[:sign_path]}/#{@config[:sign_name]}"
    # fonts = @config[:fonts]
    sizes = @config[:font_sizes]
    colors = @config[:colors]
    Prawn::Document.generate(name, page_size: [215.9.mm, 302.77.mm], page_layout: :landscape) do
      font(__dir__ + '/fonts/Montserrat-Regular.ttf')
      move_down 60.mm
      text "#{data[:name]} #{data[:surname]}", size: sizes[:name], color: colors[:dark_blue], align: :center
      move_up 60.mm
      move_down 90.mm
      text "Course\n\"#{data[:course]}\"", size: sizes[:course], color: colors[:dark_blue], align: :center
      move_up 90.mm
      move_down 92.mm
      text data[:date], size: sizes[:date], color: colors[:dark_blue], align: :center
      move_up 92.mm
      move_down 112.mm
      indent(90.mm) do
        text data[:grade], size: sizes[:grade], color: colors[:dark_blue]
      end
      move_up 15.mm
      indent(165.mm) do
        image File.open(sign, 'r'), fit: [100, 100]
      end
    end
    name
  end

end
