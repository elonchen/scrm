module NotesHelper

  def link_to_customer(trackable)
    if trackable.instance_of? Customer
      link_to trackable.name, trackable
    elsif trackable.instance_of? Note and trackable.customer.instance_of? Customer
      link_to trackable.customer.name, trackable.customer
    end
  end
end
