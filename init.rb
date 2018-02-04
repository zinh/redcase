require 'redmine'
require 'redcase_override'

Redmine::Plugin.register :redcase do

  name 'Redcase'
  description 'Test cases management plugin for Redmine'
  author 'Bugzinga Team'
  version '1.0'

  permission :view_test_cases, {
    :redcase => [
      :index,
      :get_attachment_urls
    ],
    'redcase/environments' => [
      :index
    ],
    'redcase/testsuites' => [
      :index
    ],
    'redcase/testcases' => [
      :index
    ],
    'redcase/executionjournals' => [
      :index
    ],
    'redcase/export' => [
      :index
    ],
    'redcase/executionsuites' => [
      :index,
      :show
    ],
    'redcase/graph' => [
      :show
    ],
    'redcase/combos' => [
      :index
    ]
  }

  permission :edit_test_cases, {
    :redcase => [
      :index,
      :get_attachment_urls
    ],
    'redcase/environments' => [
      :index,
      :update,
      :destroy,
      :create
    ],
    'redcase/testsuites' => [
      :index,
      :update,
      :destroy,
      :create
    ],
    'redcase/testcases' => [
      :index,
      :update,
      :destroy,
      :copy
    ],
    'redcase/executionjournals' => [
      :index
    ],
    'redcase/export' => [
      :index
    ],
    'redcase/executionsuites' => [
      :index,
      :update,
      :destroy,
      :create,
      :show
    ],
    'redcase/graph' => [
      :show
    ],
    'redcase/combos' => [
      :index
    ]
  }

  permission :execute_test_cases, {
    :redcase => [
      :index,
      :get_attachment_urls
    ],
    'redcase/environments' => [
      :index
    ],
    'redcase/testsuites' => [
      :index
    ],
    'redcase/testcases' => [
      :index,
      :update
    ],
    'redcase/executionjournals' => [
      :index
    ],
    'redcase/export' => [
      :index
    ],
    'redcase/executionsuites' => [
      :index
    ]
  }

  menu :project_menu,
    :redcase, {
    :controller => 'redcase',
    :action => 'index'
  }, {
    :if => proc { |p|
      can_view = User.current.allowed_to?(:view_test_cases, p)
      can_edit = User.current.allowed_to?(:edit_test_cases, p)
      tracker_exists = p.trackers.any? { |t| (t.name == 'Test case') }
      (can_view || can_edit) && tracker_exists
    },
    :caption => 'Test cases',
    :after => :new_issue
  }
  ActionDispatch::Callbacks.to_prepare do
    require 'redcase/issue_patch'
    require 'redcase/project_patch'
    require 'redcase/version_patch'
    require 'redcase/user_patch'
  end
end

