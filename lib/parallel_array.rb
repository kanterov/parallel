require "parallel"

class ParallelArray < Array

    def map(&block)
        Parallel.map self, &block
    end

    def select(&block)
        Parallel.select self, &block
    end

    def all?(&block)
        Parallel.all? self, &block
    end

    def any?(&block)
        Parallel.any? self, &block
    end

end

class Array
    def pmap(&block)
        Parallel.map self, &block
    end

    def pselect(&block)
        Parallel.select self, &block
    end

    def pall?(&block)
        Parallel.all? self, &block
    end

    def pany?(&block)
        Parallel.any? self, &block
    end
end
