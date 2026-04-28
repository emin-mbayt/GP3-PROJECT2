locals {
  # Base naming prefix: <project>-<env>-group-3  e.g. "proj2-dev-group-3"
  prefix = "${var.project_name}-${var.environment}-group-3"

  # 6-char random suffix for globally-unique resource names (SQL Server, KV).
  # Sourced from the random_string resource declared in main.tf.
  suffix = random_string.suffix.result

  # Common tag map applied to every resource.
  tags = merge(
    {
      project     = var.project_name
      environment = var.environment
      managed_by  = "terraform"
      owner       = var.owner
    },
    var.tags_extra,
  )
}
