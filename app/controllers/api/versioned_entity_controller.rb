class Api::VersionedEntityController < Api::ApiController

protected

  def without_version
    klazz = entity_class()
    klazz.without_locking do
      klazz.without_revision do
        yield
      end
    end
  end
  
end
