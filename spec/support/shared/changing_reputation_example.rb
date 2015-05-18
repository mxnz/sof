RSpec.shared_examples 'an action changing reputation' do
  it "invokes Reputaion.update_after_answer method" do
    expect(Reputation).to receive(:update_after_answer)
    action
  end

  it "changes answer's author rating by Reputation.after_answer(...) value" do
    allow(Reputation).to receive(:after_answer).and_return(10)
    expect { action }.to change { author.reload.rating }.by(10)
  end
end

RSpec.shared_examples "an action not changing reputation" do
  it "doesn't invoke Reputation.update_after_answer method" do
    expect(Reputation).to_not receive(:update_after_answer)
    action
  end
end
