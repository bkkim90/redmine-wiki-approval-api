# frozen_string_literal: true

# Copyright (c) 2026 BK (bkkim90)
# Licensed under the MIT License. See LICENSE file for details.
#
# This is an unofficial companion plugin for redmine_wiki_approval
# (https://github.com/FloWalchs/redmine_wiki_approval) by Florian Walchshofer.

Redmine::Plugin.register :redmine_wiki_approval_api do
  name 'Wiki Approval API'
  author 'BK'
  description 'REST API endpoints for Wiki Approval Workflow plugin'
  version '0.3.0'
  url 'https://github.com/bkkim90/a003-wiki-approval-companion'
  requires_redmine version_or_higher: '5.0.0'
  requires_redmine_plugin :redmine_wiki_approval, version_or_higher: '0.9.0'
end
