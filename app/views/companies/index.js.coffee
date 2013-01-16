$('#schedule-company-selector').show()
companies = JSON.parse('<%=@companies.all.to_json.html_safe %>')
for company in companies  
  ul = $('#schedule-company-selector').find('ul')
  ul.empty()
  ul.append("<li><a href='#' data-value=#{company.id}>#{company.name}</a></li>")
  
