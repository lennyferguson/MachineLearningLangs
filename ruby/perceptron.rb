class Perceptron
  attr_reader :training_error

  def initialize(training_data,weight_dim, gamma = 1.0, epochs = 1)
    @w = MlVec.new(Array.new(weight_dim))
    incorrect = 0;
    (0...epochs).each() do
      training_data.shuffle().each() do |example|
        y_prime = @w.dot(example.vec)
        if y_prime * example.label < 0
          incorrect++;
          @w = @w + example.label * gamma * example.data
        end
      end
    end
  end

  def label(vec)
    sgn(@w.dot(vec))
  end

  def sgn(val)
    (0 < val ? 1 : 0) - (val < 0 ? 1 : 0)
  end

end
