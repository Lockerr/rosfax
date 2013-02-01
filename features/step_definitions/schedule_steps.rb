# encoding: utf-8
Допустим /^я создал компанию$/ do
  @company = Company.create(:name => 'Уах', :city => 'Челябинск')
end

Допустим /^я создал scedule на завтра для этой компании$/ do
  @schedule = @company.schedules.create(:name => 'Антон', :phone => '+7 908 815 51 07', :inspection_start_time => Time.new('2013', 1, 2, 10), :confirmed => false)
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
  click_on(arg1)
end

То /^я должен увидеть '(.*?)'$/ do |arg1|
  page.should have_content arg1
end


То /^шедуля должна быть верифицирована$/ do
  page.should have_selector('#unconfirm')
end

Если /^я нажму на шедулю$/ do
  click_on('change_time')
end

То /^я должен увидеть подробности шедули$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^я нажму изменить время$/ do
  pending # express the regexp above with the code you wish you had
end

То /^шедуля должна подсветиться$/ do
  pending # express the regexp above with the code you wish you had
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



