variable "minimum_password_length" {
  type        = number
  description = "The minimum length required when setting a new password"
  default     = 14
}

variable "require_lowercase_characters" {
  type        = bool
  description = "Whether a lowercase letter is required when setting a new password"
  default     = true
}

variable "require_numbers" {
  type        = bool
  description = "Whether a number is required when setting a new password"
  default     = true
}

variable "require_uppercase_characters" {
  type        = bool
  description = "Whether an uppercase letter is required when setting a new password"
  default     = true
}

variable "require_symbols" {
  type        = bool
  description = "Whether a symbol (or non-alphanumeric character) is required when setting a new password.  Allowed symbols are ! @ # $ % ^ & * ( ) _ + - = [ ] { } | '"
  default     = true
}

variable "allow_users_to_change_password" {
  type        = bool
  description = "Whether a user is allowed to change their password"
  default     = true
}

variable "password_reuse_prevention" {
  type        = number
  description = "The number of previous passwords that cannot be reused"
  default     = 24
}

variable "max_password_age" {
  type        = number
  description = "The age in days before a password expires and must be changed at next login"
  default     = 90
}

variable "hard_expiry" {
  type        = bool
  description = "Whether users are prevented from setting a new password after their password has expired (i.e. requires administrator reset)"
  default     = false
}
