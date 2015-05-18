RSpec.shared_examples "an action changing answer's author reputation" do
  it "invokes Reputaion.update_after_answer method" do
    expect(Reputation).to receive(:update_after_answer)
    action
  end

  it "changes answer's author rating by Reputation.after_answer(...) value" do
    allow(Reputation).to receive(:after_answer).and_return(10)
    expect { action }.to change { author.reload.rating }.by(10)
  end
end

RSpec.shared_examples "an action not changing answer's author reputation" do
  it "doesn't invoke Reputation.update_after_answer method" do
    expect(Reputation).to_not receive(:update_after_answer)
    action
  end
end

RSpec.shared_examples "an action changing the best answer's author reputation" do
  it "invokes Reputation.update_after_best_answer" do
    expect(Reputation).to receive(:update_after_best_answer)
    action
  end

  it "changes the best answer's author rating by Reputation.after_best_answer(...) value" do
    allow(Reputation).to receive(:after_best_answer).and_return(30)
    expect { action }.to change { author.reload.rating }.by(30)
  end
end

RSpec.shared_examples "an action not changing the best answer's author reputation" do
  it "doesn't invoke Reputation.update_after_best_answer method" do
    expect(Reputation).to_not receive(:update_after_best_answer)
    action
  end
end

RSpec.shared_examples "an action changing votable's author reputation" do
  it "invokes Reputation.update_after_vote method" do
    expect(Reputation).to receive(:update_after_vote)
    action
  end

  it "changes votable's author rating by Reputation.after_vote(...) value" do
    allow(Reputation).to receive(:after_vote).and_return(20)
    expect { action }.to change { author.reload.rating }.by(20)
  end
end
