require './operation.rb'

describe "Analytics::Operation" do

  describe "simplify" do
    before do
      @a = "4f2764b0-0d0b-0133-d88f-7672e03e9ad0"
      @b = "5849fb30-0d0b-0133-d891-7672e03e9ad0"
      @c = "1239fb30-0d0b-0133-d891-7672e03e9ad0"
    end

    it "Not simplifiable" do
      operation = "(#{@a})+(#{@b})"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}+#{@b}")
    end

    it "Simplifiable with two vars - ex. 1" do
      operation = "(#{@a})+(#{@b})-(#{@a})"
      expect(Analytics::Operation.new.simplify operation).to eq(@b)
    end

    it "Simplifiable with two vars - ex. 2" do
      operation = "(#{@a})+(-(#{@b}))"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}-#{@b}")
    end

    it "Simplifiable with two vars - ex. 3" do
      operation = "(#{@a})+(-(#{@b}))"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}-#{@b}")
    end

    it "Simplifiable with two vars - ex. 4" do
      operation = "(#{@a})-(-(#{@b}))"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}+#{@b}")
    end

    it "Simplifiable with two vars - ex. 5" do
      operation = "(#{@a})-(+(#{@b}))"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}-#{@b}")
    end

    it "Simplifiable with three vars and parentisis subtraction" do
      operation = "(#{@a})-((#{@b})+(#{@c})"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}-#{@b}-#{@c}")
    end

    it "Simplifiable with three vars and parentisis subtraction" do
      operation = "(#{@a})-((#{@b})-(#{@c})"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}-#{@b}+#{@c}")
    end

    it "Simplifiable with three vars and parentisis subtraction" do
      operation = "(#{@a})+(-(#{@b})-(#{@c})"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}-#{@b}-#{@c}")
    end

    it "Simplifiable with three vars and parentisis subtraction" do
      operation = "(#{@a})-(-(#{@b})-(#{@c})"
      expect(Analytics::Operation.new.simplify operation).to eq("#{@a}+#{@b}+#{@c}")
    end

    it "Imopolis - Ed. Adamastor - EA+ Estacionamentos ADM" do
      operation = "(((22df03f0-beaa-0133-0d27-7672e03e9ad0)+(314ba300-beaa-0133-0d28-7672e03e9ad0))+((3e400860-beaa-0133-0d29-7672e03e9ad0)+(4cdb00f0-beaa-0133-0d2a-7672e03e9ad0))+((4b69afe0-bb8c-0133-0c93-7672e03e9ad0)-(((22df03f0-beaa-0133-0d27-7672e03e9ad0)+(314ba300-beaa-0133-0d28-7672e03e9ad0))+((3e400860-beaa-0133-0d29-7672e03e9ad0)+(4cdb00f0-beaa-0133-0d2a-7672e03e9ad0)))))+(((87739790-bb8c-0133-0c9a-7672e03e9ad0)+(b1032b90-bb8c-0133-0ca2-7672e03e9ad0))+((82cc8a10-bb8c-0133-0c99-7672e03e9ad0)+(ab700700-bb8c-0133-0ca1-7672e03e9ad0))+((7e40ddc0-bb8c-0133-0c98-7672e03e9ad0)+(a6c80af0-bb8c-0133-0ca0-7672e03e9ad0))+((7a168fb0-bb8c-0133-0c97-7672e03e9ad0)+(a1e83840-bb8c-0133-0c9f-7672e03e9ad0))+((65ee0bf0-bb8c-0133-0c95-7672e03e9ad0)+(9d17d820-bb8c-0133-0c9e-7672e03e9ad0)))+((8c413f60-bb8c-0133-0c9b-7672e03e9ad0))+((417c6e30-bb8c-0133-0c91-7672e03e9ad0)+(46545800-bb8c-0133-0c92-7672e03e9ad0))+((90e13f60-bb8c-0133-0c9c-7672e03e9ad0))+((9791cb00-bb8c-0133-0c9d-7672e03e9ad0))+((326a06d0-bb8c-0133-0c8e-7672e03e9ad0)-(((37a56d60-bb8c-0133-0c8f-7672e03e9ad0)+(3ca6e6c0-bb8c-0133-0c90-7672e03e9ad0)+(417c6e30-bb8c-0133-0c91-7672e03e9ad0)+(46545800-bb8c-0133-0c92-7672e03e9ad0)+(4b69afe0-bb8c-0133-0c93-7672e03e9ad0)+(87739790-bb8c-0133-0c9a-7672e03e9ad0)+(82cc8a10-bb8c-0133-0c99-7672e03e9ad0)+(7e40ddc0-bb8c-0133-0c98-7672e03e9ad0)+(7a168fb0-bb8c-0133-0c97-7672e03e9ad0)+(65ee0bf0-bb8c-0133-0c95-7672e03e9ad0))+((90e13f60-bb8c-0133-0c9c-7672e03e9ad0)+(9791cb00-bb8c-0133-0c9d-7672e03e9ad0)+(b1032b90-bb8c-0133-0ca2-7672e03e9ad0)+(ab700700-bb8c-0133-0ca1-7672e03e9ad0)+(a6c80af0-bb8c-0133-0ca0-7672e03e9ad0)+(a1e83840-bb8c-0133-0c9f-7672e03e9ad0)+(9d17d820-bb8c-0133-0c9e-7672e03e9ad0)+(8c413f60-bb8c-0133-0c9b-7672e03e9ad0))))"
      expect(Analytics::Operation.new.simplify operation).to eq("326a06d0-bb8c-0133-0c8e-7672e03e9ad0-37a56d60-bb8c-0133-0c8f-7672e03e9ad0-3ca6e6c0-bb8c-0133-0c90-7672e03e9ad0")
    end
  end

end
