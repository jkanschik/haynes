class Work < ActiveRecord::Base
  COUNTRIES = %w(Italy France Germany England Benelux Austria/Bohemia Rest)
  OBOES = ["Oboe", "Oboe d'Amore", "Grand Oboe", "Tenoroboe"]

  belongs_to  :composer
  belongs_to  :source
  has_many    :additions,               :order => 'created_at desc'
  has_many    :new_additions,           :class_name => "Addition", :conditions => "additions.state = 'new'", :order => 'created_at desc'
  has_many    :processed_additions,     :class_name => "Addition", :conditions => "additions.state = 'processed'", :order => 'created_at desc'
  has_many    :libraries_works,         :dependent => :destroy
  has_many    :publishers_works,        :dependent => :destroy
  has_many    :composers_works,         :dependent => :destroy
  has_many    :quotations_works,        :dependent => :destroy
  has_many    :instrumentations_works,  :order => "instrumentation_id", :dependent => :destroy
  has_many    :instruments_works,        :dependent => :destroy
  has_many    :downloads
  has_many    :libraries,               :through => :libraries_works
  has_many    :publishers,              :through => :publishers_works
  has_many    :composers,               :through => :composers_works
  has_many    :quotations,              :through => :quotations_works
  has_many    :instrumentations,        :through => :instrumentations_works, :order => "id"
  has_many    :instruments,              :through => :instruments_works

  has_many    :documents,               :through => :document_usages
  has_many    :document_usages,         :as => :usage
  
  has_many    :work_versions
  has_many    :work_relations
  has_many    :related_works,            :through => :work_relations


  validates_presence_of     :title,          :message => "Please enter a title."
  validates_presence_of     :composer,       :message => "Please enter a composer."

  scope :active, where(state: "default")

  def validate
    errors.add("categories", "Please enter at least one category") if instrumentations_works.size == 0
    if year  and (first_year  or last_year)
      errors.add("year", "Please enter either 'exact year (#{year})' or 'first (#{first_year}) and last year (#{last_year})'")
      errors.add("first_year", "Please enter either 'exact year (#{year})' or 'first (#{first_year}) and last year (#{last_year})'")
      errors.add("last_year", "Please enter either 'exact year (#{year})' or 'first (#{first_year}) and last year (#{last_year})'")
    end
    if first_year and last_year and first_year > last_year
      errors.add("first_year", "'last year' (#{last_year}) must be after or equal to 'first year' (#{first_year})'")
      errors.add("last_year", "'last year' (#{last_year}) must be after or equal to 'first year' (#{first_year})'")
    end
    if position_title != "" and main_title == ""
      errors.add("position_title", "'position_title' can only be filled if main_title is not empty")
    end
  end


  # Handling of versions follows:
  acts_as_versioned :association_options => {:dependent   => :nullify}
  
  def create_version
    create_version!
    true
  rescue
    false
  end

  def create_version!
    logger.debug "Create new version of Work #{id}"
    publishers_works.each {|pw| pw.save!}
    libraries_works.each {|lw| lw.save!}
    composers_works.each {|cw| cw.save!}
    instrumentations_works.each {|iw| iw.save!}
    save!
  end
  
  # TODO: Prüfen, ob Hash::diff die Arbeit nicht deutlich vereinfacht !
  # andere Möglichkeit: diff.rb in /lib
  def self.diff_arrays(old_array, new_array, old_id_column = "id", new_id_column = "id")
    # sort step
    old_array.sort! {|x,y| x.comp_id <=> y.comp_id}
    new_array.sort! {|x,y| x.comp_id <=> y.comp_id}
    diff = []
    old_index = new_index = 0
    while old_index < old_array.size or new_index < new_array.size
      old_id = old_index < old_array.size ? old_array[old_index].comp_id : nil
      new_id = new_index < new_array.size ? new_array[new_index].comp_id : nil
      if old_index < old_array.size and
         new_index < new_array.size and
         old_id == new_id
        # both have the same id
        if !Work.diff_attributes(old_array[old_index], new_array[new_index]).empty?
          diff |= [{:old => old_array[old_index], :new => new_array[new_index]}]
        end
        old_index += 1
        new_index += 1
      elsif old_index < old_array.size and 
            (new_index >= new_array.size or
             old_id < new_id)
        # old_array[old_index] has been removed
        diff |= [{:old => old_array[old_index], :new => nil}]
        old_index += 1
      elsif new_index < new_array.size and 
            (old_index >= old_array.size or
             old_id > new_id)
        # new_array[new_index] has been added
        diff |= [{:old => nil, :new => new_array[new_index]}]
        new_index += 1
      else
        throw "Unexpected situation in diff_arrays"
      end
    end

    return diff
  end
  
  def self.diff_attributes(old_obj, new_obj)
    except = [
      :created_at, :updated_at, :id, :version, :version_addition_id,
      :work_id, :libraries_work_id, :publishers_work_id, :instrumentations_work_id, 
      :intern_info_peter, :state, :intern_info_bruce,
      :done, :version_comment_id, :addition_id]
    new_attr = new_obj.attributes().delete_if {|key, value| except.include? key.to_sym}
    old_attr = old_obj.attributes().delete_if {|key, value| except.include? key.to_sym}
    diff = {}
    old_attr.each do |key, value|
      if !((value == new_attr[key]) or
           (value == nil and new_attr[key] == "") or
           (value == "" and new_attr[key] == nil))
        diff[key] = {:old => value, :new => new_attr[key]}
      end
    end
    return diff
  end

  def find_version(version)
    versions.find(:first, :conditions => {:version => version})
  end
  
  def compare_versions(old_version, new_version)
    old_work = find_version old_version
    new_work = find_version new_version

    diff = Work.diff_attributes(old_work, new_work)

    old_iws = InstrumentationsWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :instrumentations_work_id
       )
    new_iws = InstrumentationsWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => new_version},
       :order => :instrumentations_work_id
       )

    iw_diff = Work.diff_arrays(old_iws, new_iws, "instrumentations_work_id", "instrumentations_work_id")
    diff.merge!({"instrumentations" => iw_diff}) unless iw_diff.empty?
        
    old_lws = LibrariesWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :libraries_work_id
       )
    new_lws = LibrariesWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => new_version},
       :order => :libraries_work_id
       )

    lw_diff = Work.diff_arrays(old_lws, new_lws, "libraries_work_id", "libraries_work_id")
    diff.merge!({"libraries" => lw_diff}) unless lw_diff.empty?
        
    old_pws = PublishersWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :publishers_work_id)
    new_pws = PublishersWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => new_version},
       :order => :publishers_work_id)

    pw_diff = Work.diff_arrays(old_pws, new_pws, "publishers_work_id", "publishers_work_id")
    diff.merge!({"publishers" => pw_diff}) unless pw_diff.empty?
        
    old_cws = ComposersWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :composers_work_id)
    new_cws = ComposersWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => new_version},
       :order => :composers_work_id)

    cw_diff = Work.diff_arrays(old_cws, new_cws, "composers_work_id", "composers_work_id")
    diff.merge!({"composers" => cw_diff}) unless cw_diff.empty?
        
    return diff
  end
  
  
  
  
  def compare_with_version(old_version)
    logger.debug "Compare current work #{id} with version number #{old_version}."
    
    old_work = find_version(old_version)

    diff = Work.diff_attributes(old_work, self)

    old_lws = LibrariesWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :libraries_work_id
       )

    lw_diff = Work.diff_arrays(old_lws, libraries_works, "libraries_work_id", "id")
    diff.merge!({"libraries" => lw_diff}) unless lw_diff.empty?
        
    old_pws = PublishersWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :publishers_work_id)

    pw_diff = Work.diff_arrays(old_pws, publishers_works, "publishers_work_id", "id")
    diff.merge!({"publishers" => pw_diff}) unless pw_diff.empty?

    old_iws = InstrumentationsWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :instrumentations_work_id
       )

    iw_diff = Work.diff_arrays(old_iws, instrumentations_works, "instrumentations_work_id", "id")
    diff.merge!({"instrumentations" => iw_diff}) unless iw_diff.empty?

    old_cws = ComposersWorkVersion.find(
       :all,
       :conditions => {:work_id => id, :version => old_version},
       :order => :composers_work_id)

    cw_diff = Work.diff_arrays(old_cws, composers_works, "composers_work_id", "composers_work_id")
    diff.merge!({"composers" => cw_diff}) unless cw_diff.empty?

    return diff
  end
  
  
  def compare_with_previous(version)
    version == 1 ? {} : compare_versions(version-1, version) 
  end
  
  #Handling of boolean values
  def done?
    done == 'Y'
  end
  def lost?
    lost == 'Y'
  end
  def attr_doubtful?
    attr_doubtful == 'Y'
  end
  def time_doubtful?
    time_doubtful == 'Y'
  end
  
  def country_array
    return COUNTRIES.collect {|c| c if country.at(COUNTRIES.index(c)) == 'Y'}.compact if country
    return []
  end

  def oboe_array
    return OBOES.collect {|o| o if oboe.at(OBOES.index(o)) == 'Y'}.compact if oboe
    return []
  end

  
  def self.country_array_to_string(array)
    country = "N" * COUNTRIES.size
    return country unless array
    COUNTRIES.each_index do |i|
      country[i] = array.include?(COUNTRIES[i]) ? 'Y' : 'N'
    end
    return country
  end
 
  def self.oboe_array_to_string(array)
    oboe = "N" * OBOES.size
    return oboe unless array
    OBOES.each_index do |i|
      oboe[i] = array.include?(OBOES[i]) ? 'Y' : 'N'
    end
    return oboe
  end
  
  def time
    return year if year
    return "c.#{first_year}" if first_year == last_year
    return "#{first_year} - #{last_year}"
  end
  
  def identifier
    tune_label = tune? ? tune : ''
    if tune_label.length > 2
      tune_label = tune_label[0, 2]
      tune_label = tune_label + ("..")
    end
    opus_label = opus? ? opus : tune_label
    if opus_label.nil? ||opus_label == ""
      return ""
    else
      return (', ') + (opus_label)
    end
  end
  
end
