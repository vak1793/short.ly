require 'rails_helper'

RSpec.describe Link do
  describe '#extract_domain_name' do
    let(:link) { Link.new }
    let(:with_long) { 'http://www.google.com' }
    let(:with_cctld) { 'http://www.google.co.in' }
    let(:with_path) { 'http://www.google.com/path/here' }

    it 'gets domain name' do
      expect(link.send(:extract_domain_name, with_long)).to eq('google.com')
    end

    it 'gets ccTLD' do
      expect(link.send(:extract_domain_name, with_cctld)).to eq('google.co.in')
    end

    it 'gets relative path' do
      expect(link.send(:extract_domain_name, with_path)).to eq('google.com/path/here')
    end
  end
end
