class GenericExample
  Contract String, Bool, Args[Symbol], Float, { e: Range, f: Maybe[Num] }, Proc =>
           [Proc, Hash, Num, Range, Float, ArrayOf[Symbol], Bool, String]
  def complicated(a, b = true, *c, d, e:, f:2, **g, &h)
    h.call [h, g, f, e, d, c, b, a]
  end
end

RSpec.describe "Contracts:" do
  before :all do
    @o = GenericExample.new
  end

  describe "Required named arguments" do
    describe "really complicated method signature" do
      it "should work with default named args used" do
        expect do
          @o.complicated("a", false, :b, 2.0, e: (1..5)) { |x| x }
        end.to_not raise_error
      end

      it "should work with all args filled manually, with extra splat and hash" do
        expect do
          @o.complicated("a", true, :b, :c, 2.0, e: (1..5), f: 8.3, g: :d) do |x|
            x
          end
        end.to_not raise_error
      end

      it "should fail when the return is invalid" do
        expect do
          @o.complicated("a", true, :b, 2.0, e: (1..5)) { |_x| "bad" }
        end.to raise_error(ContractError)
      end

      it "should fail when args are invalid" do
        expect do
          @o.complicated("a", "bad", :b, 2.0, e: (1..5)) { |x| x }
        end.to raise_error(ContractError)
      end

      it "should fail when splat is invalid" do
        expect do
          @o.complicated("a", true, "bad", 2.0, e: (1..5)) { |x| x }
        end.to raise_error(ContractError)
      end

      it "should fail when named argument is invalid" do
        expect do
          @o.complicated("a", true, :b, 2.0, e: "bad") { |x| x }
        end.to raise_error(ContractError)
      end
    end
  end
end
