require './operation.rb'

describe "Analytics::Operation" do

  describe "simplify" do
    before do
      @a = "4f2764b0-0d0b-0133-d88f-7672e03e9ad0"
      @b = "5849fb30-0d0b-0133-d891-7672e03e9ad0"
    end

    it "Not simplifiable" do
      operation = "(#{@a})+(#{@b})"
      expect(Analytics::Operation.simplify operation).to eq("#{@a}+#{@b}")
    end

    it "Simplifiable with two vars" do

      operation = "(#{@a})+(#{@b})-(#{@a})"
      expect(Analytics::Operation.simplify operation).to eq(@b)
    end
  end

end
