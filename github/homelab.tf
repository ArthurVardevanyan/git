resource "github_repository" "HomeLab" {
  # checkov:skip=CKV_GIT_1: I want the Repo to be public
  name                                    = "HomeLab"
  homepage_url                            = "https://www.arthurvardevanyan.com/homelab.html"
  description                             = "HomeLab Server & Desktop Configuration"
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
  topics = [
    "homelab",
    "kubernetes",
    "okd",
    "terraform",
  ]

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

}

resource "github_repository_dependabot_security_updates" "HomeLab" {
  repository = github_repository.HomeLab.id
  enabled    = true
}

resource "github_branch" "homelab_main" {
  repository = github_repository.HomeLab.name
  branch     = "main"
}

resource "github_branch_default" "HomeLab" {
  repository = github_repository.HomeLab.name
  branch     = github_branch.homelab_main.branch

}

resource "github_branch_protection" "homelab_main" {
  # checkov:skip=CKV_GIT_5:I am a single user
  repository_id                   = github_repository.HomeLab.node_id
  pattern                         = github_branch.homelab_main.branch
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
