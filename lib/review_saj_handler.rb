require "oj"

class ReviewSajHandler < Oj::Saj
  def initialize(batch_size, &block)
    @batch_size = batch_size
    @block = block
    @in_reviews_array = false
    @current_review = nil
    @batch = []
  end

  def hash_start(key)
    @current_review = {} if @in_reviews_array
  end

  def hash_end(key)
    if @in_reviews_array && @current_review
      @batch << { payload: @current_review }
      @current_review = nil

      if @batch.size >= @batch_size
        @block.call(@batch)
        @batch = []
      end
    end
  end

  def array_start(key)
    @in_reviews_array = true if key == "reviews"
  end

  def array_end(key)
    if key == "reviews"
      @in_reviews_array = false
      if @batch.any?
        @block.call(@batch)
        @batch = []
      end
    end
  end

  def add_value(value, key)
    @current_review[key] = value if @current_review && key
  end
end
