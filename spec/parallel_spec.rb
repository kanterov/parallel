require "spec_helper"
require "parallel"
require "test/unit"

describe Parallel do
    def time_taken
      t = Time.now.to_f
      yield
      Time.now.to_f - t
    end

    describe :map do
        it "saves time" do
            time_taken{
                Parallel.map(['a', 'b', 'c', 'd']) { sleep 1}
            }.should < 3
        end

        it "raises when a thread raises" do
            lambda {
                Parallel.map(['a', 'b', 'c', 'd']) { |x| raise "TEST" if x == 'c' }
            }.should raise_error("TEST")
        end

        it "raises when thread count is zero" do
            lambda {
                Parallel.map([], 0) { |x| 0 }
            }.should raise_error
        end

        it "returns the same result as array" do
            Parallel.map([3, 1, 9, 8]) { |x| x + 2 }.should eq([5, 3, 11, 10])
        end

        it "returns the same result as array for []" do
            Parallel.map([]) { |x| x + 2 }.should eq([])
        end

        it "returns the same result as array for [1]" do
            Parallel.map([1]) { |x| x + 2 }.should eq([3])
        end

        it "handles enumerable" do
            Parallel.map((0..3)) { |x| x + 1 }.should eq([1,2,3,4])
        end
    end

    describe :select do
        it "saves time" do
            time_taken{
                Parallel.select(['a', 'b', 'c', 'd']) { sleep 1}
            }.should < 3
        end

        it "raises when a thread raises" do
            lambda {
                Parallel.select(['a', 'b', 'c', 'd']) { |x| raise "TEST" if x == 'c' }
            }.should raise_error("TEST")
        end

        it "raises when thread count is zero" do
            lambda {
                Parallel.select([], 0) { |x| 0 }
            }.should raise_error
        end

        it "returns the same result as array" do
            Parallel.select([3, 1, 9, 8]) { |x| x.odd? }.should eq([3, 1, 9])
        end

        it "returns the same result as array for []" do
            Parallel.select([]) { |x| x.odd? }.should eq([])
        end

        it "returns the same result as array for [1]" do
            Parallel.select([1]) { |x| x.even? }.should eq([])
        end

        it "returns the same result as array for [2]" do
            Parallel.select([2]) { |x| x.even? }.should eq([2])
        end

        it "handles enumerable" do
            Parallel.select((0..3)) { |x| x.even? }.should eq([0,2])
        end
    end

    describe :all? do

        it "saves time" do
            time_taken{
                Parallel.all?(['a', 'b', 'c', 'd']) { sleep 1; true}
            }.should < 3
        end

        it "raises when a thread raises" do
            lambda {
                Parallel.all?(['a', 'b', 'c', 'd']) { |x| raise "TEST" if x == 'c' }
            }.should raise_error("TEST")
        end

        it "raises when thread count is zero" do
            lambda {
                Parallel.all?([], 0) { |x| 0 }
            }.should raise_error
        end

        it "returns the same result as array" do
            Parallel.all?([3, 1, 9, 8]) { |x| x.odd?  }.should be_false
        end

        it "returns the same result as array 2" do
            Parallel.all?([3, 1, 9, 7]) { |x| x.odd?  }.should be_true
        end

        it "returns the same result as array for []" do
            Parallel.all?([]).should eq([].all?)
        end

        it "returns the same result as array for [false]" do
            Parallel.all?([false]).should eq([false].all?)
        end

        it "returns the same result as array for [true]" do
            Parallel.all?([true]).should eq([true].all?)
        end

        it "handles enumerable" do
            Parallel.all?((0..3)) { |x| x.even? }.should eq(false)
        end
    end

    describe :any? do

        it "saves time" do
            time_taken{
                Parallel.any?(['a', 'b', 'c', 'd']) { sleep 1; true}
            }.should < 3
        end

        it "raises when a thread raises" do
            lambda {
                Parallel.any?(['a', 'b', 'c', 'd']) { |x| raise "TEST" if x == 'c' }
            }.should raise_error("TEST")
        end

        it "raises when thread count is zero" do
            lambda {
                Parallel.any?([], 0) { |x| 0 }
            }.should raise_error
        end

        it "returns the same result as array" do
            Parallel.any?([3, 1, 9, 8]) { |x| x.even?  }.should be_true
        end

        it "returns the same result as array 2" do
            Parallel.any?([3, 1, 9, 7]) { |x| x.even?  }.should be_false
        end

        it "returns the same result as array for []" do
            Parallel.any?([]).should eq([].any?)
        end

        it "returns the same result as array for [false]" do
            Parallel.any?([false]).should eq([false].any?)
        end

        it "returns the same result as array for [true]" do
            Parallel.any?([true]).should eq([true].any?)
        end

        it "handles enumerable" do
            Parallel.any?((0..3)) { |x| x.even? }.should eq(true)
        end
    end

end

