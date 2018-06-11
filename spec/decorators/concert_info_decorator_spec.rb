require 'rails_helper'

describe ConcertInfoDecorator do
  let(:concert_info) { ConcertInfo.new.extend ConcertInfoDecorator }
  subject { concert_info }
  it { should be_a ConcertInfo }
end
