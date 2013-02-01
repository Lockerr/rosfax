# encoding: utf-8
Допустим /^я создал компанию$/ do
  @company = Company.create(:name => 'Уах', :city => 'Челябинск')
end

Допустим /^я создал scedule на завтра для этой компании$/ do
  @schedule = @company.schedules.create(:name => 'Антон', :phone => '+7 908 815 51 07', :inspection_start_time => Time.now.at_beginning_of_hour + 2.days, :confirmed => false)
end

Допустим /^есть пользователь$/ do
  @user = User.create(:email => 'antiqe@gmail.com', :password => '12345', :password_confirmation => '12345')
  @user.company = @company
  @user.save
end

Допустим /^пользователь принадлежит этой компании$/ do
  @user.company.should == @company
end

Если /^я зайду на '([^\"]*)'$/ do |arg1|
  visit arg1
end

То /^на странице должно быть '([^\"]*)'$/ do |arg1|
  page.should have_selector arg1
end

То /^шедуля не верифицирована$/ do
  @schedule.confirmed.should == false
end

Если /^я нажму на '([^\"]*)'$/ do |arg1|
  page.find(arg1).click
end

Если /^я нажму '([^\"]*)'$/ do |arg1|
  page.find(arg1).click
end

То /^я должен увидеть '(.*?)'$/ do |arg1|
  page.should have_content arg1
end


То /^шедуля должна быть верифицирована$/ do
  page.should have_selector('#unconfirm')
end

Если /^я нажму изменить время$/ do
  pending # express the regexp above with the code you wish you had
end

То /^шедуля должна подсветиться$/ do
  page.should have_content 'Эта'
end

Если /^я нажму место в календаре$/ do
  pending # express the regexp above with the code you wish you had
end

То /^шедуля должна изменить время$/ do
  pending # express the regexp above with the code you wish you had
end

То /^месте шедули должно отображаться свободное место$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^я нажму блокировать$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^я нажму на свободное поле на календаре$/ do
  pending # express the regexp above with the code you wish you had
end

То /^поле должно стать заблокированным$/ do
  pending # express the regexp above with the code you wish you had
end


Если /^я кликаю на 'free'$/ do
  page.find('.free').click
end

Если /^я введу в поле 'name' значение 'Антон'$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^я введу в поле 'phone' значение '\+(\d+) (\d+) (\d+) (\d+) (\d+)'$/ do |arg1, arg2, arg3, arg4, arg5|
  pending # express the regexp above with the code you wish you had
end

То /^поле должно быть заблокированным$/ do
  pending # express the regexp above with the code you wish you had
end
