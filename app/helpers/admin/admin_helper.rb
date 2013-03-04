module Admin::AdminHelper

  def publishers
    Publisher.find(:all, :order => "label").map {|l| [l.label, l.id]}
  end
  
  def libraries
    Library.find(:all, :include => :country, :order => "countries.code, code_place").map {|l| ["#{l.nice_label} (#{l.label || '--'})", l.id]}
  end
  
  def countries
    Country.find(:all, :order => "code").map {|c| ["#{c.code} (#{c.label})", c.id]}
  end
  
  def categories
    ["publisher", "citation" , "privat", "uncertain"]
  end
  
  def altcomp_categories
    ["also attributed to",
    "mistakenly attributed to",
    "together with",
    "arranged by"
    ]
  end

  def download_kind
    ["Score",
    "Parts",
    "Score and Parts"
    ]
  end
end