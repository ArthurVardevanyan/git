# GitHub

```bash
PROJECT_ID="$(vault kv get -field=project_id secret/gcp/org/av/projects)"
BUCKET_ID="$(vault kv get -field=bucket_id secret/gcp/org/av/projects)"

cat << EOF > backend.conf
bucket = "tf-state-github-${BUCKET_ID}"
prefix = "tofu/state/public"
EOF

tofu init -backend-config=backend.conf
tofu plan
tofu apply
```

```bash
tofu import github_repository.HomeLab HomeLab
tofu import github_repository_dependabot_security_updates.HomeLab HomeLab
tofu import github_branch.homelab_main HomeLab:main
tofu import github_branch_default.HomeLab HomeLab
tofu import github_branch_protection.homelab_main HomeLab:main

tofu import github_repository.ArthurVardevanyan ArthurVardevanyan
tofu import github_repository_dependabot_security_updates.ArthurVardevanyan ArthurVardevanyan
tofu import github_branch.ArthurVardevanyan_main ArthurVardevanyan:main
tofu import github_branch_default.ArthurVardevanyan ArthurVardevanyan
tofu import github_branch_protection.ArthurVardevanyan_main ArthurVardevanyan:main
```
