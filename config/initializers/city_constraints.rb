class CityConstraints
  def initialize
    @names = Center.all.map(&:name)
  end

  def matches?(request)
    @names.include?(request.params[:center])
  end
end