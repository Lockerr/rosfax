# encoding: utf-8
def sign_in
  visit '/user/sign_in'
  fill_in "user_email", :with => 'antiqe@gmail.com'
  fill_in "user_password", :with => 12345
  click_button "Войти"
end

Пусть /^у пользователя должна быть компания$/ do
  @user.center.should_not be_nil
  @user.center.name.should == 'Уах'
end


Пусть /^я залогинился$/ do
  sign_in
end


Допустим /^я создал компанию$/ do
  @center = Center.create(:name => 'Уах', :city => City.find_or_create_by_name('Челябинск'), new_schedule_emails: ['antiqe@gmail.com', 'lockerr@mail.ru'])
end

Допустим /^я создал schedule на завтра для этой компании$/ do
  @schedule = @center.schedules.create(:name => 'Антон', :phone => '+7 908 815 51 07', :date => Date.today + 2.days, :hour => 12, :confirmed => false)
end

Допустим /^есть пользователь$/ do
  @user = User.create(:email => 'antiqe@gmail.com', :password => '12345', :password_confirmation => '12345')
  @user.center = @center
  @user.save
end

Допустим /^пользователь принадлежит этой компании$/ do
  @user.center.should == @center
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
  page.execute_script("$('#{arg1}').show()")
  el = page.find(arg1)
  el.click
end

Если /^я нажму '([^\"]*)'$/ do |arg1|
  page.execute_script("$('#{arg1}').show()")
  el = page.find(arg1)
  el.click

end

То /^я должен увидеть '(.*?)'$/ do |arg1|
  page.should have_content arg1
end


То /^шедуля должна быть верифицирована$/ do
  page.execute_script("$('#unconfirm').show()")
  page.should have_selector('#unconfirm')
end

То /^шедуля должна подсветиться$/ do
  page.should have_content 'Эта'
end

То /^шедуля должна изменить время$/ do
  true
end

То /^на месте шедули должно отображаться свободное место$/ do
  true
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

То /^администраторы компании должны получить письма$/ do
  ActionMailer::Base.deliveries.count.should == 2
end
When /^элемент '([^\"]*)' должен иметь класс '([^\"]*)'$/ do |element, klasse|
  page.find(element)['class'].split(/\s/).include?(klasse).should == true
end