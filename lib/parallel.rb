module Parallel
    DEFAULT_THREADS_COUNT = 2

    def self.parallel(count=DEFAULT_THREADS_COUNT)
        raise ArgumentError, "Illegal arguments!" if count == 0

        out = []
        threads = (0..count-1).map { |i|
            Thread.new do
                result = yield(i)

                Thread.exclusive { out[i] = result }
            end
        }
        
        join_threads(threads)

        out.flatten(1)
    end

    def self.join_threads(threads)
        threads.compact.each do |thread|
            begin
                thread.join
            rescue Interrupt
                # ok, wait for others
            end
        end
    end

    def self.map(array, count=DEFAULT_THREADS_COUNT, &block)
        raise ArgumentError, "Illegal arguments!" if count == 0

        # don't do any work for empty arrays
        return [] if array.empty?

        partitions = partition_per_thread_with_index(array, count)

        out = parallel(count) do |i|
            partition = partitions[i] || []

            partition.map do |value,index|
                args = [value]
                value = block.call(*args)

                [value, index]
            end
        end

        remove_index(out)
    end

    def self.select(array, count=DEFAULT_THREADS_COUNT, &block)
        raise ArgumentError, "Illegal arguments!" if count == 0

        # don't do any work for empty arrays
        return [] if array.empty?

        partitions = partition_per_thread_with_index(array, count)

        out = parallel(count) do |i|
            partition = partitions[i] || []

            partition.select do |value,index|
                args = [value]
                block.call(*args)
            end
        end

        remove_index(out)
    end

    def self.any?(array, count=DEFAULT_THREADS_COUNT, &block)
        raise ArgumentError, "Illegal arguments!" if count == 0

        # don't do any work for empty arrays
        return false if array.empty?

        partitions = partition_per_thread(array, count)

        out = parallel(count) do |i|
            partition = partitions[i] || []

            partition.any? &block
        end

        out.any?
    end

    def self.all?(array, count=DEFAULT_THREADS_COUNT, &block)
        raise ArgumentError, "Illegal arguments!" if count == 0

        # don't do any work for empty arrays
        return true if array.empty?

        partitions = partition_per_thread(array, count)

        out = parallel(count) do |i|
            partition = partitions[i] || []

            partition.all? &block
        end

        out.all?
    end

    # returns array of enumerables
    def self.partition_per_thread_with_index(array, count)
        array = array.to_a
        array.each_with_index.each_slice((array.length + count - 1) / count).to_a
    end

    # returns array of enumerables
    def self.partition_per_thread(array, count)
        array = array.to_a
        array.each_slice((array.length + count - 1) / count).to_a
    end

    def self.remove_index(out)
        out.sort_by {|value,index| index}
           .map     {|value,index| value}
    end

end
