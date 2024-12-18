resource "github_repository" "ArthurVardevanyan" {
  # checkov:skip=CKV_GIT_1: I want the Repo to be public
  name                                    = "ArthurVardevanyan"
  homepage_url                            = ""
  description                             = ""
  visibility                              = "public"
  has_issues                              = true
  has_discussions                         = false
  has_projects                            = false
  has_wiki                                = false
  is_template                             = false
  allow_merge_commit                      = true
  allow_squash_merge                      = true
  allow_rebase_merge                      = true
  allow_auto_merge                        = false
  squash_merge_commit_title               = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message             = "COMMIT_MESSAGES"
  merge_commit_title                      = "MERGE_MESSAGE"
  merge_commit_message                    = "PR_TITLE"
  delete_branch_on_merge                  = true
  web_commit_signoff_required             = true
  has_downloads                           = false
  auto_init                               = true
  license_template                        = "unlicense"
  archived                                = false
  archive_on_destroy                      = true
  allow_update_branch                     = true
  vulnerability_alerts                    = true
  ignore_vulnerability_alerts_during_read = false
  topics                                  = []

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

}

resource "github_repository_dependabot_security_updates" "ArthurVardevanyan" {
  repository = github_repository.ArthurVardevanyan.id
  enabled    = true
}

resource "github_branch" "ArthurVardevanyan_main" {
  repository = github_repository.ArthurVardevanyan.name
  branch     = "main"
}

resource "github_branch_default" "ArthurVardevanyan" {
  repository = github_repository.ArthurVardevanyan.name
  branch     = github_branch.ArthurVardevanyan_main.branch

}

resource "github_branch_protection" "ArthurVardevanyan_main" {
  # checkov:skip=CKV_GIT_5:I am a single user
  repository_id                   = github_repository.ArthurVardevanyan.node_id
  pattern                         = github_branch.ArthurVardevanyan_main.branch
  enforce_admins                  = false
  require_signed_commits          = true
  required_linear_history         = true
  require_conversation_resolution = true
  force_push_bypassers = [
    "/ArthurVardevanyan"
  ]
  allows_deletions    = false
  allows_force_pushes = false
  lock_branch         = false
  required_status_checks {
    strict = true
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = false
    restrict_dismissals             = false
    dismissal_restrictions          = []
    pull_request_bypassers          = []
    require_code_owner_reviews      = false
    required_approving_review_count = 1
    require_last_push_approval      = false
  }

}