require 'rails_helper'

RSpec.describe "posts/index" do
  subject { build(:post) }

  it "renders _post partial for each post" do
    assign(:posts, [subject, subject])
    render
    expect(view).to render_template(partial: '_post', count: 2)
  end

  it "displays post's title" do
    assign(:posts, [subject])
    render
    expect(rendered).to include(subject.title)
  end
end