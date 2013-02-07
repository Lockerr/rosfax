class CityConstraints
  def initialize
    @names = Company.all.map(&:name)
  end

  def matches?(request)
    @names.include?(request.params[:company])
  end
end