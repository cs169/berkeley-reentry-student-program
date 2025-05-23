# frozen_string_literal: true

# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the landing page$/ then root_path
    when /^the profile creation page$/ then user_profile_new_path
    when /^the checkin page$/ then checkin_path
    when /^the confirm page$/ then login_confirm_path
    when /^the admin dashboard$/ then admins_path
    when /^the scholarships page$/ then scholarships_path
    when /^the courses page$/ then courses_path
    when /^the podcast page$/ then podcasts_path
    when /^the admin manage scholarships page$/ then admin_scholarships_path
    when /^the new scholarship page$/ then new_admin_scholarship_path
    when /^the edit scholarship page for "([^"]*)"$/
      scholarship = Scholarship.find_by(name: Regexp.last_match(1))
      edit_scholarship_path(scholarship)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = Regexp.last_match(1).split(/\s+/)
        send(path_components.push("path").join("_").to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
              "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
