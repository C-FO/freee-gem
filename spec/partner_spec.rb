require 'spec_helper'

describe Freee::Partner do
  let(:client_id) { get_client_id }
  let(:secret_key) { get_secret_key }
  let(:token) { get_token }
  let(:company_id) { get_company_id }
  let(:partner) { Freee::Partner }

  before(:each) do
    Freee::Base.config(client_id, secret_key, token)
  end

  describe 'should can be able to create instance' do
    subject { partner.list(company_id) }
    it { is_expected.not_to be_nil }
    it { is_expected.to be_instance_of(Freee::Response::Partner) }
  end

  describe 'should get partners of first item for the company' do
    subject { partner.list(company_id)['partners'].first }

    it { is_expected.not_to be_nil }
    it { is_expected.to include('id') }
    it { is_expected.to include('company_id') }
    it { is_expected.to include('name') }
    it { is_expected.to include('shortcut1') }
    it { is_expected.to include('shortcut2') }
  end
end
