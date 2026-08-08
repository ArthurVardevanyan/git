resource "github_repository" "wasm" {
  # checkov:skip=CKV_GIT_1: I want the Repo to be public
  name                        = "wasm-wiretap"
  homepage_url                = ""
  description                 = "wasm wiretap, collect request/response header/body"
  visibility                  = "public"
  has_issues                  = true
  has_discussions             = false
  has_projects                = false
  has_wiki                    = false
  is_template                 = false
  allow_merge_commit          = false
  allow_squash_merge          = true
  allow_rebase_merge          = false
  allow_auto_merge            = false
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  merge_commit_title          = "MERGE_MESSAGE"
  merge_commit_message        = "PR_TITLE"
  delete_branch_on_merge      = true
  web_commit_signoff_required = true
  auto_init                   = true
  license_template            = "apache-2.0"
  archived                    = false
  archive_on_destroy          = true
  allow_update_branch         = true
  topics = [
    "wasm",
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

resource "github_repository_dependabot_security_updates" "wasm" {
  repository = github_repository.wasm.id
  enabled    = false
}

resource "github_repository_vulnerability_alerts" "wasm" {
  repository = github_repository.wasm.name
  enabled    = true
}

resource "github_branch" "wasm_main" {
  repository = github_repository.wasm.name
  branch     = "main"
}

resource "github_branch_default" "wasm" {
  repository = github_repository.wasm.name
  branch     = github_branch.wasm_main.branch

}

resource "github_branch_protection" "wasm_main" {
  # checkov:skip=CKV_GIT_5:I am a single user
  repository_id                   = github_repository.wasm.node_id
  pattern                         = github_branch.wasm_main.branch
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
    required_approving_review_count = 0
    require_last_push_approval      = false
  }

}
