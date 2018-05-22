require 'rails_helper'

RSpec.describe LinksController do
  describe '#index' do
    let(:expected_list) do
      [
        {
          short_url: 'test.host/short_url_1',
          long_url: 'long_url_1'
        }
      ].to_json
    end

    before do
      allow(Link)
        .to receive(:all)
        .and_return([FactoryBot.build(:link)])

      get :index
    end

    it 'returns the list of links' do
      expect(response.body).to eq(expected_list)
    end
  end

  describe '#create' do
    context 'for new url' do
      before do
        allow(Link)
          .to receive(:create!)
          .and_return(FactoryBot.build(:link))

        post :create, url: 'long_url'
      end

      it 'creates a new link' do
        expect(response.body).to eq('test.host/short_url_1')
      end
    end

    context 'for existing url' do
      before do
        allow(Link)
          .to receive(:create!)
          .and_return(FactoryBot.build(:link))

        post :create, url: 'long_url_1'
      end

      it 'creates a new link' do
        expect(response.body).to eq('test.host/short_url_1')
      end
    end
  end

  describe '#delete' do
    before do
      allow(Link)
        .to receive(:find_by)
        .and_return(FactoryBot.build(:link))

      delete :destroy, url: 'short_url_1'
    end

    it 'deletes the corresponding record' do
      expect(response.status).to eq(200)
    end
  end

  describe '#relay' do
    before do
      allow(Link)
        .to receive(:find_by)
        .and_return(FactoryBot.build(:link))

        get :relay, short_url: 'short_url'
    end

    it 'redirects to the long url' do
      expect(response).to redirect_to('long_url_1')
    end
  end
end
