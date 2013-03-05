$('#schedule-company-selector').show()
companies = JSON.parse('<%=@companies.all.to_json.html_safe %>')
selector = $('#schedule-company-selector')
ul = selector.find('ul')
ul.empty()
for company in companies
  ul.append("<li><a value=#{company.id}>#{company.name}</a></li>")


select = selector.find('.bootstrap-select')
select.removeClass('active')
select.text('---')
