require "spec_helper"

describe Jets::Call do
  let(:call) do
    call = Jets::Call.new(function_name, event, options)
    allow(call).to receive(:lambda).and_return(null)
    call
  end
  let(:function_name) { "posts_controller-index" }
  let(:null) { double(:null).as_null_object }
  let(:options) { {} }

  context "empty event" do
    let(:event) { nil }

    it "puts out response event" do
      call.run
    end
  end

  context "controller event payload" do
    let(:event) { '{"id":"tung"}' }

    it "transforms controller event payload to lambda proxy format" do
      text = call.transformed_event
      event = JSON.load(text)
      expect(event["queryStringParameters"]).to eq("id" => "tung")
    end
  end

  context "job event payload" do
    let(:function_name) { "hard-job-dig" }
    let(:event) { '{"id":"tung"}' }

    it "leaves event payload untouched" do
      text = call.transformed_event
      expect(text).to eq event
    end
  end
end