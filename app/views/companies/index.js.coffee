$('#schedule-company-selector').show()
companies = JSON.parse('<%=@companies.all.to_json.html_safe %>')

ul = $('#schedule-company-selector').find('ul')
ul.empty()
for company in companies
  ul.append("<li><a value=#{company.id}>#{company.name}</a></li>")