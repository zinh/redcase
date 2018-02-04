
# This patch adds TestCase linkage to Issue
module Redcase
  module IssuePatch

    def self.included(base)
      base.class_eval do
        # One-to-one relationship: (1)Issue <=> (1)TestCase
        has_one :test_case, :dependent => :destroy
      end
    end

  end
end
Issue.send(:include, Redcase::IssuePatch)
