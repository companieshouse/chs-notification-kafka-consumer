locals {
  tags = merge(
    {
        "Name" = var.name
    },
    var.tags_as_map
  )
}
