#encoding: utf-8
class LoadCities < ActiveRecord::Migration
  def up
    City.delete_all
    ['Москва','Санкт-Петербург','Челябинск','Екатеринбург','Ростов-на-Дону','Казань','Новосибирск','Уфа','Воронеж','Краснодар','Нижний Новгород','Саратов','Пермь','Красноярск','Хабаровск','Самара','Тула','Волгоград','Омск','Тюмень'].each {|name| City.create(name: name)}
  end
end
