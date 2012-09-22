require "spec_helper"
require "parallel_array"
require "test/unit"

describe ParallelArray do

    def time_taken
      t = Time.now.to_f
      yield
      Time.now.to_f - t
    end

    describe :mixin do
        it "should do pmap" do
            [1,2,3].pmap {|x| x + 1}.should eq([2,3,4])
        end

        it "should do pany?" do
            [1,2,3].pany? {|x| x.even? }.should eq(true)
        end

        it "should do pall?" do
            [1,3].pall? {|x| x.odd? }.should eq(true)
        end

        it "should do pselect" do
            [1,2,3].pselect {|x| x.even? }.should eq([2])
        end
    end

    describe :map do
        it "should do map" do
            ParallelArray.new([1,2,3]).map {|x| x + 1}.should eq([2,3,4])
        end

        it "should save time" do
            time_taken {
                ParallelArray.new([1,2,3,4]).map { sleep 1 }
            }.should <= 3.5
        end
    end

    describe :any? do
        it "should do any?" do
            ParallelArray.new([1,2,3]).any? {|x| x.even? }.should eq(true)
        end

        it "should save time" do
            time_taken {
                ParallelArray.new([1,2,3,4]).any? { sleep 1 }
            }.should <= 3.5
        end
    end

    describe :all? do
        it "should do all?" do
            ParallelArray.new([1,3]).all? {|x| x.odd? }.should eq(true)
        end

        it "should save time" do
            time_taken {
                ParallelArray.new([1,2,3,4]).all? { sleep 1 }
            }.should <= 3.5
        end
    end

    describe :select? do
        it "should do select" do
            ParallelArray.new([1,2,3]).select {|x| x.even? }.should eq([2])
        end

        it "should save time" do
            time_taken {
                ParallelArray.new([1,2,3,4]).select { sleep 1 }
            }.should <= 3.5
        end
    end

end
