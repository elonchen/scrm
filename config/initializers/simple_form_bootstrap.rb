# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
   # you need an updated simple_form gem for this to work, I'm referring to the git repo in my Gemfile
  config.input_class = "form-control"

  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.label_class = "col-sm-2 control-label"
  config.wrappers :group, tag: 'div', class: "form-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder

    b.use :label
    b.use :input, wrap_with: { class: "input-group col-sm-10" }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
  end

   config.wrappers :checkbox, tag: :div, class: "form-group", error_class: "error" do |b|

    # Form extensions
    b.use :html5

    # Form components
    b.use :label
    b.wrapper tag: :div, class: "checkbox input-group" do |ba|
      ba.use :input
    end
    b.use :hint,  wrap_with: { tag: :p, class: "help-block" }
    b.use :error, wrap_with: { tag: :span, class: "help-block text-danger" }
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  #config.default_wrapper = :bootstrap
  config.default_wrapper = :group
end