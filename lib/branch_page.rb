require 'selenium-webdriver'
require 'webdriver-user-agent'
require 'page-object'

class BranchPage
  include PageObject

  text_field(:email, :name => 'email')
  text_field(:password, :name => 'password')
  button(:button, :value => 'Sign in')
  button(:nav_sidebar, :class => 'top-nav__sidebar-menu-icon')
  link(:live, :class => 'side-nav__item-link')
  table(:tr, :class => 'table h_mt-10')
  table(:android_text, :id => 'android-click-flow')
end
