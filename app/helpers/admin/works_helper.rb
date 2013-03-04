module Admin::WorksHelper

  def country_checkbox(country)
    country = Work::COUNTRIES[country]
    checked = "checked='checked'" if @work.country_array.include?(country)
    <<-EOHTML
      <label for="country_#{country}">#{country}:</label>
    <input
          type="checkbox" id="country_#{country}" 
          name="country[#{country}]"
          #{checked}
          />
       
    EOHTML
  end  

  def oboe_checkbox(oboe)
    oboe = Work::OBOES[oboe]
    checked = "checked='checked'" if @work.oboe_array.include?(oboe)
    <<-EOHTML
      <label for="oboe_#{oboe}">#{oboe}:</label>
   <input
          type="checkbox" id="oboe_#{oboe}" 
          name="oboe[#{oboe}]"
          #{checked}
          />
      
    EOHTML
  end  


end