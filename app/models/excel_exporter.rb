class Excel_Exporter
	unloadable
		
	public
	def self.exportTestResults(project_id, suite_id, version_id, environment_id)
		issues = Issue.find_all_by_project_id(project_id, :order => 'id asc').collect { |issue| issue.id }
		test_cases = TestCase.find(:all, :conditions => { :issue_id => issues })
		versions = Version.find(version_id)
		environments = ExecutionEnvironment.find(environment_id)
		rows = []
		rows << (["ID"] + ["Suite"] + ["Title"] + ["#{versions.name}"+"(#{environments.name})"] + ["Comment"]).flatten
		test_cases = test_cases.sort! { |a, b| a.test_suite.name <=> b.test_suite.name }
		test_cases.each { |test_case|
			if (suite_id.to_i < 0 or test_case.in_suite?(suite_id.to_i, project_id))
				row = []
				row << "##{test_case.issue.id}"
				row << test_case.test_suite.name
				row << "#{test_case.issue.subject}"
				found = ExecutionJournal.find_by_test_case_id_and_environment_id_and_version_id(test_case.id, environments.id, versions.id, :order => 'created_on desc')
				row << ((not found) ? "Not Executed" : found.result.name)
				if not (found.nil?)
					if not (found.comment.nil?)
						row << (found.comment)
					else
						row << ""
					end

				else
					row << ""
				end
				rows << row.clone
			end
		}
		buffer = ''
		rows.each { |row| buffer += CSV.generate_line(row) }
		return buffer
	end	
end