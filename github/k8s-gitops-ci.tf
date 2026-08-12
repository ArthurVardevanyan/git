resource "github_repository" "k8s_gitops_ci" {
  # checkov:skip=CKV_GIT_1: I want the Repo to be public
  name                        = "k8s-gitops-ci"
  homepage_url                = "https://www.arthurvardevanyan.com/k8s_gitops_ci.html"
  description                 = "Kubernetes GitOps CI engine"
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
  auto_init                   = false
  license_template            = "apache-2.0"
  archived                    = false
  archive_on_destroy          = true
  allow_update_branch         = true
  topics = [
    "kubernetes",
    "gitops",
    "ci-cd",
    "devops",
    "go",
    "yaml",
    "continuous-integration",
    "continuous-delivery",
    "automation",
    "infrastructure-as-code",
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

resource "github_repository_dependabot_security_updates" "k8s_gitops_ci" {
  repository = github_repository.k8s_gitops_ci.id
  enabled    = false
}

resource "github_repository_vulnerability_alerts" "k8s_gitops_ci" {
  repository = github_repository.k8s_gitops_ci.name
  enabled    = true
}

resource "github_branch" "k8s_gitops_ci_main" {
  repository = github_repository.k8s_gitops_ci.name
  branch     = "main"
}

resource "github_branch_default" "k8s_gitops_ci" {
  repository = github_repository.k8s_gitops_ci.name
  branch     = github_branch.k8s_gitops_ci_main.branch

}

resource "github_branch_protection" "k8s_gitops_ci_main" {
  # checkov:skip=CKV_GIT_5:I am a single user
  repository_id                   = github_repository.k8s_gitops_ci.node_id
  pattern                         = github_branch.k8s_gitops_ci_main.branch
  enforce_admins                  = false
  require_signed_commits          = true
  required_linear_history         = true
  require_conversation_resolution = true
  # force_push_bypassers = [
  #   "/ArthurVardevanyan"
  # ]
  allows_deletions    = false
  allows_force_pushes = false
  lock_branch         = false
  required_status_checks {
    contexts = [
      "Pipelines as Code / k8s-gitops-ci",
    ]
    strict = true
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    dismissal_restrictions          = []
    pull_request_bypassers          = []
    require_code_owner_reviews      = true
    required_approving_review_count = 1
    require_last_push_approval      = true
  }

}

resource "github_repository_ruleset" "k8s_gitops_ci_copilot_review" {
  name        = "copilot-code-review"
  repository  = github_repository.k8s_gitops_ci.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    copilot_code_review {
      review_draft_pull_requests = false
      review_on_push             = true
    }
  }

}
