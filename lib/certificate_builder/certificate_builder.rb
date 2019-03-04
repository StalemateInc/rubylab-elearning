# frozen_string_literal: true

require 'combine_pdf'
require 'yaml'
require 'certificate_builder/certificate_stamp_creator'
require 'certificate_builder/intersectable'

class CertificateBuilder
  include Intersectable
  attr_reader :stamp_path, :template_path

  def initialize(data)
    @data = data
  end

  def build
    puts __dir__
    stamp_file = create_stamp
    stamp = CombinePDF.load(stamp_file).pages[0]
    config = intersect(YAML.load(File.read(Rails.root + 'lib/certificate_builder/builder_options.yml'))[:builder], @data)
    out = CombinePDF.load(Rails.root + "#{config[:template_path]}/#{config[:template_name]}")
    out.pages.each { |page| page << stamp }
    out.save "#{Rails.root}/#{config[:save_path]}/#{[@data[:name], @data[:surname]].join('_').downcase}_#{Time.now.to_i}.pdf"
    File.delete(stamp_file) if File.exist?(stamp_file)
  end

  private

  def create_stamp
    stamp_creator = CertificateStampCreator.new(@data)
    stamp_creator.create
  end

end
