module Parallel
    DEFAULT_THREADS_COUNT = 2

    def self.parallel(array, count=DEFAULT_THREADS_COUNT)
        raise ArgumentError, "Illegal arguments!" if count == 0

        array = array.to_a

        return [] if array.empty?

        partitions = array.each_slice((array.length + count - 1) / count).to_a
        threads = (0..count-1).map {|i|
            Thread.new do
                yield(partitions[i] || [])
            end
        }

        threads.compact.map {|thread| thread.value}.flatten(1)
    end

    def self.map(array, count=DEFAULT_THREADS_COUNT, &block)
        parallel(array, count) {|partition| partition.map &block}
    end

    def self.select(array, count=DEFAULT_THREADS_COUNT, &block)
        parallel(array, count) {|partition| partition.select &block}
    end

    def self.any?(array, count=DEFAULT_THREADS_COUNT, &block)
        parallel(array, count) {|partition| partition.any? &block}.any?
    end

    def self.all?(array, count=DEFAULT_THREADS_COUNT, &block)
        parallel(array, count) {|partition| partition.all? &block}.all?
    end

end
